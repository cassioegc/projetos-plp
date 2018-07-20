:- use_module(word_data).
:- initialization(main).


modelWord(Word, Exit) :-
    string_chars(Word, List),
    convlist([_,Y]>>(Y="_"), List, Temp),
    atomic_list_concat(Temp, "", Exit).  

verifyLetter([], [], _, "").
verifyLetter([H1|T1], [H2|T2], Letter, ActualWordRet) :-
    H2 =:= Letter, verifyLetter(T1, T2, Letter, ActualWordAtt), atom_concat(H2, ActualWordAtt, ActualWordRet);
    verifyLetter(T1, T2, Letter, ActualWordAtt), atom_concat(H1, ActualWordAtt, ActualWordRet).


verifyHits([], "", false).
verifyHits([H|T], Letter, Hits) :-
    H =:= Letter, Hits = true;
    verifyHits(T, Letter, Result), Hits = Result.


insert([], Date, [Date]).
insert([H|T1], Date, [H|T2]) :-
    insert(T1, Date, T2).


addBonus(Name, DatesWithBonus) :-
    DatesWithBonus = [Name, 20, 7, false, false, false, false].

%%% Lista original, indice, elemento, Novalista %%%
replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):- I > -1, NI is I-1, replace(T, NI, X, R), !.
replace(L, _, _, L).


%% Adiciona os novos pontos por rodada %%
addPoints(PlayerData, "PYTHON", Result) :-
    nth0(1, PlayerData, OldPoints),
    NewPoints is 20 + OldPoints,
    replace(PlayerData, 1, NewPoints, Result).    

addPoints(PlayerData, "JAVA", Result) :-
    nth0(1, PlayerData, OldPoints),
    NewPoints is 30 + OldPoints,
    replace(PlayerData, 1, NewPoints, Result).

addPoints(PlayerData, "ASSEMBLY", Result) :-
    nth0(1, PlayerData, OldPoints),
    NewPoints is 50 + OldPoints,
    replace(PlayerData, 1, NewPoints, Result).


%% Adiciona vidas em relacao ao nivel %%
addLifes(PlayerData, "PYTHON", Result) :-
    nth0(2, PlayerData, OldLifes),
    NewLifes is 7 + OldLifes,
    replace(PlayerData, 2, NewLifes, Result).    

addLifes(PlayerData, "JAVA", Result) :-
    nth0(2, PlayerData, OldLifes),
    NewLifes is 5 + OldLifes,
    replace(PlayerData, 2, NewLifes, Result).    

addLifes(PlayerData, "ASSEMBLY", Result) :-
    nth0(2, PlayerData, OldLifes),
    NewLifes is 3 + OldLifes,
    replace(PlayerData, 2, NewLifes, Result).    

%% Penalizar vidas de acordo com o nivel %%
penalizeLifes(PlayerData, "PYTHON", Result) :-
    nth0(2, PlayerData, OldLifes),
    NewLifes is OldLifes - 2,
    replace(PlayerData, 2, NewLifes, Result).    

penalizeLifes(PlayerData, "JAVA", Result) :-
    nth0(2, PlayerData, OldLifes),
    NewLifes is OldLifes - 5,
    replace(PlayerData, 2, NewLifes, Result). 

penalizeLifes(PlayerData, "ASSEMBLY", Result) :-
    nth0(2, PlayerData, OldLifes),
    NewLifes is OldLifes - 8,
    replace(PlayerData, 2, NewLifes, Result). 

inicializeMenu() :-
    writeln("==========================================================="),
    writeln("|               FORCA, RODA jequiti A RODA                |"),
    writeln("==========================================================="),
    writeln(""),
    writeln("--------------------- COMO FUNCIONA -----------------------"),
    writeln("1 - DOIS JOGADORES APRESENTAM X CHANCES CADA UM POR RODADA"),
    writeln("    PARA ADIVINHAR UMA PALAVRA ALEATORIA LETRA A LETRA."),
    writeln(""),
    writeln("2 - CADA LETRA ERRADA, DEBITA PONTOS NA QUANTIDADE"),
    writeln("    DETERMINADA PELO NIVEL (PYTHON, JAVA E ASSEMBLY)."),
    writeln(""),
    writeln("3 - QUANDO FALTAR QUARENTA POR CENTO DA PALAVRA EM QUESTAO, "),
    writeln("    O JOGADOR SERA"),
    writeln("    SOLICITADO A DAR A RESPOSTA CORRETA. EM CASO DE ERRO, O"),
    writeln("    JOGADOR SOFRERA AS PUNICOES JA CITADAS."),
    writeln(""),
    writeln("4 - O JOGADOR QUE ACERTAR RECEBERA X PONTOS."),
    writeln(""),
    writeln("5 - ZERADA AS CHANCES, O PERDEDOR AGUARDA O FINAL DA RODADA,"),
    writeln("    PODENDO O ADVERSARIO LEVAR OS PONTOS SE ACERTAR A PALAVRA."),
    writeln(""),
    writeln("6 - UMA NOVA PALAVRA SORTEADA A CADA RODADA."),
    writeln(""),
    writeln("7 - A CADA RODADA, UM BONUS PODERA SER SOLICIDADO UMA UNICA"),
    writeln("    VEZ(TIPO DA PALAVRA, PALAVRA SEMELHANTE E NUMERO DE SILABAS)."),
    writeln(""),
    writeln("8 - AO FINAL DO JOGO, SERA O VENCEDOR AQUELE QUE ACUMULOU"),
    writeln("    MAIS PONTOS."),
    writeln(""),
    writeln("              Pressione enter para continuar"),
    read_line_to_string(user_input, Sleep).


main :-
    % Level = [],
    string_concat("", "PYTHON", Level),

    %% Menu de exibicao %%
    inicializeMenu(),

    %%  nomes dos players  %%
    write("NOME JOGADOR 1: "),
    read_line_to_string(user_input, Player1),
    write("NOME JOGADOR 2: "),
    read_line_to_string(user_input, Player2),
  

    %%  inicializa lista dos players  %%%%%
    addBonus(Player1, DatesWithBonus1),
    addBonus(Player2, DatesWithBonus2),
    Datas1 = DatesWithBonus1,
    Datas2 = DatesWithBonus2,

    %% inserir aqui sorteio da palavra  %%%%%
    getWordData(Level, WordData),
    nth0(0, WordData, Word),
    
  
    %%% Modelagem da palavra %%%%%
    modelWord(Word, ModelWord),
    writeln(Word),
    writeln(ModelWord).
    

%    atom_codes(W, Word), atom_chars(W, ListWord),
