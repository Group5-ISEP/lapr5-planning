:-[conhecimento].


:-dynamic liga/3.
gera_ligacoes:- retractall(liga(_,_,_)),
    findall(_,
            ((no(_,No1,t,f,_,_);no(_,No1,f,t,_,_)),
             (no(_,No2,t,f,_,_);no(_,No2,f,t,_,_)),
             No1\==No2,
             linha(_,N,LNos,_,_),
             ordem_membros(No1,No2,LNos),
             assertz(liga(No1,No2,N))
            ),_).

ordem_membros(No1,No2,[No1|L]):- member(No2,L),!.
ordem_membros(No1,No2,[_|L]):- ordem_membros(No1,No2,L).




caminho(Noi,Nof,LCaminho):-caminho(Noi,Nof,[],LCaminho).

caminho(No,No,Lusadas,Lfinal):-reverse(Lusadas,Lfinal).
caminho(No1,Nof,Lusadas,Lfinal):-liga(No1,No2,N),\+member((_,_,N),Lusadas),   \+member((No2,_,_),Lusadas),
                                    \+member((_,No2,_),Lusadas),
caminho(No2,Nof,[(No1,No2,N)|Lusadas],Lfinal).

menor_ntrocas(Noi,Nof,LCaminho_menostrocas):-
    findall(LCaminho,caminho(Noi,Nof,LCaminho),LLCaminho),
    menor(LLCaminho,LCaminho_menostrocas).

menor([H],H):-!.
menor([H|T],Hmenor):-menor(T,L1),length(H,C),length(L1,C1),
    ((C<C1,!,Hmenor=H);Hmenor=L1).


:- dynamic melhor_sol_tempo/2.

caminho_menor_tempo(TempoI,Noi,Nof,LCaminho_menostempo,Duracao):-
    (melhor_caminho(TempoI,Noi,Nof);true),
    retract(melhor_sol_tempo(LCaminho_menostempo,Duracao)),
melhor_caminho(TempoI,Noi,Nof):-
    asserta(melhor_sol_tempo(_,1000000)),
    caminho(Noi,Nof,LCaminho),
    atualiza_melhor(TempoI,LCaminho),
    fail.

atualiza_melhor(TempoI,LCaminho):-
    melhor_sol_tempo(_,T),
    soma_tempos(TempoI,LCaminho,C),
    C<T,retract(melhor_sol_tempo(_,_)),
    asserta(melhor_sol_tempo(LCaminho,C)).

soma_tempos(_,[],0). % criterio de paragem quando nao houver troços, soma duracao é 0

soma_tempos(TempoI,[(NoI,NoF,N)|Seguintes],Soma):-
    linha(_,N,LNos,_,_),
    nth1(PosI,LNos,NoI),
    nth1(PosF,LNos,NoF),
    % encontra todos os horarios que tenham a hora de o autocarro passar no ponto inicial superior à hora atual (TempoI)
    findall(TemposPassagem,
            (   horario(N,_,TemposPassagem),
                nth1(PosI,TemposPassagem,Tempo),
                Tempo>TempoI),
            LTemposPassagem),
    sort(LTemposPassagem,LTemposPassagemOrdenado), % o horario mais proximo fica em primeiro
    LTemposPassagemOrdenado = [TemposPassagem|_],
    %pega na hora que  vai chegar ao ponto final do troço e subtrai o tempo atual para saber o tempo que demora a percorrer o troço
    nth1(PosF,TemposPassagem,TempoChegada),
    DuracaoTroco is TempoChegada - TempoI,
    % descobre a duracao do resto do percurso, passando o TempoChegada como novo tempo atual para o proximo troço, e soma a duracao deste troço à duração do resto
    soma_tempos(TempoChegada,Seguintes,DuracaoResto),
    Soma is DuracaoResto + DuracaoTroco.

