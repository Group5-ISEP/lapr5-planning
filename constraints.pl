%-------------------------------------------------------------------------------

%----------------------
% RESTRIÇÕES
%----------------------

%-------------------------------------------------------------------------------

%-----------------------------NÃO PASSAR MÁXIMO HORAS CONSECUTIVAS-------------------------------

restricao_nao_passar_max_horas_consecutivas([],0):-!.
restricao_nao_passar_max_horas_consecutivas(ListaWorkBlock, V):-

    % Busca o primeiro workblock
    ListaWorkBlock = [ (StartTime,EndTime) | Resto ],

    DuracaoBloco is EndTime - StartTime,

    % Se a duração do bloco for maior do que o máximo de horas consecutivas
    % calcula o peso
    max_horas_consecutivas(Max),
    (
        DuracaoBloco > Max,
        peso_max_horas_consecutivas(Peso),
        TempoViolacao is DuracaoBloco - Max,
        V is Peso * TempoViolacao
    ) ;
    % Senão, analisa os restantes workblocks
    restricao_nao_passar_max_horas_consecutivas(Resto, V).


%-------------------------------------------------------------------------------

%-----------------------------NÃO PASSAR MÁXIMO HORAS TOTAIS-------------------------------

% Soma a duracao de todos os workblocks da lista, e depois calcula o peso.
restricao_nao_passar_max_horas_totais(ListaWorkBlock, V):-
    restricao_nao_passar_max_horas_totais(ListaWorkBlock, 0, V).

% Calcula o peso com a soma
restricao_nao_passar_max_horas_totais([],Soma,V):-
    max_horas_diarias(Max),
    (
        Soma > Max,
        peso_max_horas_totais(Peso),
        TempoViolacao is Soma - Max,
        V is Peso * TempoViolacao
    ) ;
    V is 0.

% Soma as durações
restricao_nao_passar_max_horas_totais(ListaWorkBlock,Soma,V):-
    % Busca o workblock
    ListaWorkBlock = [ (StartTime,EndTime) | Resto ],

    % Adiciona a sua duracao à soma
    DuracaoBloco is EndTime - StartTime,
    DuracaoTotal is DuracaoBloco + Soma,

    % Continua a calcular o resto dos workblocks
    restricao_nao_passar_max_horas_totais(Resto, DuracaoTotal, V).



%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------

%-----------------------------MINIMO DESCANSO DEPOIS DE MAX HORAS CONSECUTIVAS ATINGIDO-------------------------------

% Procura um Bloco com duracao 4h+, se encontrar, vê a duração do intervalo até o próximo bloco começar

restricao_minimo_descanso(ListaWorkBlock,V):-
    restricao_minimo_descanso(ListaWorkBlock,0,V).

% Quando chegou ao workblock final retorna a soma até agora feita.
restricao_minimo_descanso([_],Soma,Soma):-!.

restricao_minimo_descanso(ListaWorkBlock,Soma,V):-

    nth1(1,ListaWorkBlock, (StartTime1,EndTime1) ),
    nth1(2,ListaWorkBlock, (StartTime2, _ ) ),

    DuracaoBloco is EndTime1 - StartTime1,
    max_horas_consecutivas(Max),
    % Se a duração for igual ou maior que Max, se o intervalo até ao inicio do proximo workblock
    % é menor que o mínimo, então adiciona o peso.
    (
        DuracaoBloco >= Max,
        duracao_min_intervalo(Min),
        DuracaoIntervalo is StartTime2 - EndTime1,
        DuracaoIntervalo < Min,
        peso_minimo_descanso(Peso),
        Valor is ( Min - DuracaoIntervalo ) * Peso,
        NovaSoma is Soma + Valor,

        % Analisa o resto dos workblocks
        ListaWorkBlock = [ _ | Resto ],
        restricao_minimo_descanso(Resto, NovaSoma, V)

    ) ;
    % Senão, continua a analisar o resto dos workblocks
    ListaWorkBlock = [ _ | Resto ],
    restricao_minimo_descanso(Resto, Soma, V).

%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------

%-----------------------------HORAS PRETENDIDAS PELO MOTORISTA-------------------------------

% Para o primeiro workblock, vê se começa antes da hora pretendida e o quão antes vai determinar o valor.
% Fazer o mesmo para o último workblock, vendo o quão depois da hora.

restricao_horario_pretendido(Motorista,ListaWorkBlock,V):-

    horas_pretendidas(Motorista,LimiteInf,LimiteSup),
    
    nth1(1,ListaWorkBlock, (StartTime, _ ) ),
    primeiro_bloco(StartTime,LimiteInf,Valor1),

    length(ListaWorkBlock, UltimoIndex),
    nth1(UltimoIndex,ListaWorkBlock, ( _ , EndTime) ),
    ultimo_bloco(EndTime,LimiteSup,Valor2),

    V is Valor1 + Valor2.
    

primeiro_bloco(StartTime,LimiteInf,V):-
    (
        StartTime < LimiteInf,
        Diferenca is LimiteInf - StartTime,
        peso_horario_pretendido(Peso),
        V is Diferenca * Peso
    ) ; 
    V is 0.

ultimo_bloco(EndTime,LimiteSup,V):-
    (
        EndTime > LimiteSup,
        Diferenca is EndTime - LimiteSup,
        peso_horario_pretendido(Peso),
        V is Diferenca * Peso
    ) ; 
    V is 0.

%-------------------------------------------------------------------------------

%-------------------------------------------------------------------------------

%-----------------------------HORAS CONTRATUAIS-------------------------------

% Para o primeiro workblock, vê se começa antes da hora contratual e o quão antes vai determinar o valor.
% Fazer o mesmo para o último workblock, vendo o quão depois da hora.

restricao_horario_contrato(Motorista,ListaWorkBlock,V):-

    horas_contrato(Motorista,LimiteInf,LimiteSup),
    
    nth1(1,ListaWorkBlock, (StartTime, _ ) ),
    primeiro_bloco2(StartTime,LimiteInf,Valor1),

    length(ListaWorkBlock, UltimoIndex),
    nth1(UltimoIndex,ListaWorkBlock, ( _ , EndTime) ),
    ultimo_bloco2(EndTime,LimiteSup,Valor2),

    V is Valor1 + Valor2.
    

primeiro_bloco2(StartTime,LimiteInf,V):-
    (
        StartTime < LimiteInf,
        Diferenca is LimiteInf - StartTime,
        peso_horario_contrato(Peso),
        V is Diferenca * Peso
    ) ; 
    V is 0.

ultimo_bloco2(EndTime,LimiteSup,V):-
    (
        EndTime > LimiteSup,
        Diferenca is EndTime - LimiteSup,
        peso_horario_contrato(Peso),
        V is Diferenca * Peso
    ) ; 
    V is 0.

%-------------------------------------------------------------------------------


%//TODO: RESTRICAO DE HORAS DE ALMOÇO E HORAS DE JANTAR