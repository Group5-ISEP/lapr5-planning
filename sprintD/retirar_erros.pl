retirar_erros(Agenda, AgendaLimpa, ListaReatribuicao):-

    Agenda = [ (Motorista,Workblocks) | Outros ],

    sobreposicao(Workblocks, Workblocks1, Retirados1),
    deslocacao(Workblocks1, Workblocks2, Retirados2),
    %oito_horas(Workblocks2, Workblocks3, Retirados3),
    %quatro_horas_consec(Workblocks3, Workblocks4, Retirados4),
    %uma_hora_repouso(Workblocks4, Workblocks5, Retirados5),
    write(Workblocks2),nl,
    write(Retirados2), nl.





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
