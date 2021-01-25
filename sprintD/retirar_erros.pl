
retirar_erros([],[],[]):-!.
retirar_erros(Agenda, AgendaLimpa, ListaReatribuicao):-

    Agenda = [ (Motorista,Workblocks) | Outros ],

    sobreposicao(Workblocks, Workblocks1, Retirados1),
    deslocacao(Workblocks1, Workblocks2, Retirados2),
    oito_horas(Workblocks2, Workblocks3, Retirados3),
    horas_consecutivas(Workblocks3, Workblocks4, Retirados4),
    tempo_descanso(Workblocks4, Workblocks5, Retirados5),

    %Junta todos os blocos retirados
    append(Retirados1,Retirados2,Temp1),
    append(Temp1,Retirados3,Temp2),
    append(Temp2,Retirados4,Temp3),
    append(Temp3,Retirados5, TodosRetirados),
    write('================'),nl,
    write(Workblocks5),nl,
    write(TodosRetirados), nl,

    retirar_erros(Outros,AgendaLimpa1,ListaReatribuicao1),

    append([(Motorista,Workblocks5)], AgendaLimpa1, AgendaLimpa),
    append(TodosRetirados,ListaReatribuicao1, ListaReatribuicao).





%-------------------------------------------------------------------------------------------

sobreposicao([],[],[]).
sobreposicao([Workblock], [Workblock], [] ).

sobreposicao(Workblocks, Ficaram, Retirados):-
    Workblocks = [ WB1, WB2 | Resto ],

    WB1 = (_,_,_,EndTime),
    WB2 = (_,_,StartTime,_),

    (
        (
            StartTime<EndTime, %Se sobreposicao
            sobreposicao([WB2 | Resto], Ficaram, Retirados1),
            append([WB1],Retirados1, Retirados) %1º é retirado
        )
        ;
        (
            sobreposicao([WB2 | Resto], Ficaram1, Retirados),
            append([WB1], Ficaram1, Ficaram) % 1º fica
        )
    ).

%-------------------------------------------------------------------------------------------

deslocacao([],[],[]).
deslocacao([Workblock], [Workblock], [] ).

deslocacao(Workblocks, Ficaram, Retirados):-
    Workblocks = [ WB1, WB2 | Resto ],

    WB1 = (_,WBId1,_,EndTime1),
    WB2 = (_,WBId2,StartTime2,_),

    %Busca a ultima paragem do primeiro workblock e a primeira paragem do segundo workblock
    workblock(WBId1,Trips1,_,_),
    workblock(WBId2,Trips2,_,_),
    get_last(Trips1,LastTrip),
    Trips2 = [ FirstTrip | OtherTrips],
    horario(Path1,LastTrip,_),
    horario(Path2,FirstTrip,_),
    linha(_,Path1,Nos1,_,_),
    linha(_,Path2,Nos2,_,_),
    get_last(Nos1,No1),
    Nos2 = [No2 | OutrosNos],

    (
        (
            No1 = No2, % Nao é preciso deslocacao
            deslocacao([WB2 | Resto], Ficaram1, Retirados),
            append([WB1], Ficaram1, Ficaram) % 1º fica
        )
        ;
        (
            caminho_menor_tempo(EndTime1,No1,No2,_,Duracao), % É preciso deslocação, calcula tempo
            (
                (StartTime2-EndTime1)<Duracao, % Nao ha tempo suficiente para deslocacao
                deslocacao([WB2 | Resto], Ficaram, Retirados1),
                append([WB1],Retirados1, Retirados) %1º é retirado

            )
            ;
            (
                % Ha tempo para deslocacao
                deslocacao([WB2 | Resto], Ficaram1, Retirados),
                append([WB1], Ficaram1, Ficaram) % 1º fica
            )

        )

    ).

get_last(List, Last):-
    length(List,N),
    nth1(N,List,Last).

%-------------------------------------------------------------------------------

oito_horas([],[],[]).
oito_horas(Workblocks, Ficaram, Retirados):-
    oito_horas1(Workblocks,[],Ficaram,Retirados).

oito_horas1([Workblock],Retirados,[Workblock],Retirados).
oito_horas1(Workblocks,Retirados, ResultadoFicaram, ResultadoRetirados ):-
    maplist(extract_period,Workblocks,PeriodList),
    restricao_nao_passar_max_horas_totais(PeriodList,Result),

    (
        (
            Result>0,
            retirar_maior(Workblocks,WorkblocksSemMaior,MaiorWorkblock),
            oito_horas1(WorkblocksSemMaior, [MaiorWorkblock | Retirados], ResultadoFicaram,ResultadoRetirados)
        )
        ;
        ResultadoFicaram = Workblocks,
        ResultadoRetirados = Retirados
    ).

%----------------------------------------------------------------------------

horas_consecutivas([],[],[]).
horas_consecutivas(Workblocks, Ficaram, Retirados):-
    horas_consecutivas1(Workblocks,[],Ficaram,Retirados).

horas_consecutivas1([Workblock],Retirados,[Workblock],Retirados).
horas_consecutivas1(Workblocks,Retirados, ResultadoFicaram, ResultadoRetirados ):-
    maplist(extract_period,Workblocks,PeriodList),
    concatenar_blocos_consecutivos(PeriodList,PeriodListConcatenada),
    restricao_nao_passar_max_horas_consecutivas(PeriodListConcatenada,Result),

    (
        (
            Result>0,
            retirar_maior(Workblocks,WorkblocksSemMaior,MaiorWorkblock),
            horas_consecutivas1(WorkblocksSemMaior, [MaiorWorkblock | Retirados], ResultadoFicaram,ResultadoRetirados)
        )
        ;
        ResultadoFicaram = Workblocks,
        ResultadoRetirados = Retirados
    ).

%-------------------------------------------------------------------------------

tempo_descanso([],[],[]).
tempo_descanso(Workblocks, Ficaram, Retirados):-
    tempo_descanso1(Workblocks,[],Ficaram,Retirados).

tempo_descanso1([Workblock],Retirados,[Workblock],Retirados).
tempo_descanso1(Workblocks,Retirados, ResultadoFicaram, ResultadoRetirados ):-
    maplist(extract_period,Workblocks,PeriodList),
    concatenar_blocos_consecutivos(PeriodList,PeriodListConcatenada),
    restricao_nao_passar_max_horas_consecutivas(PeriodListConcatenada,Result),

    (
        (
            Result>0,
            retirar_maior(Workblocks,WorkblocksSemMaior,MaiorWorkblock),
            tempo_descanso1(WorkblocksSemMaior, [MaiorWorkblock | Retirados], ResultadoFicaram,ResultadoRetirados)
        )
        ;
        ResultadoFicaram = Workblocks,
        ResultadoRetirados = Retirados
    ).


%-------------------------------------------------------------------------------

%Mapping para as restrições
extract_period((_,_,StartTime,EndTime),(StartTime,EndTime)).
%--------------------------------------------------------------

%Retira o maior workblock da lista
retirar_maior(Workblocks,Ficam,MaiorWorkblock):-
    Workblocks = [Workblock | Resto],
    maior1(Workblocks, Workblock, MaiorWorkblock),
    subtract_once(Workblocks, [MaiorWorkblock], Ficam).

maior1([],Maior,Maior).
maior1([WorkBlock | Resto],Temp,Maior):-
    WorkBlock = (_,_,StartTime,EndTime),
    Temp = (_,_,StartTime2,EndTime2),

    Duration1 = EndTime-StartTime,
    Duration2 = EndTime2-StartTime2,

    (
        (Duration1>Duration2, maior1(Resto,WorkBlock,Maior))
        ;
        maior1(Resto,Temp,Maior)
    ).

%-----------------------------------------------------------------------------------
