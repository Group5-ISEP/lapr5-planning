
%---------------------%%%%%%%%%%%%%%------------------------------------------------------------------------------------
%--------------------%% CRUZAMENTO %%-----------------------------------------------------------------------------------
%---------------------%%%%%%%%%%%%%%------------------------------------------------------------------------------------
% Faz shuffle dos individuos, e depois cruza-os de 2 em 2, retornando a lista com a nova geração.
%-----------------------------------------------------------------------------------------------------------------------

cruzamento(PopAvOrd, PopNovaGera):-
    random_permutation(PopAvOrd, PopDesordenada),
    cruzamento1(PopDesordenada,PopNovaGera).

cruzamento1([],[]).
cruzamento1([Ind*_],[Ind]).

cruzamento1([Ind1*_,Ind2*_|Resto],[NInd1,NInd2|Resto1]):-

	gerar_pontos_cruzamento(P1,P2),
    % Cruza para ambos os lados, 1 com 2 e 2 com 1.
    cruzar(Ind1,Ind2,P1,P2,NInd1),
	cruzar(Ind2,Ind1,P1,P2,NInd2),
	% Cruza os restantes individuos
	cruzamento1(Resto,Resto1).

%-----------------------------------------------------------------------------------------------------------------------
%-----------------------------GERAR PONTO DE CRUZAMENTO-----------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------
% Divide a lista de workblocks em duas metades, gera o primeiro ponto na primeira metade, e o segundo ponto na segunda.
%-----------------------------------------------------------------------------------------------------------------------
gerar_pontos_cruzamento(P1,P2):-
    % Busca o tamanho da lista de workblocks
    vehicle_duty_id(Id),
    vehicleduty(Id,ListaWorkBlock),
	length(ListaWorkBlock,N),
    % Ponto intermedio
    Meio is div(N,2),
    % Ponto 1 fica na primeira metade
	random(1,Meio,P1),
    % Ponto 2 fica na segunda metade
	random(Meio,N,P2).


%-----------------------------------------------------------------------------------------------------------------------
%-----------------------------CRUZAR------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------
% Cruzamento com 2 pontos de interseção. Uma secção dos genes do Individuo 1 é definida entre P1 e P2, os genes 
% fora dessa secção são substituidos por genes do Individuo 2.
%-----------------------------------------------------------------------------------------------------------------------

cruzar(Ind1,Ind2,P1,P2,Filho):-
    
	extrair_seccao(Ind1,P1,P2,Seccao),
    % ATENÇÃO::: Ind1 e Ind2 são simétricos, as rotações aplicadas, antes da troca de genes, a um são aplicadas ao 
    % outro também. Isto tem haver com colocar os genes de Ind2 em Ind1 pela ordem correta.
    %
    % Extrair a seccao de Ind1 é o mesmo que encostar a secção no fim rodando para a direita,
    % e depois remover a primeira parte.

    % Roda o Ind2 N passos para a direita até que P2 seja o ultimo, como se fosse enconstar a secção no final da lista.
    length(Ind1,N),
    Steps is N - P2,
    rotate_n_right(Ind2,Steps,Ind2Rotated),
    % Retira os genes do Ind2 já existentes na secção.
    subtract_once(Ind2Rotated, Seccao,GenesParaAdicionar),
    % Adiciona os novos genes à Seccao.
    append(GenesParaAdicionar,Seccao, Mistura),
    % Roda os genes do Ind1 para a posicao original, criando então o Filho com os genes cruzados.
    rotate_n_left(Mistura,Steps, Filho).

%-----------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------
