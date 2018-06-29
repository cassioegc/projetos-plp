data Player = Player {
    points :: Int,
    lifes :: Int,
    nickname :: String,
    chooseLetter :: Bool,
    typeWord :: Bool,
    synonyms :: Bool,
    syllables :: Bool
} deriving (Show, Read)

data Level = Level {
    name :: String
}

inicializeBonus :: Player -> Player
inicializeBonus gamer = Player {
    points = points gamer,
    lifes = lifes gamer,
    nickname = nickname gamer,
    chooseLetter = True,
    typeWord = True,
    synonyms = True,
    syllables = True
}



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

modelWord :: String -> String
modelWord "" = ""
modelWord word = "_" ++ modelWord (tail word)

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

penalize_player:: Level -> (Int, Int)
penalize_player level  |(name level) == "PYTHON" = (1, 2)
	|(name level) == "JAVA" = (1, 5)
	|otherwise = (1, 8)

alguma :: String -> String -> IO()
alguma player1 player2 level word atual = do
    putStrLn atual
    letra <- getLine
    let actualAux = verifyLetter word letra atual
    if not (verifyHits word letra) then (lifes player1) = 2 
    if verifyHits actualAux "_" then alguma player2 player1 level word actualAux
    else putStrLn()
main = do
    let player1 = Player 20 20 "cassio" False False False False
    let player2 = Player 20 20 "hemi" False False False False
    alguma player1 player2 "PYTHON" "haskell" "_______"
    print ((lifes player1)

