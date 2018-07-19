
len([], 0).
len([_|T], Count) :-
    len(T, Count1), Count is Count1 + 1.

modelWord([], "").
modelWord([_|T], Exit) :-
    modelWord(T, Under), atom_concat("_", Under, Exit).

verifyLetter([], [], Letter, "").
verifyLetter([H1|T1], [H2|T2], Letter, ActualWordRet) :-
    H2 =:= Letter, verifyLetter(T1, T2, Letter, ActualWordAtt), atom_concat(H2, ActualWordAtt, ActualWordRet);
    verifyLetter(T1, T2, Letter, ActualWordAtt), atom_concat(H1, ActualWordAtt, ActualWordRet).


verifyHits([], Letter, Hits) :- Hits = false.
verifyHits([H|T], Letter, Hits) :-
    H =:= Letter, Hits = true;
    verifyHits(T, Letter, Result), Hits = Result.


insert([], Date, [Date]).
insert([H|T1], Date, [H|T2]) :-
    insert(T1, Date, T2).


main :-
    read_line_to_string(user_input, Player1),
    read_line_to_string(user_input, Player2),
    DatesPlayer1 is insert()


    read_line_to_string(user_input, Word),
    atom_codes(W, Word), atom_chars(W, ListWord),
    % len(ListWord, X),
    modelWord(ListWord, Y),
    verifyLetter(Y, ListWord, "a", ActualWord),
    write(ActualWord).