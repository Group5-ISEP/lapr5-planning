%-----------------------------------------------------------------------------------------------------------------------
%---------------------------------------EXTRAIR SECÇÃO----------------------------------------------------------------
% De P1 até P2, busca o gene nessa posição e faz append à lista da secção.
%-----------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------
extrair_seccao(Ind,P2,P2,Seccao):-
    nth1(P2,Ind,Gene),
    append( [Gene], [], Seccao).

extrair_seccao(Ind,P1,P2,Seccao):-
    % Vai buscar o resto dos genes até P2.
    Temp is P1 + 1,
    extrair_seccao(Ind,Temp,P2,SeccaoResto),
    % Append do gene em P1.
    nth1(P1,Ind,Gene),
    append( [Gene], SeccaoResto, Seccao).

%-----------------------------------------------------------------------------------------------------------------------
%---------------------------------------ROTAÇÕES----------------------------------------------------------------
% Rodar as listas para esquerda e direita.
%-----------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------

rotate_n_left(Result,0,Result):-!.
rotate_n_left(List, N, Result):-
    rotate_left(List,Rotated),
    N1 is N-1,
    rotate_n_left(Rotated,N1,Result).    

rotate_n_right(Result,0,Result):-!.
rotate_n_right(List, N, Result):-
    rotate_right(List,Rotated),
    N1 is N-1,
    rotate_n_right(Rotated,N1,Result).  


rotate_left([Head|Tail], Result) :- append(Tail, [Head], Result).

rotate_right(List,Result):-
    extrair_ultimo_elemento(List, UltimoElemento, ListaSemUltimo),
    % Append ultimo elemento na frente da lista
    append( [UltimoElemento], ListaSemUltimo, Result).

% Percorre a lista até chegar ao ultimo elemento, retorna o ultimo elemento + a lista sem o ultimo
extrair_ultimo_elemento( [UltimoElemento], UltimoElemento, []):-!.
extrair_ultimo_elemento([Head|Tail], UltimoElemento, [Head | ListaSemUltimo]):-
    extrair_ultimo_elemento(Tail,UltimoElemento,ListaSemUltimo).

%-----------------------------------------------------------------------------------------------------------------------
%---------------------------------------SUBTRACT ONCE-------------------------------------------------------------------
% A função subtract remove do Set valores duplicados. Esta função é um subtract, mas apenas remove um dos valores.
% Acaba quando todos os valore de Delete forem removidos
%-----------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------

subtract_once(Set,[],Set):-!.
% Para cada elemento em Delete, remove a primeira ocorrência em Set.
subtract_once( Set,Delete, Result):-
    Delete = [ Elemento | Resto ],
    remove_element(Set, Elemento, SetSemElemento),
    subtract_once(SetSemElemento, Resto, Result).

% Quando encontra o Elemento, adiciona o RestoSet ao resultado, deixando o Elemento fora.
remove_element( [ Elemento | RestoSet ], Elemento, RestoSet ):-!.
% Adiciona o Head ao resultado.
remove_element([ Head | RestoSet ], Elemento, [Head | Result] ):- remove_element(RestoSet,Elemento,Result).
%-----------------------------------------------------------------------------------------------------------------------
%-----------------------------------------------------------------------------------------------------------------------