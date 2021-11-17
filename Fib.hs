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
