
%-----------------------------------------------------------------------------------------------------------------------

% Assuma que a lista de motoristas a considerar e o nº
% de workblocks que cada um terá na solução de um
% vehicleduty é conhecido
lista_motoristas_nworkblocks(12,[(276,2),(5188,3),(16690,2),(18107,6)]).

%-----------------------------------------------------------------------------------------------------------------------

% horas_pretendidas( Motorista, LimiteInf, LimiteSup)
horas_pretendidas(276,32400,39600). %9h-11h
horas_pretendidas(5188,39600,72000). %11h-20h
horas_pretendidas(16690,32400,50400). %9h-15h
horas_pretendidas(18107,50400,75600). %14h-21h

%-----------------------------------------------------------------------------------------------------------------------

% horas_contrato( Motorista, LimiteInf, LimiteSup)
horas_contrato(276,32400,43200). %9h-12h
horas_contrato(5188,39600,72000). %11h-20h
horas_contrato(16690,32400,54000). %9h-15h
horas_contrato(18107,50400,79200). %14h-22h

%-----------------------------------------------------------------------------------------------------------------------


% parameteriza��o
geracoes(100).
populacao(100).
prob_cruzamento(0.8).
prob_mutacao(0.2).
vehicle_duty_id(12).

%-----------------------------------------------------------------------------------------------------------------------


% Restrições

inicio_periodo_almoco(39600).
fim_periodo_almoco(54000).
duracao_almoco(3600).

inicio_periodo_jantar(64800).
fim_periodo_jantar(79200).
duracao_jantar(3600).

max_horas_consecutivas(14400).
duracao_min_intervalo(3600).

max_horas_diarias(28800).

peso_max_horas_consecutivas(10).
peso_max_horas_totais(10).
peso_minimo_descanso(10).
peso_horario_pretendido(1).
peso_horario_contrato(8).

%-----------------------------------------------------------------------------------------------------------------------

% Carregar outros ficheiros
:-[conhecimento].
:- [gerar_populacao].
:- [avalia].
:- [geracao].
:- [utils].

gera:-
	%inicializa,
	gera_populacao(Pop),
	avalia_populacao(Pop,PopAv),
	ordena_populacao(PopAv,PopOrd),
	geracoes(NG),
	gera_geracao(0,NG,PopOrd), !.


%-----------------------------------------------------------------------------------------------------------------------
%--------------ORDENA POPULACAO------------------------------
%-----------------------------------------------------------------------------------------------------------------------
% (Dado no ficheiro exemplo)
%-----------------------------------------------------------------------------------------------------------------------
ordena_populacao(PopAv,PopAvOrd):-
	bsort(PopAv,PopAvOrd).

bsort([X],[X]):-!.
bsort([X|Xs],Ys):-
	bsort(Xs,Zs),
	btroca([X|Zs],Ys).


btroca([X],[X]):-!.

btroca([X*VX,Y*VY|L1],[Y*VY|L2]):-
	VX>VY,!,
	btroca([X*VX|L1],L2).

btroca([X|L1],[X|L2]):-btroca(L1,L2).

%-----------------------------------------------------------------------------------------------------------------------