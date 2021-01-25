
gerar_n_motoristas_workblock():-
%PLACEHOLDER
    retractall(lista_motoristas_nworkblocks(_,_)),
    asserta(lista_motoristas_nworkblocks(12,[(1,2),(2,3),(3,2),(4,6)])),
    asserta(lista_motoristas_nworkblocks(13,[(1,3),(5,4),(6,5)])),
    asserta(lista_motoristas_nworkblocks(14,[(7,4),(8,4),(9,5),(10,4)])).