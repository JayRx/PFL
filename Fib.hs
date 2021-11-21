import BigNumber

-- Ex 1.1
fibRec :: (Integral a) => a -> a
fibRec 0 = 0
fibRec 1 = 1
fibRec a = fibRec (a - 1) + fibRec (a - 2)

-- Ex 1.2
fibLista :: Int -> Int
fibLista a
 | a == 0 = 0
 | a == 1 = 1
 | otherwise = (aux !! (a-1)) + (aux !! (a-2))
    where
      aux = map fibLista [0..]

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

--fibListaBN :: BigNumber -> BigNumber
--fibListaBN a
--  | a == [0] = [0]
--  | a == [1] = [1]
--  | otherwise = somaBN (aux !! (subBN a [1])) (aux !! (subBN a [2]))
--      where
--        aux = map fibListaBN []

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
  | otherwise = somaBN (getNthBN aux (subBN a [1])) (getNthBN aux (subBN a [2]))
    where
      aux = map fibListaBN [[x] | x<-[0..]]

fibListaInfinitaBN :: BigNumber -> BigNumber
fibListaInfinitaBN a = getNthBN fibsBN a
