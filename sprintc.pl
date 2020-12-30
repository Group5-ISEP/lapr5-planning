% horario(Path,Trip,List_of_Time)
horario(38,459,[34080,34200]).
horario(3,31,[37800,38280,38580,38880,39420]).
horario(1,63,[39600,40140,40440,40740,41220]).
horario(3,33,[41400,41880,42180,42480,43020]).
horario(1,65,[43200,43740,44040,44340,44820]).
horario(3,35,[45000,45480,45780,46080,46620]).
horario(1,67,[46800,47340,47640,47940,48420]).
horario(3,37,[48600,49080,49380,49680,50220]).
horario(1,69,[50400,50940,51240,51540,52020]).
horario(3,39,[52200,52680,52980,53280,53820]).
horario(1,71,[54000,54540,54840,55140,55620]).
horario(3,41,[55800,56280,56580,56880,57420]).
horario(1,73,[57600,58140,58440,58740,59220]).
horario(3,43,[59400,59880,60180,60480,61020]).
horario(1,75,[61200,61740,62040,62340,62820]).
horario(3,45,[63000,63480,63780,64080,64620]).
horario(1,77,[64800,65340,65640,65940,66420]).
horario(3,48,[66600,67080,67380,67680,68220]).
horario(1,82,[68400,68940,69240,69540,70020]).
horario(3,52,[70200,70680,70980,71280,71820]).
horario(1,86,[72000,72540,72840,73140,73620]).
horario(3,56,[73800,74280,74580,74880,75420]).
horario(1,432,[75600,76140,76440,76740,77220]).
horario(39,460,[77220,77340]).


% workblock(WorkBlock, List_of_Trips, StartTime, EndTime)
workblock(12,[459],34080,37620).
workblock(211,[31,63],37620,41220).
workblock(212,[33,65],41220,44820).
workblock(213,[35,67],44820,48420).
workblock(214,[37,69],48420,52020).
workblock(215,[39,71],52020,55620).
workblock(216,[41,73],55620,59220).
workblock(217,[43,75],59220,62820).
workblock(218,[45,77],62820,66420).
workblock(219,[48,82],66420,70020).
workblock(220,[52,86],70020,73620).
workblock(221,[56,432],73620,77220).
workblock(222,[460],77220,77340).


% vehicleduty(VehicleDuty, List_of_WorkBlocks)
vehicleduty(12,[12,211,212,213,214,215,216,217,218,219,220,221,222]).

% Assuma que a lista de motoristas a considerar e o nº
% de workblocks que cada um terá na solução de um
% vehicleduty é conhecido
lista_motoristas_nworkblocks(12,[(276,2),(5188,3),(16690,2),(18107,6)]).


% horas_pretendidas( Motorista, LimiteInf, LimiteSup)
horas_pretendidas(276,32400,39600). %9h-11h
horas_pretendidas(5188,39600,64800). %11h-18h
horas_pretendidas(16690,32400,43200). %9h-12h
horas_pretendidas(18107,50400,72000). %14h-20h

% horas_contrato( Motorista, LimiteInf, LimiteSup)
horas_contrato(276,32400,43200). %9h-12h
horas_contrato(5188,39600,72000). %11h-20h
horas_contrato(16690,32400,54000). %9h-15h
horas_contrato(18107,50400,79200). %14h-22h




% parameteriza��o
geracoes(5).
populacao(100).
prob_cruzamento(0.4).
prob_mutacao(0.5).
vehicle_duty_id(12).




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



% Carregar outros ficheiros
:- [gerar_populacao].
:- [avalia].

gera:-
	%inicializa,
	gera_populacao(Pop),
	avalia_populacao(Pop,PopAv),
	ordena_populacao(PopAv,PopOrd),
	geracoes(NG),
	%gera_geracao(0,NG,PopOrd).
	write(PopOrd), nl.



%--------------ORDENA POPULACAO------------------------------
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

%----------------------------------------------------------------