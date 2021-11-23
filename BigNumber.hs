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

-- Aux Functions

{- Removes all unecessary 0s at the start of a BigNumber -}
removeZerosBN :: BigNumber -> BigNumber
removeZerosBN (0:[]) = [0]
removeZerosBN (0:xs) = xs
removeZerosBN xs = xs

{- Changes the sign of a BigNumber
  If it's positive add a minus (-) to the first digit of the BigNumber
  If it's negative remove the minus (-) frin the first digit of the BigNumber
-}
changeSignBN :: BigNumber -> BigNumber
changeSignBN (x:xs) = (-x):xs

{- Same as changeSignBN but also removes all unecessary 0s at the start of a BigNumber -}
changeSignFormatBN :: BigNumber -> BigNumber
changeSignFormatBN xs = changeSignBN (removeZerosBN xs)

{- Same as changeSignBN but for a pair of BigNumbers in the format (BigNumber, BigNumber) -}
changeSignFormatPair :: (BigNumber, BigNumber) -> (BigNumber, BigNumber)
changeSignFormatPair (xs, ys) = (changeSignFormatBN xs, changeSignFormatBN ys)

{- Checks if a BigNumber is negative
  If it is negative returns True
  If it is not negative returns False
-}
isNegBN :: BigNumber -> Bool
isNegBN (x:xs)
  = if (x < 0)
    then True
    else False

{- Checks if a positive BigNumber is bigger than other positive BigNumber
  If it is bigger returns True
  If it is not bigger returns False
-}
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

{- Check if a negative BigNumber is bigger than other negative BigNumber
  If it is bigger returns True
  If it is not bigger returns False
-}
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

{- Checks if a BigNumber is bigger than other BigNumber
  If it is bigger returns True
  If it is not bigger returns False
-}
isBiggerBN :: BigNumber -> BigNumber -> Bool
isBiggerBN (x:xs) (y:ys)
  = if ((isNegBN (x:xs)) && not (isNegBN (y:ys)))
      then False
    else if ((not (isNegBN (x:xs))) && isNegBN (y:ys))
      then True
    else if ((isNegBN (x:xs)) && isNegBN (y:ys))
      then isBiggerNegBN (-x:xs) (-y:ys)
    else isBiggerPosBN (x:xs) (y:ys)

{- Adds zeros at the end of a BigNumber
  It's equal to multiplying the BigNumber by 10^n where 'n' is the second argument of the function
-}
addZeros :: BigNumber -> Int -> BigNumber
addZeros xs n = xs ++ (map (*0) [1..n])

{- Fixes the carry of a BigNumber
  Used in the mulBN function
  Ex: [2,3,12] will become [2,4,2]
-}
fixCarry :: BigNumber -> BigNumber
fixCarry xs = removeZerosBN (reverse (fixCarry_aux (reverse xs) 0))
  where fixCarry_aux [] c = [c]
        fixCarry_aux (x:xs) c = mod (x+c) 10:fixCarry_aux (xs) (div (x+c) 10)

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
