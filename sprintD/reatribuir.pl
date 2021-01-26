reatribuir(NovaAgenda,[],NovaAgenda):-!.
reatribuir(Agenda,ListaReatribuicao,NovaAgenda):-
    ListaReatribuicao = [ Workblock | Resto],
    reatribuir_workblock(Agenda,Workblock,NovaAgendaTemp),
    reatribuir(NovaAgendaTemp,Resto,NovaAgenda).


%---------------------------------------------------------------
%--Sort Workblocks por StartTime
primeiroStartTime((Motorista,WorkblockId,StartTime,EndTime),(StartTime,EndTime,Motorista,WorkblockId)).
normalStartTime((StartTime,EndTime,Motorista,WorkblockId),(Motorista,WorkblockId,StartTime,EndTime)).

sortStartTime(List,Sorted):-
  maplist(primeiroStartTime,List,List1),
  sort(0,@=<,List1, List2),
  maplist(normalStartTime,List2,Sorted).
%----------------------------------------------------------------

reatribuir_workblock([],Workblock,[]):-
    write('NAO FOI POSSIVEL ADICIONAR ESTE BLOCO: '),
    write(Workblock),nl.
reatribuir_workblock(Agenda,Workblock,NovaAgenda):-

    Agenda = [(Motorista,ListaWorkblocks) | Outros],
    Workblock = (MotoristaAntigo,WorkblockId,StartTime,EndTime),

    Motorista\=MotoristaAntigo,

    append(ListaWorkblocks,[Workblock],Temp),
    sortStartTime(Temp,TempSorted),
    retirar_erros( [(Motorista,TempSorted)],_,Resultado),
    length(Resultado, N),
    N=0,

    %Se tudo deu certo, então adiciona definitivamente
    WorkblockAtualizado = (Motorista,WorkblockId,StartTime,EndTime),
    append(ListaWorkblocks,[WorkblockAtualizado],NovaLista),
    sortStartTime(NovaLista,NovaListaOrdenada),
    write('&&&&&&&&'),nl,write('Nova lista: '),nl,write(NovaListaOrdenada),nl,write('&&&&&&&&'),nl,nl,
    NovaAgenda = [ (Motorista,NovaListaOrdenada) | Outros].



%Caso o motorista não consiga ser adicionado, continua para o próxximo
reatribuir_workblock( [ AgendaMotorista | Outros] ,Workblock,[ AgendaMotorista | NovaAgenda]):-
    reatribuir_workblock(Outros,Workblock,NovaAgenda).
