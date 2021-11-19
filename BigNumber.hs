module BigNumber (BigNumber (..),
                  scanner,
                  output,
                  somaBN,
                  subBN,
                  mulBN) where

type BigNumber = [Int]

scanner :: String -> BigNumber
scanner stringInput =
  map(\x -> read [x]::Int) stringInput


output :: BigNumber -> String
output bigNumberInput =
   concat (map (\x -> show x) bigNumberInput)


--somaBN :: BigNumber -> BigNumber -> BigNumber
--somaBN first second =

--  if ((length second <= 1) && (length first <= 1))
--    then digitSum
--  else if ((length second == 0) && (length first >= 1))
--    then digitSum ++ somaBN (tail first) [0]
--  else if ((length first == 0) && (length second >= 1))
--    then digitSum ++ somaBN [0] (tail second)
--  else digitSum ++ somaBN (tail first) (tail second)
--  where
--    firstDigit = if (length first /= 0) then head first else 0
--    secondDigit = if (length second /= 0) then head second else 0
--    digitSum = [firstDigit + secondDigit]

removeZerosBN :: BigNumber -> BigNumber
removeZerosBN (0:[]) = [0]
removeZerosBN (0:xs) = xs
removeZerosBN xs = xs

changeSignBN :: BigNumber -> BigNumber
changeSignBN (x:xs) = (-x):xs

changeSignFormatBN :: BigNumber -> BigNumber
changeSignFormatBN xs = changeSignBN (removeZerosBN xs)

isNegBN :: BigNumber -> Bool
isNegBN (x:xs)
  = if (x < 0)
    then True
    else False

isBiggerBN :: BigNumber -> BigNumber -> Bool
isBiggerBN (x:xs) (y:ys)
  = if (length (x:xs) < length (y:ys))
      then False
    else if (length (x:xs) > length(y:ys))
      then True
    else if (x > y)
      then True
    else if (x < y)
      then False
    else isBiggerBN xs ys

somaBN :: BigNumber -> BigNumber -> BigNumber
somaBN a b
  = if (isNegBN a && isNegBN b)
      then changeSignFormatBN (reverse (somaBN_aux (reverse (changeSignBN a)) (reverse (changeSignBN b)) 0))
    else if (not (isNegBN a) && isNegBN b)
      then subBN a (changeSignBN b)
    else if (isNegBN a && not (isNegBN b))
      then subBN b (changeSignBN a)
    else removeZerosBN (reverse (somaBN_aux (reverse a) (reverse b) 0))
  where somaBN_aux [] [] 0 = []
        somaBN_aux [] [] c = [c]
        somaBN_aux [] (y:ys) c = (y + c):ys
        somaBN_aux (x:xs) [] c = (x + c):xs
        somaBN_aux (x:xs) (y:ys) c
          = if (aux < 10)
            then aux:somaBN_aux (xs) (ys) 0
            else (aux - 10):somaBN_aux (xs) (ys) 1
            where aux = x + y + c

subBN :: BigNumber -> BigNumber -> BigNumber
subBN a b
  = if (isBiggerBN a b)
      then removeZerosBN (reverse (subBN_aux (reverse a) (reverse b) 0))
    else changeSignFormatBN (reverse (subBN_aux (reverse b) (reverse a) 0))
  where subBN_aux [] [] _ = []
        subBN_aux (x:[]) (y:[]) c = [x - y - c]
        subBN_aux (x:xs) ([]) c = [x - c]
        subBN_aux (x:xs) (y:ys) c
          = if (aux >= 0)
            then aux:subBN_aux (xs) (ys) 0
            else (10 + aux):subBN_aux (xs) (ys) 1
            where aux = x - y

--subBN :: BigNumber -> BigNumber -> BigNumber
--subBN first second =

--  if ((length second <= 1) && (length first <= 1))
--    then [firstDigit - secondDigit]
--  else if ((length second == 0) && (length first >= 1))
--    then [firstDigit - secondDigit] ++ subBN (tail first) [0]
--  else if ((length first == 0) && (length second >= 1))
--    then [firstDigit - secondDigit] ++ subBN [0] (tail second)
--  else [firstDigit - secondDigit] ++ subBN (tail first) (tail second)
--  where
--    firstDigit = if (length first /= 0) then head first else 0
--    secondDigit = if (length second /= 0) then head second else 0


mulBN :: BigNumber -> BigNumber -> BigNumber
mulBN first second =
  if (length first == 1)
    then currentSum
  else somaBN currentSum (mulBN (tail first) ([0] ++ second))
  where currentSum = map (* head first) second


-- divBN :: BigNumber -> BigNumber -> (BigNumber, BigNumber)
--
--
-- safeDivBN :: BigNumber -> BigNumber -> Maybe (BigNumber, BigNumber)
