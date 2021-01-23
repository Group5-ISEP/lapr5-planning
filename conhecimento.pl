% no(nome_paragem, abrev_paragem, flag_ponto_rendição, flag_estação_recolha, longitude, latitude)
no('Aguiar de Sousa', 'AGUIA', f, f, -8.4464785432391, 41.1293363229325).
no('Baltar', 'BALTR', t, f, -8.38716802227697, 41.1937898023744).
no('Besteiros', 'BESTR', f, f, -8.34043029659082, 41.217018845589).
no('Cete', 'CETE', t, f, -8.35164059584564, 41.183243425797).
no('Cristelo', 'CRIST', t, f, -8.34639896125324, 41.2207801252676).
no('Duas Igrejas', 'DIGRJ', f, f, -8.35481024956726, 41.2278665802794).
no('Estação (Lordelo)', 'ESTLO', f, t, -8.4227924957086, 41.2521157104055).
no('Estação (Paredes)', 'ESTPA', f, t, -8.33448520831829, 41.2082119860192).
no('Gandra', 'GAND', f, f, -8.43958765792976, 41.1956579348384).
no('Lordelo', 'LORDL', t, f, -8.42293614720057, 41.2452627470645).
no('Mouriz', 'MOURZ', t, f, -8.36577272258403, 41.1983610215263).
no('Parada de Todeia', 'PARAD', t, f, -8.37023578802149, 41.1765780321068).
no('Paredes', 'PARED', t, f, -8.33566951069481, 41.2062947118362).
no('Recarei', 'RECAR', f, f, -8.42215867462191, 41.1599363478137).
no('Sobrosa', 'SOBRO', t, f, -8.38118071581788, 41.2557331783506).
no('Vandoma', 'VANDO', t, f, -8.34160692293342, 41.2328015719913).
no('Vila Cova de Carros', 'VCCAR', t, f, -8.35109395257277, 41.2090666564063).

%-----------------------------------------------------------------------------------------------------------------------

% linha(nome_linha, número_path, lista_abrev_paragens, tempo_minutos, distância_metros).
linha('Paredes_Aguiar', 1, ['AGUIA','RECAR', 'PARAD', 'CETE', 'PARED'], 31, 15700).
linha('Paredes_Aguiar', 3, ['PARED', 'CETE','PARAD', 'RECAR', 'AGUIA'], 31, 15700).
linha('Paredes_Gandra', 5 , ['GAND', 'VANDO', 'BALTR', 'MOURZ', 'PARED'], 26, 13000).
linha('Paredes_Gandra', 8, ['PARED', 'MOURZ', 'BALTR', 'VANDO', 'GAND'], 26, 13000).
linha('Paredes_Lordelo', 9, ['LORDL','VANDO', 'BALTR', 'MOURZ', 'PARED'], 29, 14300).
linha('Paredes_Lordelo', 11, ['PARED','MOURZ', 'BALTR', 'VANDO', 'LORDL'], 29, 14300).
linha('Lordelo_Parada', 24, ['LORDL', 'DIGRJ', 'CRIST', 'VCCAR', 'BALTR', 'PARAD'], 22, 11000).
linha('Lordelo_Parada', 26, ['PARAD', 'BALTR', 'VCCAR', 'CRIST', 'DIGRJ', 'LORDL'], 22, 11000).
% linha('Cristelo_Baltar’, nd0, ['CRIST', 'VCCAR', 'BALTR'], 8, 4000).
% linha('Baltar_Cristelo’, nd1, [‘BALTR', 'VCCAR', 'CRIST'], 8, 4000).
linha('Sobrosa_Cete', 22, ['SOBRO', 'CRIST', 'BESTR', 'VCCAR', 'MOURZ', 'CETE'], 23, 11500).
linha('Sobrosa_Cete', 20, ['CETE', 'MOURZ', 'VCCAR', 'BESTR', 'CRIST', 'SOBRO'], 23, 11500).
linha('Estação(Lordelo)_Lordelo',34,['ESTLO','LORDL'], 2,1500).
linha('Lordelo_Estação(Lordelo)',35,['LORDL','ESTLO'], 2,1500).
linha('Estação(Lordelo)_Sobrosa',36,['ESTLO','SOBRO'], 5,1500).
linha('Sobrosa_Estação(Lordelo)',37,['SOBRO','ESTLO'], 5,1800).
linha('Estação(Paredes)_Paredes',38,['ESTPA','PARED'], 2,1500).
linha('Paredes_Estação(Paredes)',39,['PARED','ESTPA'], 2,1500).

%-----------------------------------------------------------------------------------------------------------------------

% horario(Path,Trip,List_of_Time)

%Paredes_Aguiar
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

%Paredes_Gandra
horario(38,461,[35000,35120]).
horario(8,100,[36000,36390,36780,37170,37560]).
horario(5,101,[37680,38070,38460,38850,39240]).
horario(8,102,[39360,39750,40140,40530,40920]).
horario(5,103,[41040,41430,41820,42210,42600]).
horario(8,104,[42720,43110,43500,43890,44280]).
horario(5,104,[44400,44790,45180,45570,45960]).
horario(8,106,[46080,46470,46860,47250,47640]).
horario(5,107,[47760,48150,48540,48930,49320]).
horario(8,108,[49440,49830,50220,50610,51000]).
horario(5,109,[51390,51780,52170,52560,52950]).
horario(8,110,[53070,53460,53850,54240,54630]).
horario(5,111,[54750,55140,55530,55920,56310]).
horario(39,462,[56310,56430]).


%-----------------------------------------------------------------------------------------------------------------------

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

workblock(223,[461],35000,36000).
workblock(224,[100,101],36000,39360).
workblock(225,[102,103],39360,42720).
workblock(226,[104,105],42720,46080).
workblock(227,[106,107],46080,49440).
workblock(228,[108,109],49440,53070).
workblock(229,[110,111],53070,56310).
workblock(230,[462],56310,56430).

%-----------------------------------------------------------------------------------------------------------------------

% vehicleduty(VehicleDuty, List_of_WorkBlocks)
vehicleduty(12,[12,211,212,213,214,215,216,217,218,219,220,221,222]).
vehicleduty(13,[223,224,225,226,227,228,229,230]).

%-----------------------------------------------------------------------------------------------------------------------

% motorista(motorista, List_of_WorkBlocks)
:- dynamic motorista/2.
motorista(1,[]).
motorista(2,[]).
motorista(3,[]).
motorista(4,[]).
motorista(5,[]).
motorista(6,[]).
motorista(7,[]).
motorista(8,[]).
motorista(9,[]).
motorista(10,[]).

%-----------------------------------------------------------------------------------------------------------------------

% lista_motoristas_nworkblocks(id_vehicle_duty, [ (id_motorista, n_workblocks), ... ] )
:- dynamic lista_motoristas_nworkblocks/2.

%-----------------------------------------------------------------------------------------------------------------------
