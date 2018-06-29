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

setBonus :: Player -> String -> Bool -> Player
setBonus gamer kind value =
    | kind EQ "choose_letter" = Player {
        points = points gamer,
        lifes = lifes gamer,
        nickname = nickname gamer,
        chooseLetter = value,
        typeWord = typeWord gamer,
        synonyms = synonyms gamer,
        syllables = syllables gamer
        }
    | kind EQ "type_word" = Player {
        points = points gamer,
        lifes = lifes gamer,
        nickname = nickname gamer,
        chooseLetter = chooseLetter gamer,
        typeWord = value,
        synonyms = synonyms gamer,
        syllables = syllables gamer
        }
    | kind EQ "synonyms" = Player {
        points = points gamer,
        lifes = lifes gamer,
        nickname = nickname gamer,
        chooseLetter = chooseLetter gamer,
        typeWord = typeWord gamer,
        synonyms = value,
        syllables = syllables gamer
        }
    | kind EQ "syllables" = Player {
        points = points gamer,
        lifes = lifes gamer,
        nickname = nickname gamer,
        chooseLetter = chooseLetter gamer,
        typeWord = typeWord gamer,
        synonyms = synonyms gamer,
        syllables = value
        }

--Parametros: Nome do nivel atual
--Retorno: Pontos a adicionar
add_points :: Level -> Int
add_points level | (name level) == "PYTHON" = 20
	|(name level) == "JAVA" = 30
	|otherwise = 50 


--Parametros: Numero de rounds
--Retorno: Nivel atual
set_level:: Int -> String
set_level round |round <= 3 = "PYTHON"
	|round >= 4 && round <= 6 = "JAVA"
	|otherwise = "ASSEMBLY"

--Parametros: Nome do nivel atual
--Retorno: Vidas a adicionar
add_lifes:: Level -> Int
add_lifes level |(name level) == "PYTHON" = 7
	|(name level) == "JAVA" = 5
	|otherwise = 3

--Parametros: Nome do nivel atual, pontos do jogador perdedor
--Retorno: Pontos a transferir
transfer_points:: Level -> Player -> Float
transfer_points level loser_player |(name level) == "PYTHON" = fromIntegral (points loser_player) * 0.1
	|(name level) == "JAVA" = fromIntegral (points loser_player) * 0.15
	|otherwise = fromIntegral (points loser_player) * 0.2

--Parametros: Nome do nivel atual
--Retorno: Tupla com vidas a diminuir e penalidade de pontos do jogador (nessa ordem)
penalize_player:: Level -> (Int, Int)
penalize_player level  |(name level) == "PYTHON" = (1, 2)
	|(name level) == "JAVA" = (1, 5)
	|otherwise = (1, 8)


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

alguma word atual = do
    putStrLn atual
    letra <- getLine
    alguma word (verifyLetter word letra atual)