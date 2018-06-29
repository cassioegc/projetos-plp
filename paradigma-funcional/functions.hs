import System.IO  
import System.Directory  
import FileWords

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

inicialize_menu :: String
inicialize_menu = "===========================================================\n" ++
		"|               ,FORCA, RODA jequiti A RODA                |\n" ++
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

   
{-main :: IO()
main = do
    -- LER OS DADOS DO JOGADOR 1 --
    -- E FAZ O CAST PARA O TIPO PLAYER --
    -- PRECISA REMOVER O ARQUIVO! APOS LIDO --
    contents <- readFile "player1_data.txt"
    removeFile "player1_data.txt"
    let gamer = read contents :: Player-}


get_penalize:: Level -> Int
get_penalize level  |(name level) == "PYTHON" = 2
	|(name level) == "JAVA" = 5
	|otherwise = 8

    -- ESCREVE OS NOVOS DADOS DO JOGADOR1 --
    -- PASSANDO O NOME DO ARQUIVO E A MODIFICACAO A SER FEITA --
    --writeFile "player1_data.txt" (show (inicializeBonus gamer))
    --putStrLn (show (nickname gamer))

penalize_player :: Player -> Bool -> Level -> Player
penalize_player player hit level | hit = player
    | otherwise = Player ((points player) - get_penalize level) ((lifes player) - 1) (nickname player) (bonus player)


plays :: Player -> Player -> Level -> WordInfo -> String -> Bool -> IO()
plays player1 player2 level wordInfo actualWord isBonus = do
    putStrLn actualWord
    putStrLn("Digite uma letra ou codigo de bonus " ++ (nickname player1))
    letter <- getLine

    let actualAux = verifyLetter (getWord wordInfo) letter actualWord
    
    if (isBonus) then plays player2 player1 level wordInfo actualAux
    else if (verifyHits actualAux "_") then plays player2 (penalize_player player1 (verifyHits (getWord wordInfo) letter) level ) level wordInfo actualAux
    else print(player1, player2)


{-similarWord :: WordInfo -> IO()
similarWord word = -}

totalSyllables :: WordInfo -> IO()
totalSyllables word = do
    print (getSyllabes word)

gramaticalClass :: WordInfo -> IO()
gramaticalClass word = do
    print (getGramaticalClass word)


getBonus :: String -> WordInfo -> IO()
getBonus bonus word = do
    if (bonus == "1") then chooseLetter wordInfo
    else if (bonus == "2") then gramaticalClass wordInfo
    else if (bonus == "3") then similarWord wordInfo
    else if (bonus == "4") then totalSyllables wordInfo
    else print ("")

main = do
    let wordInfo = buildWordInfo "PYTHON"
    let word = getWord wordInfo
    let bonus1 = Bonus False False False False
    let player1 = Player 20 20 "cassio" bonus1
    let player2 = Player 20 20 "hemi" bonus1
    let level = Level "PYTHON"
    print (lifes player1)
    plays player1 player2 level wordInfo (modelWord word)
    print word

	--AQUI SE INICIA AS CONDICOES DE PARADA DO JOGO. ESTA COMENTADO PARA AINDA INSERIR FUNCOES DE FLUXO

	{--Condicao de parada da partida
	whl:: Int -> Int -> Int -> String -> IO()
	whl x lifes_player1 lifes_player2 actual_word | x < 10 && lifes_player1 > 0 && lifes_player2 > 0 && not complete_word = do 
					putStrLn(show x)
					whl (x + 1) lifes_player1 lifes_player2
						|otherwise = putStrLn("Final da Partida")
						where complete_word = verify_hits "_" actual_word

	--Funcao auxiliar (teste)
	whl_aux:: IO()
	whl_aux = whl 0 1 1 "hits"--}

