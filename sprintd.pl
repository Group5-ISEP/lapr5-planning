
:-[sprintb].
:-[sprintc].
:-[gerar_motoristas_workblock].


reset_motoristas():-
    findall(
        _,
        (
            retract(motorista(Id,_)),
            asserta(motorista(Id,[]))
        ),
        _
    ).

atribuir_motoristas():-
    gera_ligacoes,
    gerar_n_motoristas_workblock(),

    findall(_, (vehicleduty(Id,_), gera(Id)),_ ).


