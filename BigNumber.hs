module BigNumber (BigNumber (..),
                  scanner,
                  output,
                  somaBN,
                  subBN,
                  mulBN,
                  divBN,
                  safeDivBN,
                  isBiggerBN) where

-- Ex 2.1
type BigNumber = [Int]

-- Ex 2.2
scanner :: String -> BigNumber
scanner stringInput =
  map(\x -> read [x]::Int) stringInput

-- Ex 2.3
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

changeSignFormatPair :: (BigNumber, BigNumber) -> (BigNumber, BigNumber)
changeSignFormatPair (xs, ys) = (changeSignFormatBN xs, changeSignFormatBN ys)

isNegBN :: BigNumber -> Bool
isNegBN (x:xs)
  = if (x < 0)
    then True
    else False

isBiggerPosBN :: BigNumber -> BigNumber -> Bool
isBiggerPosBN (x:[]) (y:[]) = x > y
isBiggerPosBN (x:xs) (y:ys)
  = if (length (x:xs) < length (y:ys))
      then False
    else if (length (x:xs) > length(y:ys))
      then True
    else if (x /= y)
      then x > y
    else isBiggerPosBN xs ys

isBiggerNegBN :: BigNumber -> BigNumber -> Bool
isBiggerNegBN (x:[]) (y:[]) = x < y
isBiggerNegBN (x:xs) (y:ys)
  = if (length (x:xs) < length (y:ys))
      then True
    else if (length (x:xs) > length(y:ys))
      then False
    else if (x /= y)
      then x < y
    else isBiggerNegBN xs ys

isBiggerBN :: BigNumber -> BigNumber -> Bool
isBiggerBN (x:xs) (y:ys)
  = if ((isNegBN (x:xs)) && not (isNegBN (y:ys)))
      then False
    else if ((not (isNegBN (x:xs))) && isNegBN (y:ys))
      then True
    else if ((isNegBN (x:xs)) && isNegBN (y:ys))
      then isBiggerNegBN (-x:xs) (-y:ys)
    else isBiggerPosBN (x:xs) (y:ys)

-- Ex 2.4
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

-- Ex 2.5
subBN :: BigNumber -> BigNumber -> BigNumber
subBN a b
  = if (a == b)
      then [0]
    else if ((isNegBN a) && not (isNegBN b))
      then  somaBN a (changeSignFormatBN b)
    else if ((isNegBN a) && (isNegBN b))
      then subBN (changeSignFormatBN b) (changeSignFormatBN a)
    else if (isBiggerBN a b)
      then removeZerosBN (reverse (subBN_aux (reverse a) (reverse b) 0))
    else changeSignFormatBN (reverse (subBN_aux (reverse b) (reverse a) 0))
  where subBN_aux [] [] _ = []
        subBN_aux (x:[]) (y:[]) c
          = if (aux >= 0)
              then aux:subBN_aux [] [] 0
            else (10-y-c):subBN_aux [] [] 1
            where aux = x - y - c
        subBN_aux (x:xs) [] c
          = if (aux >= 0)
              then aux:subBN_aux xs [] 0
            else (10-c):subBN_aux xs [] 1
            where aux = x - c
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

addZeros :: BigNumber -> Int -> BigNumber
addZeros xs n = xs ++ (map (*0) [1..n])

fixCarry :: BigNumber -> BigNumber
fixCarry xs = removeZerosBN (reverse (fixCarry_aux (reverse xs) 0))
  where fixCarry_aux [] c = [c]
        fixCarry_aux (x:xs) c = mod (x+c) 10:fixCarry_aux (xs) (div (x+c) 10)

-- Ex 2.6
mulBN :: BigNumber -> BigNumber -> BigNumber
mulBN a b =
  if ((isNegBN a) && (isNegBN b))
    then mulBN_aux (changeSignFormatBN a) (changeSignFormatBN b)
  else if ((not (isNegBN a)) && (isNegBN b))
    then changeSignFormatBN(mulBN_aux a (changeSignFormatBN b))
  else if ((isNegBN a) && (not (isNegBN b)))
    then changeSignFormatBN(mulBN_aux (changeSignFormatBN a) b)
  else mulBN_aux a b
  where mulBN_aux xs (y:[]) = fixCarry (map (*y) xs)
        mulBN_aux xs (y:ys) = somaBN (addZeros (fixCarry (map (*y) xs)) (length ys)) (mulBN_aux xs ys)

-- mulBN :: BigNumber -> BigNumber -> BigNumber
-- mulBN first second =
--  if (length first == 1)
--    then currentSum
--  else somaBN currentSum (mulBN (tail first) ([0] ++ second))
--  where currentSum = map (* head first) second

-- Ex 2.7
divBN :: BigNumber -> BigNumber -> (BigNumber, BigNumber)
divBN a b =
  if ((isNegBN a) && (isNegBN b))
    then divBN_aux (changeSignFormatBN a) (changeSignFormatBN b) 0
  else if ((not (isNegBN a)) && (isNegBN b))
    then changeSignFormatPair (divBN_aux a (changeSignFormatBN b) 0)
  else if ((isNegBN a) && (not (isNegBN b)))
    then changeSignFormatPair (divBN_aux (changeSignFormatBN a) b 0)
  else divBN_aux a b 0
  where divBN_aux a b n =
          if ((isBiggerBN a b) || (a == b))
            then divBN_aux (subBN a b) b (n+1)
          else (fixCarry [n], fixCarry a)

-- Ex 5
safeDivBN :: BigNumber -> BigNumber -> Maybe (BigNumber, BigNumber)
safeDivBN a b =
  if (isBiggerBN b [])
    then Just (divBN a b)
  else Nothing
