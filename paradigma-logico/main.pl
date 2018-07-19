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

% incompleto %
addPoints(PlayerData, "PYTHON", Result) :-
    nth0(1, PlayerData, OldPoints),
    NewPoints is 15 + OldPoints,
    replace(PlayerData, 1, NewPoints, Result).

main :-
    % Level = [],
    string_concat("", "PYTHON", Level),

        %%%%%  nomes dos players  %%%%%
    read_line_to_string(user_input, Player1),
    read_line_to_string(user_input, Player2),
  

   %%%%%  inicializa lista dos players  %%%%%
    addBonus(Player1, DatesWithBonus1),
    addBonus(Player2, DatesWithBonus2),
    Datas1 = DatesWithBonus1,
    Datas2 = DatesWithBonus2,

    %%% adicionar pontos %%
    %% addPoints(Datas1, "PYTHON", Result),
    %% Datas1 = Result,
    %% writeln(Datas1),

  %%%%% inserir aqui sorteio da palavra  %%%%%
    getWordData(Level, WordData),
    nth0(0, WordData, Word),
    
  
  %%%%% Modelagem da palavra %%%%%
    modelWord(Word, ModelWord),
    writeln(Word),
    writeln(ModelWord).
    

%    atom_codes(W, Word), atom_chars(W, ListWord),
