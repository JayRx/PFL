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


somaBN :: BigNumber -> BigNumber -> BigNumber
somaBN first second =

  if ((length second <= 1) && (length first <= 1))
    then digitSum
  else if ((length second == 0) && (length first >= 1))
    then digitSum ++ somaBN (tail first) [0]
  else if ((length first == 0) && (length second >= 1))
    then digitSum ++ somaBN [0] (tail second)
  else digitSum ++ somaBN (tail first) (tail second)
  where
    firstDigit = if (length first /= 0) then head first else 0
    secondDigit = if (length second /= 0) then head second else 0
    digitSum = [firstDigit + secondDigit]


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
