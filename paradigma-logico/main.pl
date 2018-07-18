:- initialization(main).

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


main :-
    read_line_to_string(user_input, Word),
    atom_codes(W, Word), atom_chars(W, ListWord),
    % len(ListWord, X),
    modelWord(ListWord, Y),
    verifyLetter(Y, ListWord, "a", ActualWord),
    write(ActualWord).