
:-[sprintb].
:-[sprintc].
:-[sprintD/gerar_motoristas_workblock].
:-[sprintD/gerar_agenda_drivers].
:-[sprintD/retirar_erros].
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
    gera_ligacoes,
    gerar_n_motoristas_workblock(),

    findall(_, (vehicleduty(Id,_), gera(Id)),_ ),

    gerar_agenda_drivers(Agenda),
    sortlen(Agenda,AgendaSorted),
    write(AgendaSorted), nl, nl,

    retirar_erros(AgendaSorted, AgendaLimpa, ListaReatribuicao),
    write(AgendaLimpa),nl,nl,write(ListaReatribuicao),nl.





