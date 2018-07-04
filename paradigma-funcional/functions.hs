import System.IO  
import System.Directory  
import FileWords
import System.Process

clearScreen = system "clear"

data Bonus = Bonus {
    chooseLetter :: Bool,
    typeWord :: Bool,
    synonyms :: Bool,
    syllables :: Bool
} deriving (Show, Read)

data Player = Player {
    points :: Int,
    lifes :: Int,
    nickname :: String,
    bonus :: Bonus
} deriving (Show, Read)

data Level = Level {
    name :: String
} deriving (Show, Read)  

getLinePrompt :: String -> IO String
getLinePrompt text = do
    putStr text
    hFlush stdout
    getLine
    
nSpaces :: Int -> String
nSpaces len = replicate len ' '


verifyLetter :: String -> String -> String -> String 
verifyLetter "" letter actualWord = ""
verifyLetter word letter actualWord = 
    if [head word] == letter 
        then letter ++ verifyLetter (tail word) letter (tail actualWord)
    else 
        [head actualWord] ++ verifyLetter (tail word) letter (tail actualWord)

verifyHits :: String -> String -> Bool
verifyHits "" letter = False
verifyHits word letter = [head word] == letter || verifyHits (tail word) letter


modelWord :: String -> String
modelWord "" = ""
modelWord word = "_" ++ modelWord (tail word)


inicializeMenu :: String
inicializeMenu = "===========================================================\n" ++
		"|               FORCA, RODA jequiti A RODA                |\n" ++
		"===========================================================\n" ++
		"--------------------- COMO FUNCIONA -----------------------\n\n" ++
		"1 - DOIS JOGADORES APRESENTAM X CHANCES CADA UM POR RODADA \n" ++
		"    PARA ADIVINHAR UMA PALAVRA ALEATORIA LETRA A LETRA.\n\n" ++
		"2 - CADA LETRA ERRADA, DEBITA PONTOS NA QUANTIDADE \n" ++
		"    DETERMINADA PELO NIVEL (PYTHON, JAVA E ASSEMBLY).\n\n" ++
		"3 - QUANTO FALTAR 40% DA PALAVRA EM QUESTAO, O JOGADOR SERA\n" ++
		"    SOLICITADO A DAR A RESPOSTA CORRETA. EM CASO DE ERRO, O\n" ++
		"    JOGADOR SOFRERA AS PUNICOES JA CITADAS.\n\n" ++
		"4 - O JOGADOR QUE ACERTAR RECEBERÁ X PONTOS.\n\n" ++
		"5 - ZERADA AS CHANCES, O PERDEDOR AGUARDA O FINAL DA RODADA,\n" ++
		"    PODENDO O ADVERSARIO LEVAR OS PONTOS SE ACERTAR A PALAVRA.\n\n" ++
		"6 - UMA NOVA PALAVRA SORTEADA A CADA RODADA.\n\n" ++
		"7 - A CADA RODADA, UM BONUS PODERA SER SOLICIDADO UMA UNICA\n" ++
		"    VEZ(TIPO DA PALAVRA, PALAVRA SEMELHANTE E NUMERO DE SILABA).\n\n" ++
		"8 - AO FINAL DO JOGO, SERA O VENCEDOR AQUELE QUE ACUMULOU \n" ++
		"    MAIS PONTOS.\n\n" ++
		"              Pressione enter para continuar\n"

showBonus :: String
showBonus = "1 - Escolher letra sem penalidade\n"++ 
    		"2 - Solicitar classe gramatical da palavra\n" ++ 
    		"3 - Solicitar palavra similar\n" ++ 
    		"4 - Solicitar total de silabas\n"

getPenalize:: Level -> Int
getPenalize level  |(name level) == "PYTHON" = 2
	|(name level) == "JAVA" = 5
	|otherwise = 8

penalizePlayer :: Player -> Bool -> Level -> Player
penalizePlayer player hit level | hit = player
    | otherwise = Player ((points player) - getPenalize level) ((lifes player) - 1) (nickname player) (bonus player)

determineWinner :: Player -> Player -> Player
determineWinner player1 player2
    | points player2 > points player1 = player2
    | otherwise = player1

selectLevel :: Int -> Level
selectLevel round
    | round < 4 = Level "PYTHON"
    | round < 7 = Level "JAVA"
    | otherwise = Level "ASSEMBLY"

manyPlays :: Player -> Player -> Int -> IO()
manyPlays player1 player2 round = do
    let word = buildWordInfo (name (selectLevel round))
    if round <= 10 then plays player1 player2 (selectLevel round) word (modelWord (getWord word)) (round + 1) False
    else putStrLn (("\nPARABENS " ++ (nickname (determineWinner player1 player2))))

plays :: Player -> Player -> Level -> WordInfo -> String -> Int -> Bool-> IO() 
plays player1 player2 level wordInfo actualWord round isBonus = do
    if(not isBonus)then putStrLn(concat $ replicate 100 "\n")
    else putStrLn("")
    putStrLn(nSpaces 10 ++ actualWord)
    putStrLn("\n" ++ (nickname player1))
    putStrLn(showBonus)
    letter <- getLinePrompt "Digite uma letra ou codigo de bonus\n> "
    
    let actualAux = verifyLetter (getWord wordInfo) letter actualWord
    
    if(isNumber letter) then getBonus letter player1 player2 level wordInfo actualAux round True
    else if (verifyHits actualAux "_") then plays player2 (penalizePlayer player1 (verifyHits (getWord wordInfo) letter) level) level wordInfo actualAux round False
    else manyPlays player1 player2 round
    
similarWord :: WordInfo -> IO()
similarWord word = do
    putStrLn (getSynonyms word)

totalSyllables :: WordInfo -> IO()
totalSyllables word = do
    print (getSyllables word)

gramaticalClass :: WordInfo -> IO()
gramaticalClass word = do
    print (getGramaticalClass word)


getBonus :: String -> Player -> Player -> Level -> WordInfo -> String -> Int -> Bool -> IO()
getBonus letter player1 player2 level wordInfo actualWord round isBonus = do
	if(letter == "2") then gramaticalClass wordInfo
	else if (letter == "3") then similarWord wordInfo
	else if(letter == "4") then totalSyllables wordInfo
	else print("No penatily")
	
	if(isNumber letter) then plays player1 player2 level wordInfo actualWord round isBonus
	else print("")
    
isNumber :: String -> Bool
isNumber num = do
    if (num == "1" || num == "2" || num == "3" || num == "4") then True
    else False

main = do
    putStr inicializeMenu
    sleep <- getLine
    clearScreen
    nickname1 <- getLinePrompt "NOME JOGADOR 1: "
    nickname2 <- getLinePrompt "NOME JOGADOR 2: "
    clearScreen

    let bonus1 = Bonus False False False False
    let player1 = Player 20 20 nickname1 bonus1
    let player2 = Player 20 20 nickname2 bonus1

    manyPlays player1 player2 1
