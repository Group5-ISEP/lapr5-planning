retirar_erros(Agenda, AgendaLimpa, ListaReatribuicao):-

    Agenda = [ (Motorista,Workblocks) | Outros ],

    sobreposicao(Workblocks, Workblocks1, Retirados1),
    %deslocacao(Workblocks1, Workblocks2, Retirados2),
    %oito_horas(Workblocks2, Workblocks3, Retirados3),
    %quatro_horas_consec(Workblocks3, Workblocks4, Retirados4),
    %uma_hora_repouso(Workblocks4, Workblocks5, Retirados5),
    write('a'), nl.





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
