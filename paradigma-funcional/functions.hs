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