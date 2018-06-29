import System.IO  
import System.Directory  

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

main :: IO()
main = do
    -- LER OS DADOS DO JOGADOR 1 --
    -- E FAZ O CAST PARA O TIPO PLAYER --
    -- PRECISA REMOVER O ARQUIVO! APOS LIDO --
    contents <- readFile "player1_data.txt"
    removeFile "player1_data.txt"
    let gamer = read contents :: Player

    -- ESCREVE OS NOVOS DADOS DO JOGADOR1 --
    -- PASSANDO O NOME DO ARQUIVO E A MODIFICACAO A SER FEITA --
    writeFile "player1_data.txt" (show (inicializeBonus gamer))

    -- PRINTAO --
    putStrLn (show (nickname gamer))