module FileWords(
    wordsWithLimit, 
    buildWordInfo,
    getWord
) where

import System.Random
import System.IO.Unsafe
import Data.List.Split

data WordInfo = WordInfo {
    word :: String,
    synonyms :: [String],
    gramaticalClass :: [String],
    syllables :: Int
} deriving (Show, Read)

buildWordInfo :: String -> WordInfo
buildWordInfo level = wordInfo
    where wordList = splitOn "," (wordsWithLimit level)
          word = wordList !! 0
          synonyms = splitOn "." (wordList !! 1)
          gramaticalClass = splitOn "." (wordList !! 2)
          syllables = length (splitOn "-" (wordList !! 3))
          wordInfo = WordInfo word synonyms gramaticalClass syllables
    

getRandomInteger :: Int -> Int -> Int
getRandomInteger inf sup = unsafePerformIO (randomRIO (inf, sup))

listWords :: String -> [String]
listWords file = lines (unsafePerformIO (readFile file))

randomWord :: String -> Int -> Int -> String
randomWord file inf sup =  (listWords file) !! (getRandomInteger inf sup)

getJavaWord :: String
getJavaWord
    | select == 0 = randomWord "dict_files/python.csv" 0 1302
    | otherwise = randomWord "dict_files/java.csv" 0 252
    where select = getRandomInteger 0 1

wordsWithLimit :: String -> String
wordsWithLimit level
    | level == "PYTHON" = randomWord "dict_files/python.csv" 0 1302
    | level == "JAVA" = getJavaWord
    | otherwise = randomWord "dict_files/assembly.csv" 0 400

getWord :: WordInfo -> String
getWord returnWord = word returnWord

getSynonyms :: WordInfo -> String
getSynonyms returnWord = _synonyms !! index
    where _synonyms = synonyms returnWord
          index = getRandomInteger 0 (length _synonyms)

getGramaticalClass :: WordInfo -> String
getGramaticalClass returnWord = _gramaticalClass !! index
    where _gramaticalClass = gramaticalClass returnWord
          index = getRandomInteger 0 (length _gramaticalClass)

getSyllables :: WordInfo -> Int
getSyllables returnWord = syllables returnWord

main = do
    let wordinfo = buildWordInfo "PYTHON"
    print wordinfo
    let word1 = word wordinfo
    {-let bonus1 = Bonus False False False False
    let player1 = Player 20 20 "cassio" bonus1
    let player2 = Player 20 20 "hemi" bonus1
    let level = Level "PYTHON"-}
    --print (lifes player1)
    --plays player1 player2 level word1 (modelWord word1)
    print ("oi")
