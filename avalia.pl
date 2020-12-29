%-------------------------------------------------------

%----------------------
% AVALIA
%----------------------

avalia_populacao([],[]):-!.
avalia_populacao([Ind|Resto],[Ind*V|Resto1]):-
	avalia(Ind,V),
	avalia_populacao(Resto,Resto1),!.

avalia(SeqMotoristas,V):-

	% Buscar a sequência de work blocks e gerar agenda temporal
	vehicle_duty_id(Id),
	vehicleduty(Id,SeqWorkBlocks),
	gerar_agenda_temporal(SeqMotoristas,SeqWorkBlocks,[],Agenda),
	avalia_agenda(Agenda,V).

%--------------------------------------------------------------------------------------------------------------------------
%----------------------GERAR AGENDA--------------------------------------------------
% Gera uma agenda no formato [ (Motorista, [ (StartTime,EndTime), ... ]), ... ]
% Lista de tuplos, um tuplo por motorista. Cada tuplo tem o Id do motorista e a lista de workblocks, ordenada.
%--------------------------------------------------------------------------------------------------------------------------
gerar_agenda_temporal([],[],Agenda,Agenda):-!.

gerar_agenda_temporal(SeqMotoristas,SeqWorkBlockIds,Agenda,Resultado):-

	SeqMotoristas = [Motorista | RestoMotoristas],
	SeqWorkBlockIds = [WorkBlockId | RestoWorkBlocks],
	workblock(WorkBlockId,_,StartTime,EndTime),

	(
		% Se o motorista já tiver workblocks na agenda, faz append deste workblock ao final da lista de workblocks desse motorista
		(
			% Procura uma entrada em Agenda com Motorista, se sucesso retorna ListaWorkBlock associado a Motorista
			member((Motorista,ListaWorkBlock), Agenda),
			% Append do workblock à lista de workblocks
			append(ListaWorkBlock, [ (StartTime,EndTime) ], ListaWorkBlockNova),
			% Concatena work blocks consecutivos na lista de work blocks
			concatenar_blocos_consecutivos(ListaWorkBlockNova,ListaWorkBlockNovaConcatenada),
			% Apaga da Agenda a entrada do motorista antiga
			delete(Agenda,(Motorista,_),TempAgenda),
			% Adiciona na Agenda a entrada do motorista com a lista de workblocks atualizada
			append([(Motorista,ListaWorkBlockNovaConcatenada)],TempAgenda,AgendaAtualizada)
		) ; 
		% Se o motorista ainda não tiver uma entrada na agenda, então cria uma com o workblock
		append([ ( Motorista,[ (StartTime,EndTime) ] ) ], Agenda,AgendaAtualizada)
	),

	% Gera a agenda para os workblocks seguintes e retorna o resultado
	gerar_agenda_temporal(RestoMotoristas,RestoWorkBlocks, AgendaAtualizada, Resultado).


% Para quando tiver uma sublista com apenas um elemento (já não há mais nada para concatenar)
concatenar_blocos_consecutivos([Bloco],[Bloco]):-!.
concatenar_blocos_consecutivos(ListaWorkBlock,ListaWorkBlockConcatenada):-

	nth1(1,ListaWorkBlock, (StartTime1,EndTime1) ),
	nth1(2,ListaWorkBlock, (StartTime2,EndTime2) ),

	% Se o Endtime do primeiro block for igual ao Starttime do segundo, então junta os dois
	% Passa a lista de workblocks com o novo workblock recursivamente para comparar com os próximos blocos
	(
		EndTime1 = StartTime2,
		% Retira os dois workblocks
		subtract(ListaWorkBlock, [ (StartTime1,EndTime1), (StartTime2,EndTime2) ], ListaWorkBlockTemp),
		% Adiciona o workblock concatenado
		append( [ (StartTime1, EndTime2) ], ListaWorkBlockTemp, ListaWorkBlockNova ),
		% Passa a lista com o novo bloco para ser concatenada com o resto dos blocos
		concatenar_blocos_consecutivos(ListaWorkBlockNova, ListaWorkBlockConcatenada)
	) ;
	% Se não forem iguais, então passa uma sublista sem o primeiro workblock, e depois faz append do primeiro work block ao resultado
	ListaWorkBlock = [ PrimeiroWorkBlock | Resto ],
	concatenar_blocos_consecutivos(Resto, SubListaConcatenada),
	append([PrimeiroWorkBlock], SubListaConcatenada, ListaWorkBlockConcatenada).

%--------------------------------------------------------------------------------------------------------------------------
%--------------------------------------------------------------------------------------------------------------------------

%--------------AVALIA AGENDA---------------------

:- [constraints].

% Avalia cada motorista da agenda, e soma as avaliações
avalia_agenda([],0):-!.
avalia_agenda(Agenda,V):-

    Agenda = [ (Motorista, ListaWorkBlock) | Resto ],

    % avalia a lista de workblocks do motorista
    restricao_nao_passar_max_horas_consecutivas(ListaWorkBlock, Resultado1),
    restricao_nao_passar_max_horas_totais(ListaWorkBlock,Resultado2),
    restricao_minimo_descanso(ListaWorkBlock,Resultado3),
    restricao_horario_pretendido(Motorista,ListaWorkBlock,Resultado4),
    Resultado is Resultado1 + Resultado2 + Resultado3 + Resultado4,

    % avalia o resto da agenda
    avalia_agenda(Resto, ResultadoResto),

    V is Resultado + ResultadoResto.

%-------------------------------------------------------

