import BigNumber

-- Ex 1.1
fibRec :: (Integral a) => a -> a
fibRec 0 = 0
fibRec 1 = 1
fibRec a = fibRec (a - 1) + fibRec (a - 2)

fibLista :: Int -> Int
fibLista a
  | a == 0 = 0
  | a == 1 = 1
  | otherwise = (xs !! (a - 1)) + (xs !! (a - 2))
    where xs = fibLista_aux a [0,1]

fibLista_aux :: Int -> [Int] -> [Int]
fibLista_aux a xs
  | a == length(xs) = xs
  | otherwise = fibLista_aux a (xs ++ [next])
    where next = (xs !! ((length xs) - 1)) + (xs !! ((length xs) - 2))

-- Ex 1.3
fibs :: [Int]
fibs = 0 : 1 : [a+b | (a,b)<-zip fibs (tail fibs)]

fibListaInfinita :: Int -> Int
fibListaInfinita a = last (take (a+1) fibs)

-- Ex 3
fibRecBN :: BigNumber -> BigNumber
fibRecBN [0] = [0]
fibRecBN [1] = [1]
fibRecBN a = somaBN (fibRecBN (subBN a [1])) (fibRecBN (subBN a [2]))

fibsBN :: [BigNumber]
fibsBN = [0] : [1] : [somaBN a b | (a,b)<-zip fibsBN (tail fibsBN)]

getNthBN :: [BigNumber] -> BigNumber -> BigNumber
getNthBN (x:xs) n =
  if (isBiggerBN n [0])
    then getNthBN (xs) (subBN n [1])
  else x

fibListaBN :: BigNumber -> BigNumber
fibListaBN a
  | a == [0] = [0]
  | a == [1] = [1]
  | otherwise = somaBN (getNthBN xs (subBN a [1])) (getNthBN xs (subBN a [2]))
    where xs = fibListaBN_aux a [[0],[1]]

fibListaBN_aux :: BigNumber -> [BigNumber] -> [BigNumber]
fibListaBN_aux a xs
  | a == fixCarry [length(xs)] = xs
  | otherwise = fibListaBN_aux a (xs ++ [next])
    where next = somaBN (getNthBN xs (subBN l [1])) (getNthBN xs (subBN l [2]))
          l = fixCarry [(length xs)]

fibListaInfinitaBN :: BigNumber -> BigNumber
fibListaInfinitaBN a = getNthBN fibsBN a
