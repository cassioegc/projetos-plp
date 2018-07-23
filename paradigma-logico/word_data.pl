:- module(
    'word_data', 
    [getWordData/2,
     getWord/2,
     getSynonyms/2,
     getClass/2,
     getSyllables/2
    ]
).

dicByLevel("PYTHON", 'dict_files/python.csv').
dicByLevel("ASSEMBLY", 'dict_files/assembly.csv').
dicByLevel(1, 'dict_files/python.csv').
dicByLevel(0, 'dict_files/java.csv').
dicByLevel("JAVA", DictPath):- 
    RD is random(2), 
    dicByLevel(RD, DictPath).

rows_to_lists(Rows, Lists):- maplist(row_to_list, Rows, Lists).
row_to_list(Row, List):- Row =.. [row|List].
get_rows_data(File, Lists):-
  csv_read_file(File, Rows, []),
  rows_to_lists(Rows, Lists).

  
readDict(DictPath, List):- get_rows_data(DictPath, List).

randomLine(Dict, Line):- 
    length(Dict, Len), 
    RD is random(Len), 
    nth0(RD, Dict, Line).

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

getWord(WordData, Word):-
    nth0(0, WordData, Word).     

getSynonyms(WordData, Synonym) :- 
    nth0(1, WordData, Synonyms),
    length(Synonyms, Len),
    RD is random(Len),
    nth0(RD, Synonyms, Synonym).
    
getClass(WordData, Class) :- 
    nth0(2, WordData, Class_),
    length(Class_, Len),
    RD is random(Len),
    nth0(RD, Class_, Class).
    
getSyllables(WordData, Syllables) :-
    nth0(3, WordData, Syllables).
   
