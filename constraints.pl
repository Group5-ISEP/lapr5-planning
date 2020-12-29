%-------------------------------------------------------------------------------

%----------------------
% RESTRIÇÕES
%----------------------

%-------------------------------------------------------------------------------

inicio_periodo_almoco(39600).
fim_periodo_almoco(54000).
duracao_almoco(3600).

inicio_periodo_jantar(64800).
fim_periodo_jantar(79200).
duracao_jantar(3600).

max_horas_consecutivas(14400).
duracao_min_intervalo(3600).

max_horas_diarias(28800).

peso_4_horas_consecutivas(10).
peso_8_horas_totais(10).



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
        peso_4_horas_consecutivas(Peso),
        TempoViolacao is DuracaoBloco - Max,
        V is Peso * TempoViolacao
    ) ;
    % Senão, analisa os restantes workblocks
    restricao_nao_passar_max_horas_consecutivas(Resto, V).


%-------------------------------------------------------------------------------

%-----------------------------NÃO PASSAR MÁXIMO HORAS TOTAIS-------------------------------

restricao_nao_passar_max_horas_totais(ListaWorkBlock, V):-
    V is 1.



%-------------------------------------------------------------------------------
