len([], 0).
len([_|T], Count) :-
    len(T, Count1), Count is Count1 + 1.


modelWord([], "").
modelWord([_|T], Exit) :-
    modelWord(T, Under), atom_concat("_", Under, Exit).
    

:- initialization(main).
main :-
    read_line_to_string(user_input, Word),
    atom_codes(W, Word), atom_chars(W, ListWord),
    % len(ListWord, X),
    modelWord(ListWord, Y),
    write(Y).

    
    
