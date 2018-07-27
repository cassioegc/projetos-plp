:- use_module(word_data).
:- initialization(main).

%%% Gets info Player %%%
getName(Player, Name)            :- nth0(0, Player, Name).
getPoints(Player, Points)        :- nth0(1, Player, Points).
getLifes(Player, Lifes)          :- nth0(2, Player, Lifes).
chooseLetterBonus(Player, Bonus) :- nth0(3, Player, Bonus).
typeWordBonus(Player, Bonus)     :- nth0(4, Player, Bonus).
synonymsBonus(Player, Bonus)     :- nth0(5, Player, Bonus).
syllablesBonus(Player, Bonus)    :- nth0(6, Player, Bonus).

%%%  UTILS  %%%
clear() :- 
    tty_clear.

stringToList(String, R) :- 
    atom_chars(String, List),
    convlist([X,Y]>>(string_chars(Y, [X])), List, R).

countInList(List, Element, Return) :-
    include(=(Element), List, L2), length(L2, Return).

countInString(String, Element, Return) :-
    stringToList(String, List),
    include(=(Element), List, L2), 
    length(L2, Return).
%%%%%%%%%%%%%%%

modelWord(Word, Exit) :-
    string_chars(Word, List),
    convlist([_,Y]>>(Y="_"), List, Temp),
    atomic_list_concat(Temp, "", Exit).  

verifyLetter([], [], _, "").
verifyLetter([H1|T1], [H2|T2], Letter, ActualWordRet) :-
    H2 = Letter, verifyLetter(T1, T2, Letter, ActualWordAtt), atom_concat(H2, ActualWordAtt, ActualWordRet);
    verifyLetter(T1, T2, Letter, ActualWordAtt), atom_concat(H1, ActualWordAtt, ActualWordRet).


verifyHits([], "", Check) :- Check = false.
verifyHits([H|T], Letter, Hits) :-
    H = Letter, Hits = true;
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

%% Altera situacao dos bonus %%
changeChooseLetter(PlayerData, Result):-
    replace(PlayerData, 3, true, Result). 
    
changeTypeWord(PlayerData, Result):-
    replace(PlayerData, 4, true, Result). 
    
changeSynonyms(PlayerData, Result):-
    replace(PlayerData, 5, true, Result). 

changeSyllables(PlayerData, Result):-
    replace(PlayerData, 6, true, Result). 

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

%% Penalizar pontos de acordo com o nivel %%
penalizePoints(PlayerData, "PYTHON", Result) :-
    nth0(1, PlayerData, OldPoints),
    NewPoints is OldPoints - 2,
    replace(PlayerData, 1, NewPoints, Result).    

penalizePoints(PlayerData, "JAVA", Result) :-
    nth0(1, PlayerData, OldPoints),
    NewPoints is OldPoints - 5,
    replace(PlayerData, 1, NewPoints, Result). 

penalizePoints(PlayerData, "ASSEMBLY", Result) :-
    nth0(1, PlayerData, OldPoints),
    NewPoints is OldPoints - 8,
    replace(PlayerData, 1, NewPoints, Result).
    
penalizeLifes(PlayerData, Result) :-
    nth0(2, PlayerData, OldLifes),
    NewLifes is OldLifes - 1,
    replace(PlayerData, 2, NewLifes, Result).  
    

selectLevel(Round, Level) :-
    between(1,3, Round) -> Level = "PYTHON";
    between(4,6, Round) -> Level = "JAVA";
    Level = "ASSEMBLY".
    
    

inicializeMenu() :-
    clear(),
    writeln("============================================================="),
    writeln("|                FORCA, RODA jequiti A RODA                 |"),
    writeln("============================================================="), nl,
    writeln("----------------------- COMO FUNCIONA -----------------------"),
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
    read_line_to_string(user_input, _).

endRoundStatus(Player1, Player2) :-
    getName(Player1, Name1),
    getName(Player2, Name2),
    getPoints(Player1, Points1),
    getPoints(Player2, Points2),
    write("|##################################################|"), nl,
    write("|------------------ FIM DA RODADA -----------------|"), nl,
    write("|##################################################|"), nl, nl,
    write("| JOGADOR 1 => "), write(Name1), write("   --  Pontos: "), write(Points1), nl,
    write("| JOGADOR 2 => "), write(Name2), write("   --  Pontos: "), write(Points2), nl,
    write("            Pressione enter para continuar"), nl,
    read_line_to_string(user_input, _).

checkEndGame(Round, Player1, Player2) :-
    Round > 10,
    winMsg(Player1, Player2);
    true.
    
    
repl(Element, N, Save) :- 
    findall(Element, between(1, N, _), L), atomic_list_concat(L, Save).

status(Player1, Player2, Round, Level) :-
    getName(Player1, Name1),
    getName(Player2, Name2),
    getLifes(Player1, Lifes1),
    getLifes(Player2, Lifes2),
    getPoints(Player1, Points1),
    getPoints(Player2, Points2),
    
    write("Round: "), write(Round), write(" - "), write(Level), nl,
    write(Name1), write(": Lifes "), write(Lifes1), write(", Points: "), write(Points1), nl,
    write(Name2), write(": Lifes "), write(Lifes2), write(", Points: "), write(Points2),  nl.


verifyEnd(Player1, Player2) :-
    getLifes(Player1, Lifes), Lifes =< 0, 
        clear(),
        endLifesMsg(Player2, Player1).
        
statusEndGame(WinnerName, LooserName, WinnerPoints, LooserPoints) :-
    write("| -------------------- PARABENS -------------------|"), nl,
    write("| ====> "), write(WinnerName), nl,
    write("| Voce ganhou com um total de "), write(WinnerPoints), nl,
    write("| => "), write(LooserName), nl,
    write("| => "), write(LooserPoints), write(" pontos :("), nl,
    halt(0).

endLifesMsg(Player1, Player2) :- % Chamado se vidas de Player 1 acabaram
    getName(Player1, Name1),
    getName(Player2, Name2),
    write("| -------------------- PARABENS -------------------|"), nl,
    write("| ====> "), write(Name1), nl,
    write("| Voce ganhou."), nl,
    write("| As vidas de "), write(Name2), write(" acabaram."), nl,
    halt(0).
                        
winMsg(Player1, Player2) :-
    clear(),
    getName(Player1, Name1),
    getName(Player2, Name2),
    getPoints(Player1, Points1),
    getPoints(Player2, Points2),
    write("|##################################################|"), nl,
    write("|------------------- FIM DE JOGO ------------------|"), nl,
    write("|##################################################|"), nl, nl,
    
    Points1 > Points2,
        WinnerName = Name1, 
        LooserName = Name2, 
        WinnerPoints is Points1, 
        LooserPoints is Points2, 
        statusEndGame(WinnerName, LooserName, WinnerPoints, LooserPoints);

        WinnerName = Name2,
        LooserName = Name1, 
        WinnerPoints is Points2, 
        LooserPoints is Points1,
        statusEndGame(WinnerName, LooserName, WinnerPoints, LooserPoints).



%%%%%%%% corrigir %%%%%%%%
bonusMsg1(LetterBonus) :-
    LetterBonus,
    write("");
    write("1 - Escolher letra sem penalidade"), nl.
    
bonusMsg2(TypeBonus) :-
    TypeBonus,
    write("");
    write("2 - Solicitar classe gramatical da palavra"), nl.
    
bonusMsg3(SynonymsBonus) :-
    SynonymsBonus,
    write("");
    write("3 - Solicitar palavra similar"), nl.
    
bonusMsg4(SyllabesBonus) :-
    SyllabesBonus,
    write("");
    write("4 - Solicitar total de silabas"), nl.

bonusMsg(Player) :-
        chooseLetterBonus(Player, LetterBonus),
        typeWordBonus(Player, TypeBonus),
        synonymsBonus(Player, SynonymsBonus),
        syllablesBonus(Player, SyllabesBonus),
        
        bonusMsg1(LetterBonus),
        bonusMsg2(TypeBonus),
        bonusMsg3(SynonymsBonus),
        bonusMsg4(SyllabesBonus).

%%%% para verificar percentagem de preenchimento da palavra %%%%
countLetter([], _, 0).
countLetter([H|T], Letter, Count) :-
    H =:= Letter, countLetter(T, Letter, CountAux), Count is CountAux + 1;
    countLetter(T, Letter, Count).

len([], 0).
len([_|T], Len) :-
    len(T, Count), Len is Count + 1.


getPercentage(Word, Percentage) :-
    countLetter(Word, "_", Count),
    len(Word, Len),
    Percentage is ((100 * Count) // Len).

resetBonus(Player, NP) :-
    replace(Player, 3, false, NP1),
    replace(NP1, 4, false, NP2),
    replace(NP2, 5, false, NP3),
    replace(NP3, 6, false, NP).

verifyWord(Complete, Word, Player1, Player2, Round) :-
    Word = Complete ->
        clear(),
        selectLevel(Round, Level),
        addPoints(Player1, Level, NP1),
        addLifes(NP1, Level, AttP1),
        addLifes(Player2, Level, AttP2),
        endRoundStatus(AttP1, AttP2),
        NewRound is Round + 1,
        resetBonus(AttP1, UpP1),
        resetBonus(AttP2, UpP2),
        game(UpP1, UpP2, NewRound);
    write("Errrou"), nl, clear().

completeWord(Name, Percentage, Player1, Player2, Word, Round) :-
    Percentage =< 60 ->
        write(Name), nl,
        write("Digite a palavra completa:"), nl,
        read_line_to_string(user_input, Complete),
        verifyWord(Complete, Word, Player1, Player2, Round);
    clear().
%%%% --------------------------------------------------- %%%%

roundCompare(Word, ModelWord, Option, Player1, Player2, Round, Level, WordData) :-
    stringToList(Word, ListWord),
    stringToList(ModelWord, ListModel),
  
    verifyHits(ListWord, Option, Check),
    Check ->
        verifyLetter(ListModel, ListWord, Option, ModelWordAtt),
        clear(),
        status(Player1, Player2, Round, Level),
        write(ModelWordAtt), nl, nl, 
        getName(Player1, Name),  

        getPercentage(ListModel, Percentage),
        completeWord(Name, Percentage, Player1, Player2, Word, Round),
        roundGame(Player2, Player1, Round, Level, Word, ModelWordAtt, WordData)
    ;
        penalizePoints(Player1, Level, NP1),
        penalizeLifes(NP1, AttP1),
        roundGame(Player2, AttP1, Round, Level, Word, ModelWord, WordData).

defineBonus(Player1, Player2, Round, Level, Word, ModelWord, WordData, Option):-
    Option = "1", chooseLetterBonus(Player1, Bonus), not(Bonus),
        getName(Player1, Name),
        nl, write("Digite uma letra"), nl,
        write(Name), write(": "),
        read_line_to_string(user_input, Letter),
        stringToList(Word, ListWord),
        stringToList(ModelWord, ListModel),
        verifyLetter(ListModel, ListWord, Letter, ModelWordAtt),
        changeChooseLetter(Player1, NP1),
        roundGame(NP1, Player2, Round, Level, Word, ModelWordAtt, WordData);
    Option = "2", typeWordBonus(Player1, Bonus), not(Bonus), 
        getClass(WordData, C), 
        nl, write(C), nl, nl,
        write("Digite Enter para continuar..."),
        read_line_to_string(user_input, _),
        changeTypeWord(Player1, NP1),
        roundGame(NP1, Player2, Round, Level, Word, ModelWord, WordData);
    Option = "3", synonymsBonus(Player1, Bonus), not(Bonus), 
        getSynonyms(WordData, S), 
        nl, write(S), nl, nl,
        write("Digite Enter para continuar..."),
        read_line_to_string(user_input, _),
        changeSynonyms(Player1, NP1),
        roundGame(NP1, Player2, Round, Level, Word, ModelWord, WordData);
    Option = "4", syllablesBonus(Player1, Bonus), not(Bonus), 
        getSyllables(WordData, S), 
        nl, write(S), write(" silaba(s)"), nl, nl,
        write("Digite Enter para continuar..."),
        read_line_to_string(user_input, _),
        changeSyllables(Player1, NP1),
        roundGame(NP1, Player2, Round, Level, Word, ModelWord, WordData).

isBonus(Option) :-
    atom_number(Option, Num),
    Num > 0, 
    Num < 5.

verifyBonus(Player1, Player2, Round, Level, Word, ModelWord, WordData, Option) :-
    isBonus(Option) ->
    defineBonus(Player1, Player2, Round, Level, Word, ModelWord, WordData, Option);
    roundCompare(Word, ModelWord, Option, Player1, Player2, Round, Level, WordData).

roundGame(Player1, Player2, Round, Level, Word, ModelWord, WordData) :-
    verifyEnd(Player1, Player2);
    verifyEnd(Player2, Player1);
    
    clear(),
    status(Player1, Player2, Round, Level),
    write(ModelWord), nl, nl,
    nl,nl, nl,nl,nl,nl, nl,nl,
    getName(Player1, Name),
    bonusMsg(Player1),
    write("Digite uma letra ou codigo de Bonus"), nl,
    write(Name), write(": "),
    read_line_to_string(user_input, Option),
    verifyBonus(Player1, Player2, Round, Level, Word, ModelWord, WordData, Option).
    

game(Player1, Player2, Round):-
    checkEndGame(Round, Player1, Player2),
    %%% Logica de uma rodada %%
    selectLevel(Round, Level),
    getWordData(Level, WordData),
    getWord(WordData, WordAtom),
    atom_string(WordAtom, Word),
    modelWord(Word, ModelWord),
    
    roundGame(Player1, Player2, Round, Level, Word, ModelWord, WordData).
    

main :-
    %% Menu de exibicao %%
    inicializeMenu(),
    clear(),

    %%  nomes dos players  %%
    write("NOME JOGADOR 1: "),
    read_line_to_string(user_input, Player1),
    write("NOME JOGADOR 2: "),
    read_line_to_string(user_input, Player2),
    clear(),

    %%  inicializa lista dos players  %%%%%
    addBonus(Player1, DatesWithBonus1),
    addBonus(Player2, DatesWithBonus2),
    Datas1 = DatesWithBonus1,
    Datas2 = DatesWithBonus2,
    game(Datas1, Datas2, 1),
    halt(0).

%    atom_codes(W, Word), atom_chars(W, ListWord),