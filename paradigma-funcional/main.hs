let player1 = ("", 0, 0, False, False, False, False)
let player2 = ("", 0, 0, False, False, False, False)

modelWord :: Int -> String -> String
modelWord 0 word = word
modelWord len word = '_' : modelWord (len-1) word

verifyLetter :: [Char] -> Char -> [Char] -> [Char] 
verifyLetter [] letter actualWord = []
verifyLetter word letter actualWord = 
    if (head word) == letter 
        then [letter] ++ verifyLetter (tail word) letter (tail actualWord)
    else 
        [head actualWord] ++ verifyLetter (tail word) letter (tail actualWord)
