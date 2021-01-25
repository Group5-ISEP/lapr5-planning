
% Agenda é transformar a lista de workblocks em consjuntos (Motorista, Workblock, StartTime, EndTime),
% e associar em dicionarios ( Motorista, Lista de conjuntos )

gerar_agenda_drivers(Agenda):-

    findall(
        (Motorista,Resultado),
        (
            motorista(Motorista,ListaWorkBlocks),
            agenda_driver(Motorista,ListaWorkBlocks,Resultado)
        ),
        Agenda
    ).

agenda_driver(_,[],[]):-!.
agenda_driver(Motorista, ListaWorkBlocks, [(Motorista,WorkBlock,StartTime,EndTime) | Outros]):-
    ListaWorkBlocks = [WorkBlock | Resto],

    workblock(WorkBlock,_,StartTime,EndTime),

    agenda_driver(Motorista,Resto,Outros).

