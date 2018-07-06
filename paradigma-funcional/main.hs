import System.IO  
import System.Directory  
import FileWords
import System.Process
import Data.List
import System.Info

clearScreen = if (System.Info.os) == "mingw32" then system "cls" else system "clear"

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
verifyHits word letter = isNumber letter || [head word] == letter || verifyHits (tail word) letter


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
        "3 - QUANDO FALTAR 40% DA PALAVRA EM QUESTAO, O JOGADOR SERA\n" ++
        "    SOLICITADO A DAR A RESPOSTA CORRETA. EM CASO DE ERRO, O\n" ++
        "    JOGADOR SOFRERA AS PUNICOES JA CITADAS.\n\n" ++
        "4 - O JOGADOR QUE ACERTAR RECEBERÁ X PONTOS.\n\n" ++
        "5 - ZERADA AS CHANCES, O PERDEDOR AGUARDA O FINAL DA RODADA,\n" ++
        "    PODENDO O ADVERSARIO LEVAR OS PONTOS SE ACERTAR A PALAVRA.\n\n" ++
        "6 - UMA NOVA PALAVRA SORTEADA A CADA RODADA.\n\n" ++
        "7 - A CADA RODADA, UM BONUS PODERA SER SOLICIDADO UMA UNICA\n" ++
        "    VEZ(TIPO DA PALAVRA, PALAVRA SEMELHANTE E NUMERO DE SILABAS).\n\n" ++
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
    if round <= 10 then plays player1 player2 (selectLevel round) word (modelWord (getWord word)) (round + 1) False
    else putStrLn (("\nPARABENS " ++ (nickname (determineWinner player1 player2))))

containsBonus :: Player -> Bool
containsBonus player = elem False _bonus_
    where 
        _bonus = bonus player
        _bonus_ = [(chooseLetter _bonus), (typeWord _bonus), (synonyms _bonus), (syllables _bonus)]


warningBonus :: Player -> Player -> Level -> WordInfo -> String -> Int -> IO()
warningBonus player1 player2 level wordInfo actualAux round = do
    clearScreen
    putStr("Você só poder pedir um bonus por rodada\n\n")
    plays player1 player2 level wordInfo actualAux round True

header :: Player -> Player -> Int -> String
header player1 player2 round = line1 ++ line2 ++ line3
    where
        line1 = playerLabel player1
        line2 = playerLabel player2 ++ "\n"
        line3 = "Nivel: " ++ (name (selectLevel round)) ++ "\n\n"

countLetter :: String -> String -> Int
countLetter letter [] = 0
countLetter letter (w:word) =
    if [w] == letter then 1 + countLetter letter word
    else 0 + countLetter letter word

getPercentage :: String -> Int
getPercentage word = div (100 * (countLetter "_"  word))  (length word)

playerHit :: Player -> Player
playerHit player = Player ((points player) + 15) (lifes player) (nickname player) (bonus player)

completeWord :: Player -> Player -> Level -> Int -> WordInfo -> String -> IO()
completeWord player1 player2 level round wordInfo actualAux = do
    putStrLn (nSpaces 10 ++ actualAux)
    putStrLn (nickname player1 ++ " Digite a palavra completa:")
    newWord <- getLine
    if newWord == (getWord wordInfo) then manyPlays player2 (playerHit player1) round
    else plays player2 player1 level wordInfo actualAux round False


plays :: Player -> Player -> Level -> WordInfo -> String -> Int -> Bool -> IO()
plays player1 player2 level wordInfo actualWord round usedBonus
    | (lifes player1) <= 0 = putStrLn ("\nPARABENS " ++ (nickname player2) ++ "\nAs vidas de " ++ (nickname player1) ++ " acabaram :(")
    | (lifes player2) <= 0 = putStrLn ("\nPARABENS " ++ (nickname player1) ++ "\nAs vidas de " ++ (nickname player2) ++ " acabaram :(")
    | otherwise = do
        putStrLn (header player1 player2 round)
        putStrLn(nSpaces 10 ++ actualWord)
        putStrLn("\n" ++ (nickname player1))
        putStrLn(showBonus (bonus player1))
        letter <- getLinePrompt prompt 
        
        let actualAux = verifyLetter (getWord wordInfo) letter actualWord 
        clearScreen
        let playerAux = penalizePlayer player1 (verifyHits (getWord wordInfo) letter) level

        if (usedBonus && isNumber letter) then warningBonus playerAux player2 level wordInfo actualAux round
        else if(isNumber letter) then (getBonus letter) playerAux player2 level wordInfo actualAux round
        else if (getPercentage actualAux) <= 60 then completeWord playerAux player2 level round wordInfo actualAux
        else if (verifyHits actualAux "_") then plays player2 playerAux level wordInfo actualAux round False
        else statusMatch playerAux player2 round
    where 
        prompt = if (containsBonus player1) then "Digite uma letra ou codigo de bonus\n> " else "Digite uma letra\n> "

playerLabel :: Player -> String
playerLabel player = (nickname player) ++ "    Vidas : " ++ (show(lifes player)) ++ "\n"

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
        plays player1 player2 level wordInfo actualAux round False

similarWord :: Player -> Player -> Level -> WordInfo -> String -> Int -> IO()
similarWord player1 player2 level wordInfo actualAux round = do
    clearScreen
    putStr ("SEMELHANTE: " ++ (getSynonyms wordInfo)++"\n\n")
    plays new_player1 player2 level wordInfo actualAux round True
    where new_player1 = newPlayerBonus player1 3

checkTotalSyllables :: Player -> Player -> Level -> WordInfo -> String -> Int -> IO()
checkTotalSyllables player1 player2 level wordInfo actualAux round
    | not (syllables (bonus player1)) = totalSyllables player1 player2 level wordInfo actualAux round
    | otherwise = do
        clearScreen
        putStr "Voce nao possui mais este bonus\n"
        plays player1 player2 level wordInfo actualAux round False

totalSyllables :: Player -> Player -> Level -> WordInfo -> String -> Int -> IO()
totalSyllables player1 player2 level wordInfo actualAux round = do
    clearScreen
    putStr ("N SILABAS: " ++ (show (getSyllables wordInfo))++"\n\n")
    plays new_player1 player2 level wordInfo actualAux round True
    where new_player1 = newPlayerBonus player1 4

checkGramaticalClass :: Player -> Player -> Level -> WordInfo -> String -> Int -> IO()
checkGramaticalClass player1 player2 level wordInfo actualAux round
    | not (typeWord (bonus player1)) = gramaticalClass player1 player2 level wordInfo actualAux round
    | otherwise = do
        clearScreen
        putStr "Voce nao possui mais este bonus\n"
        plays player1 player2 level wordInfo actualAux round False

gramaticalClass :: Player -> Player -> Level -> WordInfo -> String -> Int -> IO()
gramaticalClass player1 player2 level wordInfo actualAux round = do
    clearScreen
    putStr ("CLASSE: " ++ (getGramaticalClass wordInfo)++"\n\n")
    plays new_player1 player2 level wordInfo actualAux round True
    where new_player1 = newPlayerBonus player1 2

checkNoPenality :: Player -> Player -> Level -> WordInfo -> String -> Int -> IO()
checkNoPenality player1 player2 level wordInfo actualAux round
    | not (chooseLetter (bonus player1)) = noPenality player1 player2 level wordInfo actualAux round 
    | otherwise = do
        clearScreen
        putStr "Voce nao possui mais este bonus\n"
        plays player1 player2 level wordInfo actualAux round False

noPenality :: Player -> Player -> Level -> WordInfo -> String -> Int -> IO()
noPenality player1 player2 level wordInfo actualWord round = do
    clearScreen
    putStrLn(nSpaces 10 ++ actualWord ++ "\n\n")
    letter <- getLinePrompt "Digite uma letra (bonus)\n> "
    let actualAux = verifyLetter (getWord wordInfo) letter actualWord
    clearScreen
    plays new_player1 player2 level wordInfo actualAux round True
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

getLen :: String -> String -> Int
getLen p1 p2 = max(max size1 size2) 6
    where 
        size1 = length p1
        size2 = length p2

statusMatch :: Player -> Player -> Int -> IO()
statusMatch player1 player2 round = do
    putStrLn saida 
    aux_pause <- getLinePrompt "Pressione enter para continuar\n\n"
    clearScreen
    manyPlays player1 player2 round
    where 
        end_game = round == 10
        temp_p1 = (nickname player1)
        temp_p2 = (nickname player2)
        lenp1 = length temp_p1
        lenp2 = length temp_p2
        spp1 = (show (points player1)) ++ (nSpaces (6-(length (show (points player1)))))
        spp2 = (show (points player2)) ++ (nSpaces (6-(length (show (points player2)))))
        len = getLen temp_p1 temp_p2
        players = if len /= 6 then ("Palyer" ++ (nSpaces (len-6))) else "Player"
        p1 = if len /= lenp1 then (temp_p1 ++ (nSpaces (len-lenp1))) else temp_p1
        p2 = if len /= lenp2 then (temp_p2 ++ (nSpaces (len-lenp2))) else temp_p2
        divi = (concat(replicate (len+13) "-")) ++ "\n"
        head = if end_game then "================== RESUMO DA PARTIDA ======================\n" else "SITUACAO APOS A " ++ (show (round-1)) ++ "ª RODADA\n"
        saida = "\n\n" ++ head ++ divi ++ "| " ++ players ++ " | Pontos |\n" ++ divi ++ "| " ++ p1 ++ " | " ++ spp1 ++ " |\n" ++ divi ++ "| " ++ p2 ++ " | " ++ spp2 ++ " |\n" ++ divi ++ "\n\n"
        
main = do
    clearScreen
    putStr inicializeMenu
    sleep <- getLine
    clearScreen
    nickname1 <- getLinePrompt "NOME JOGADOR 1: "
    nickname2 <- getLinePrompt "NOME JOGADOR 2: "
    clearScreen

    let bonus = Bonus False False False False
    let player1 = Player 20 20 nickname1 bonus
    let player2 = Player 20 20 nickname2 bonus

    manyPlays player1 player2 1