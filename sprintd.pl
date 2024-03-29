
:-[sprintb].
:-[sprintc].
:-[sprintD/gerar_motoristas_workblock].
:-[sprintD/gerar_agenda_drivers].
:-[sprintD/retirar_erros].
:-[sprintD/reatribuir].
:-[conhecimento].


reset_motoristas():-
    findall(
        _,
        (
            retract(motorista(Id,_)),
            asserta(motorista(Id,[]))
        ),
        _
    ).

%----------------------------------------------------------------------------------
%--Sort Agenda por Maior numero de workblocks para o menor
calcLen((K,List),(N,K,List)):- length(List,N).
delLen((_,K,List),(K,List)).

sortlen(List,Sorted):-
  maplist(calcLen,List,List1),
  sort(0,@>=,List1, List2),
  maplist(delLen,List2,Sorted).

%---------------------------------------------------------------------------------

atribuir_motoristas():-

    reset_motoristas,
    gera_ligacoes,
    gerar_n_motoristas_workblock(),

    findall(_, (vehicleduty(Id,_), gera(Id)),_ ),

    gerar_agenda_drivers(Agenda),
    sortlen(Agenda,AgendaSorted),
    write(AgendaSorted), nl, nl,

    retirar_erros(AgendaSorted, AgendaLimpa, ListaReatribuicao),
    write('================'),nl,nl,
    write('AgendaLimpa'),nl,
    write(AgendaLimpa),nl,nl,
    write('Retirados'),nl,
    write(ListaReatribuicao),nl,
    write('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%'),nl,
    write('REATRIBUIR'),nl,
    reatribuir(AgendaLimpa,ListaReatribuicao,AgendaFinal),
    write('AGENDA FINAL'),nl,
    write(AgendaFinal),nl,nl,

    write('DRIVER DUTIES'),nl,write('============================='),nl,

    traduzir_agenda_para_motoristas(AgendaFinal), !.



traduzir_agenda_para_motoristas([]).
traduzir_agenda_para_motoristas(AgendaFinal):-
    AgendaFinal = [ (Motorista, ListaWorkBlocks) | Outros],
    retract(motorista(Motorista,_)),
    maplist(workblock_para_id,ListaWorkBlocks,ListaIds),
    asserta(motorista(Motorista,ListaIds)),
    write(Motorista),write('::'),write(ListaIds),nl,

    traduzir_agenda_para_motoristas(Outros).

workblock_para_id((_,Workblock,_,_),Workblock).


