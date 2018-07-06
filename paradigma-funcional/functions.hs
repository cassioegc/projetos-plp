import System.IO  
import System.Directory  
import FileWords
import System.Process
import Data.List

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

showBonusAux :: [String] -> [String] -> [Bool] -> [String]
showBonusAux exit [] [] = exit
showBonusAux exit descricao bonus
    | not (head bonus) = showBonusAux (exit ++ [head descricao]) (tail descricao) (tail bonus)
    | otherwise = showBonusAux exit (tail descricao) (tail bonus)

showBonus :: Bonus -> String
showBonus bonus = intercalate "\n" (showBonusAux [] menu_bonus available_bonus)
            where 
                menu_bonus = ["1 - Escolher letra sem penalidade", "2 - Solicitar classe gramatical da palavra", "3 - Solicitar palavra similar", "4 - Solicitar total de silabas\n"]
                available_bonus = [(chooseLetter bonus), (typeWord bonus), (synonyms bonus), (syllables bonus)]

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
    if round <= 10 then plays player1 player2 (selectLevel round) word (modelWord (getWord word)) (round + 1)
    else putStrLn (("\nPARABENS " ++ (nickname (determineWinner player1 player2))))

containsBonus :: Player -> Bool
containsBonus player = elem False _bonus_
    where 
        _bonus = bonus player
        _bonus_ = [(chooseLetter _bonus), (typeWord _bonus), (synonyms _bonus), (syllables _bonus)]

plays :: Player -> Player -> Level -> WordInfo -> String -> Int -> IO()
plays player1 player2 level wordInfo actualWord round = do
    putStrLn(nSpaces 10 ++ actualWord)
    putStrLn("\n" ++ (nickname player1))
    putStrLn(showBonus (bonus player1))
    letter <- getLinePrompt prompt 
    
    let actualAux = verifyLetter (getWord wordInfo) letter actualWord
    
    if(isNumber letter) then (getBonus letter) player1 player2 level wordInfo actualAux round
    else if (verifyHits actualAux "_") then plays player2 (penalizePlayer player1 (verifyHits (getWord wordInfo) letter) level) level wordInfo actualAux round
    else manyPlays player1 player2 round
    where 
        prompt = if (containsBonus player1) then "Digite uma letra ou codigo de bonus\n> " else "Digite uma letra\n> "
    
newPlayerBonus :: Player -> Int -> Player
newPlayerBonus player _bonus 
    | _bonus == 1 = Player (points player) (lifes player) (nickname player) bonus_choose_letter
    | _bonus == 2 = Player (points player) (lifes player) (nickname player) bonus_type_word
    | _bonus == 3 = Player (points player) (lifes player) (nickname player) bonus_synonyms
    | otherwise = Player (points player) (lifes player) (nickname player) bonus_syllables

    where
        bonus_choose_letter = Bonus True (typeWord player_bonus) (synonyms player_bonus) (syllables player_bonus)
        bonus_type_word = Bonus (chooseLetter player_bonus) True (synonyms player_bonus) (syllables player_bonus)
        bonus_synonyms = Bonus (chooseLetter player_bonus) (typeWord player_bonus) True (syllables player_bonus)
        bonus_syllables = Bonus (chooseLetter player_bonus) (typeWord player_bonus) (synonyms player_bonus) True
        player_bonus = bonus player

checkSimilarWord :: Player -> Player -> Level -> WordInfo -> String -> Int -> IO()
checkSimilarWord player1 player2 level wordInfo actualAux round
    | not (synonyms (bonus player1)) = similarWord player1 player2 level wordInfo actualAux round
    | otherwise = do
        clearScreen
        putStr "Voce nao possui mais este bonus\n"
        plays player1 player2 level wordInfo actualAux round

similarWord :: Player -> Player -> Level -> WordInfo -> String -> Int -> IO()
similarWord player1 player2 level wordInfo actualAux round = do
    clearScreen
    putStr ((getSynonyms wordInfo)++"\n")
    plays new_player1 player2 level wordInfo actualAux round
    where new_player1 = newPlayerBonus player1 3

checkTotalSyllables :: Player -> Player -> Level -> WordInfo -> String -> Int -> IO()
checkTotalSyllables player1 player2 level wordInfo actualAux round
    | not (syllables (bonus player1)) = totalSyllables player1 player2 level wordInfo actualAux round
    | otherwise = do
        clearScreen
        putStr "Voce nao possui mais este bonus\n"
        plays player1 player2 level wordInfo actualAux round

totalSyllables :: Player -> Player -> Level -> WordInfo -> String -> Int -> IO()
totalSyllables player1 player2 level wordInfo actualAux round = do
    clearScreen
    putStr ((show (getSyllables wordInfo))++"\n")
    plays new_player1 player2 level wordInfo actualAux round
    where new_player1 = newPlayerBonus player1 4

checkGramaticalClass :: Player -> Player -> Level -> WordInfo -> String -> Int -> IO()
checkGramaticalClass player1 player2 level wordInfo actualAux round
    | not (typeWord (bonus player1)) = gramaticalClass player1 player2 level wordInfo actualAux round
    | otherwise = do
        clearScreen
        putStr "Voce nao possui mais este bonus\n"
        plays player1 player2 level wordInfo actualAux round

gramaticalClass :: Player -> Player -> Level -> WordInfo -> String -> Int -> IO()
gramaticalClass player1 player2 level wordInfo actualAux round = do
    clearScreen
    putStr ((getGramaticalClass wordInfo)++"\n")
    plays new_player1 player2 level wordInfo actualAux round
    where new_player1 = newPlayerBonus player1 2

checkNoPenality :: Player -> Player -> Level -> WordInfo -> String -> Int -> IO()
checkNoPenality player1 player2 level wordInfo actualAux round
    | not (chooseLetter (bonus player1)) = noPenality player1 player2 level wordInfo actualAux round
    | otherwise = do
        clearScreen
        putStr "Voce nao possui mais este bonus\n"
        plays player1 player2 level wordInfo actualAux round

noPenality :: Player -> Player -> Level -> WordInfo -> String -> Int -> IO()
noPenality player1 player2 level wordInfo actualWord round = do
    clearScreen
    putStrLn(nSpaces 10 ++ actualWord)
    letter <- getLinePrompt "Digite uma letra (bonus)\n> "
    let actualAux = verifyLetter (getWord wordInfo) letter actualWord
    plays new_player1 player2 level wordInfo actualAux round
    where new_player1 = newPlayerBonus player1 1

getBonus :: String -> (Player -> Player -> Level -> WordInfo -> String -> Int -> IO())
getBonus letter = do
    if(letter == "2") then checkGramaticalClass
    else if (letter == "3") then checkSimilarWord
    else if(letter == "4") then checkTotalSyllables
    else checkNoPenality
    
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
