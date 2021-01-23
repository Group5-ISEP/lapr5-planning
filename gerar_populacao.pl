%-------------------------------------------------------

%----------------------
% GERAR POPULAÇÃO
%----------------------

gera_populacao(Pop):-
    populacao(TamPop),
	vehicle_duty_id(VId),
	lista_motoristas_nworkblocks(VId,LMotoristaWorkBlock),
	sequencia_motoristas(LMotoristaWorkBlock,SeqMotoristas),
	gera_populacao(TamPop,SeqMotoristas,Pop).

%Gera uma sequencia de motoristas com base na lista de (Motorista/Num de Work blocks)
sequencia_motoristas([],[]):-!.
sequencia_motoristas(LMotoristaWorkBlock,ListaCompleta):-
    LMotoristaWorkBlock = [(Motorista,NWorkBlocks)|Resto],
    lista_elemento_repetido(Motorista,NWorkBlocks,Lista),
    append(Lista,SubLista,ListaCompleta),
    sequencia_motoristas(Resto,SubLista).

% Gera uma lista de N Elementos iguais
lista_elemento_repetido(Elemento,1,[Elemento]):-!.
lista_elemento_repetido(Elemento,N,[Elemento|Lista]):-
    N1 is N-1,
    lista_elemento_repetido(Elemento,N1,Lista).

% Gera uma lista de individuos gerados pela permutação aleatória da sequência de motoristas
% Paragem quando resta gerar 0 individuos
gera_populacao(0,_,[]):-!.
gera_populacao(TamPop,ListaMotoristas,[Ind|Resto]):-
	TamPop1 is TamPop-1,
	%Gera os outros indiviuos
	gera_populacao(TamPop1,ListaMotoristas,Resto),
	gera_individuo(ListaMotoristas,Resto,Ind).

% Gera um individuo
gera_individuo(ListaMotoristas,Resto,Ind):-
	random_permutation(ListaMotoristas,Ind),
	not(member(Ind,Resto)).
% Caso a função falhe tenta outra vez
gera_individuo(ListaMotoristas,Resto,Ind):-
	gera_individuo(ListaMotoristas,Resto,Ind).
%-------------------------------------------------------
