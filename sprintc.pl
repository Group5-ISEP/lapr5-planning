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



% parameteriza��o
geracoes(5).
populacao(4).
prob_cruzamento(0.4).
prob_mutacao(0.5).
vehicle_duty_id(12).



gera:-
	%inicializa,
	gera_populacao(Pop),
	avalia_populacao(Pop,PopAv),
	ordena_populacao(PopAv,PopOrd),
	geracoes(NG),
	gera_geracao(0,NG,PopOrd).


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
gera_populacao(0,_,[]):-!.
gera_populacao(TamPop,ListaMotoristas,[Ind|Resto]):-
	TamPop1 is TamPop-1,
	gera_populacao(TamPop1,ListaMotoristas,Resto),
	gera_individuo(ListaMotoristas,Ind),
	not(member(Ind,Resto)).

gera_individuo(ListaMotoristas,Ind):-
	random_permutation(ListaMotoristas,Ind).

%-------------------------------------------------------