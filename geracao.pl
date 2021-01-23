%-----------------------------------------------------------------------------------------------------------------------

%---------------------%%%%%%%%%%%%%%%%%---------------------------------------------------------------------------------
%--------------------%% GERAR GERAÇÃO %%--------------------------------------------------------------------------------
%---------------------%%%%%%%%%%%%%%%%%---------------------------------------------------------------------------------

%-----------------------------------------------------------------------------------------------------------------------
% Faz N gerações
%//TODO: IMPLEMENTAR OUTROS CRITÉRIOS DE PARAGEM
%-----------------------------------------------------------------------------------------------------------------------

:- [cruzamento].
:- [mutacao].
:- [selecao].

gera_geracao(G,G,Pop):-!,
	%write('Geração '), write(G), write(':'), nl, write(Pop), nl.
	Pop = [ MelhorInd*V | _ ],
	write('Melhor: '), write(MelhorInd), write(' * '), write(V), nl,
	atualizar_motoristas(MelhorInd).
gera_geracao(N,G,Pop):-
	%write('Geração '), write(N), write(':'), nl, write(Pop), nl,
	cruzamento(Pop,NovaPop),
	mutacao(NovaPop,NovaPopMutada),
	avalia_populacao(NovaPopMutada,NPopAv),
    selecao_passa_os_n_melhores(Pop,NPopAv, Selecao),
	ordena_populacao(Selecao,SelecaoOrd),
	N1 is N+1,
	gera_geracao(N1,G,SelecaoOrd).

%-----------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------
atualizar_motoristas(MelhorInd):-
	atualizar_motoristas1(MelhorInd,0), !.

atualizar_motoristas1([],_):-!.
atualizar_motoristas1(MelhorInd,Index):-

	% Busca o workblock em Index
	vehicle_duty_id(VDId),
	vehicleduty(VDId,ListaWorkBlocks),
	nth0(Index,ListaWorkBlocks,Workblock),

	% Encaixa workblock na lista do motorista
	MelhorInd = [Motorista | Resto],
	motorista(Motorista, WorkblocksMotorista),
	adicionar_workblock(WorkblocksMotorista,Workblock,NovaLista),

	retract(motorista(Motorista,_)),
	asserta(motorista(Motorista,NovaLista)),

	write('Motorista: '), write(Motorista), write(' : '), write(NovaLista), nl,
	Index1 is Index + 1,
	atualizar_motoristas1(Resto,Index1).




adicionar_workblock([],NovoWorkBlock,NovaLista):-
	append([NovoWorkBlock],[],NovaLista).
adicionar_workblock(ListaWorkBlocks, NovoWorkBlock, NovaLista):-
	ListaWorkBlocks = [ WorkBlock | Resto ],

	workblock(NovoWorkBlock,_,StartTime1,_),
	workblock(WorkBlock,_,StartTime2,_),

	(
		( StartTime1<StartTime2, append( [NovoWorkBlock], ListaWorkBlocks, NovaLista) )
		;
		( adicionar_workblock(Resto,NovoWorkBlock,NovoResto), append( [WorkBlock],NovoResto,NovaLista) )
	),

	!.


%-----------------------------------------------------------------------------------------------------------------------
