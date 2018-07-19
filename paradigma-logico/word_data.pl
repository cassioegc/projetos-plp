:- module('word_data', [getWordData/2]).

dicByLevel("PYTHON", 'dict_files/python.csv').
dicByLevel("ASSEMBLY", 'dict_files/assembly.csv').
dicByLevel(1, 'dict_files/python.csv').
dicByLevel(0, 'dict_files/java.csv').
dicByLevel("JAVA", DictPath):- RD is random(2), dicByLevel(RD, DictPath).

get_rows_data(File, Lists):-
  csv_read_file(File, Rows, []),
  rows_to_lists(Rows, Lists).

rows_to_lists(Rows, Lists):-
  maplist(row_to_list, Rows, Lists).

row_to_list(Row, List):-
  Row =.. [row|List].
  
readDict(DictPath, List):- get_rows_data(DictPath, List).

randomLine(Dict, Line):- length(Dict, Len), RD is random(Len), nth0(RD, Dict, Line).

getWordData(Level, Save):- 
    dicByLevel(Level, DictPath),
    readDict(DictPath, Dict),
    randomLine(Dict, Line),
    Line = [I,J,K,L],
    split_string(J, ".", "", Synonyms),
    split_string(K, ".", "", Class),
    split_string(L, "-", "", Syllables),
    length(Syllables, Len),
    append([I], [Synonyms, Class, Len], Save).
