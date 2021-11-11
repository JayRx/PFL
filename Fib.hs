fibRec :: (Integral a) => a -> a
fibRec 0 = 0
fibRec 1 = 1
fibRec a = fibRec (a - 1) + fibRec (a - 2)


fibLista :: (Integral a) => a -> a
fibLista a = a

fibListaInfinita :: (Integral a) => a -> a
fibListaInfinita a = a