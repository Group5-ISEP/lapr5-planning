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
% As duas geracoes sao juntas, depois são escolhidos os N melhores. Os restantes são escolhidos aleatoriamente
% do conjunto.
%-----------------------------------------------------------------------------------------------------------------------

n_melhores(10).

selecao_passa_os_n_melhores(PopOrd,NovaPop, Selecao):-

    % Junta as populaçoes, remove os repetidos, e ordena a lista filtrada.
    append(PopOrd,NovaPop,TudoJunto),
    remover_repetidos(TudoJunto,TudoJuntoSemRepetidos),
    ordena_populacao(TudoJuntoSemRepetidos,TudoJuntoOrdenado),

    % Extrai os N melhores
    n_melhores(N),
    extrair_seccao(TudoJuntoOrdenado,1,N, Melhores),

    % Busca a quantidade restante aleatoriamente
    populacao(MaxPopulacao),
    random_permutation(TudoJunto, Randomized),
    N2 is N+1,
    extrair_seccao(Randomized,N2,MaxPopulacao, Resto),

    %Junta os melhores com os restantes.
    append( Melhores, Resto, Selecao ).

remover_repetidos([],[]):-!.
remover_repetidos([Elemento | Resto], [Elemento | Result]):-
    delete(Resto, Elemento, RestoFiltrado),
    remover_repetidos(RestoFiltrado, Result).
%-----------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------