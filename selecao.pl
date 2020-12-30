%---------------------%%%%%%%%%%%%%%------------------------------------------------------------------------------------
%--------------------%%   SELEÇÃO  %%-----------------------------------------------------------------------------------
%---------------------%%%%%%%%%%%%%%------------------------------------------------------------------------------------

%-----------------------------------------------------------------------------------------------------------------------
%-------------------------------TORNEIO---------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------
% Junta a geração pai e geração filho, mistura tudo, e depois faz um torneio para criar a população selecionada.
% Torneio: percorre a lista de concorrentes 2 a 2. Pegando num par, faz um duelo entre os dois. O vencedor é adicionado
% à lista selecionada.
%-----------------------------------------------------------------------------------------------------------------------


selecao_torneio(Pop,NovaPop, Selecao):-
    append(Pop,NovaPop,TudoJunto),
    random_permutation(TudoJunto, TudoSorteado),
    torneio(TudoSorteado,Selecao).

%-----------------------------------------------------------------------------------------------------------------------

torneio([],[]):-!.
torneio(Concorrentes, [ Vencedor*V | Selecao ]):-
    
    % Pega nos dois próximos concorrentes e nos seus valores
    Concorrentes = [ Concorrente1*V1 , Concorrente2*V2 | RestoConcorrentes ],

    % Compara os valores, o concorrente com menor valor é o vencedor.
    (
        ( V1=<V2, Vencedor = Concorrente1, V is V1 )
        ;
        ( Vencedor = Concorrente2, V is V2 )
    ),

    % Continua o torneio com o resto dos concorrentes
    torneio(RestoConcorrentes, Selecao).


%-----------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------

%-----------------------------------------------------------------------------------------------------------------------
%-------------------------------PASSAM OS N MELHOR DA GERAÇÃO ANTIGA----------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------
% O melhor da geração antiga é escolhido, e 1 dos da geração nova é removido aleatoriamente.
%-----------------------------------------------------------------------------------------------------------------------

n_melhores(10).

selecao_passa_o_melhor(PopOrd,NovaPop, Selecao):-
    n_melhores(N),
    extrair_seccao(PopOrd,1,N, Melhores),

    random_permutation(NovaPop, Randomized),
    length(Randomized, Length),
    N2 is N+1,
    extrair_seccao(Randomized,N2,Length, Resto),
    append( Melhores, Resto, Selecao ).

n_melhores(0,[],[]):-!.
n_melhores(N, [ Melhor | Resto], [ Melhor | Melhores ]):-
    N1 is N-1,
    n_melhores(N1,Resto,Melhores).
%-----------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------