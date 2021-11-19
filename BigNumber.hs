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
	
changeSignBN :: BigNumber -> BigNumber
changeSignBN (x:xs) = (-x):xs

isNegBN :: BigNumber -> Bool
isNegBN (x:xs)
  = if (x < 0)
    then True
    else False

somaBN :: BigNumber -> BigNumber -> BigNumber
somaBN a b 
  = if (isNegBN a && isNegBN b)
    then changeSignBN (reverse (somaBN_aux (reverse (changeSignBN a)) (reverse (changeSignBN b)) 0))
    else reverse (somaBN_aux (reverse a) (reverse b) 0)
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
  = reverse (subBN_aux (reverse a) (reverse b) 0)
  where subBN_aux [] [] _ = []
        subBN_aux [] (y:ys) c = y:ys
        subBN_aux (x:xs) [] c = (x - c):xs
        subBN_aux (x:xs) (y:ys) c
          = if (x >= y)
            then aux:subBN_aux (xs) (ys) 0
            else (x + y + 1):subBN_aux (xs) (ys) 1
            where aux = x - y

subBN :: BigNumber -> BigNumber -> BigNumber
subBN first second =

  if ((length second <= 1) && (length first <= 1))
    then [firstDigit - secondDigit]
  else if ((length second == 0) && (length first >= 1))
    then [firstDigit - secondDigit] ++ subBN (tail first) [0]
  else if ((length first == 0) && (length second >= 1))
    then [firstDigit - secondDigit] ++ subBN [0] (tail second)
  else [firstDigit - secondDigit] ++ subBN (tail first) (tail second)
  where
    firstDigit = if (length first /= 0) then head first else 0
    secondDigit = if (length second /= 0) then head second else 0


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
