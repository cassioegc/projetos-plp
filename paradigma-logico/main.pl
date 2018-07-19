:- initialization(main).

modelWord([], "").
modelWord([_|T], Exit) :-
    modelWord(T, Under), atom_concat("_", Under, Exit).

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

main :-
    % Level = [],

        %%%%%  nomes dos players  %%%%%
    read_line_to_string(user_input, Player1),
    read_line_to_string(user_input, Player2),
  

   %%%%%  inicializa lista dos players  %%%%%
    addBonus(Player1, DatesWithBonus1),
    addBonus(Player2, DatesWithBonus2),
    Datas1 = DatesWithBonus1,
    Datas2 = DatesWithBonus2.

  %%%%% inserir aqui sorteio da palavra  %%%%%


%    atom_codes(W, Word), atom_chars(W, ListWord),