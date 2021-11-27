# PFL - Trabalho Prático 1

#### Trabalho feito por:
- João Rocha (up201806261)
- Lara Medicis (up201806762)

## Casos de Teste

### Fib.hs

Para testar todas as funções do Fib.hs, utilizamos sempre o mesmo valor de teste, 10 ([1,0] no caso de ser em Big-Number).

Os testes foram os seguintes:

```
testFibRec :: Int
testFibRec = fibRec 10

testFibLista :: Int
testFibLista = fibLista 10

testFibListaInfinita :: Int
testFibListaInfinita = fibListaInfinita 10

testFibRecBN :: BigNumber
testFibRecBN = fibRecBN [1,0]

testFibListaBN :: BigNumber
testFibListaBN = fibListaBN [1,0]

testFibListaInfinitaBN :: BigNumber
testFibListaInfinitaBN = fibListaInfinitaBN [1,0]
```

Para os quais obtivemos os seguintes resultados:

![](https://i.imgur.com/t8qjJrM.png)


### BigNumber.hs

Para a função **scanner**, os casos de teste foram:

```
testScannerPos :: BigNumber
testScannerPos = scanner "12345"

testScannerNeg :: BigNumber
testScannerNeg = scanner "-12345"
```
para o qual obtivemos o seguinte output:

![](https://i.imgur.com/vx5x3Ms.png)


Para a função **output**, os casos de teste foram:
```
testOutputPos :: String
testOutputPos = output [1,2,3,4,5]

testOutputNeg :: String
testOutputNeg = output [-1,2,3,4,5]
```
para o qual obtivemos o seguinte output:

![](https://i.imgur.com/Oa2xcIi.png)


Para a função **somaBN**, os casos de teste foram:

```
testSomaBNPosPos :: BigNumber
testSomaBNPosPos = somaBN [1,2,3] [4,5,6]


testSomaBNPosNeg :: BigNumber
testSomaBNPosNeg = somaBN [1,2,3] [-4,5,6]


testSomaBNNegPos :: BigNumber
testSomaBNNegPos = somaBN [-1,2,3] [4,5,6]


testSomaBNNegNeg :: BigNumber
testSomaBNNegNeg = somaBN [-1,2,3] [-4,5,6]
```
para o qual obtivemos o seguinte output:

![](https://i.imgur.com/Wpnx0fr.png)


Para a função **subBN**, os casos de teste foram:

```
testSubBNPosPos :: BigNumber
testSubBNPosPos = subBN [1,2,3] [4,5,6]


testSubBNPosNeg :: BigNumber
testSubBNPosNeg = subBN [1,2,3] [-4,5,6]


testSubBNNegPos :: BigNumber
testSubBNNegPos = subBN [-1,2,3] [4,5,6]


testSubBNNegNeg :: BigNumber
testSubBNNegNeg = subBN [-1,2,3] [-4,5,6]
```
para o qual obtivemos o seguinte output:

![](https://i.imgur.com/f4BIpvj.png)


Para a função **mulBN**, os casos de teste foram:

```
testMulBNPosPos :: BigNumber
testMulBNPosPos = mulBN [1,2,3] [4,5,6]


testMulBNPosNeg :: BigNumber
testMulBNPosNeg = mulBN [1,2,3] [-4,5,6]


testMulBNNegPos :: BigNumber
testMulBNNegPos = mulBN [-1,2,3] [4,5,6]


testMulBNNegNeg :: BigNumber
testMulBNNegNeg = mulBN [-1,2,3] [-4,5,6]
```
para o qual obtivemos o seguinte output:

![](https://i.imgur.com/FgTJCYm.png)


Para a função **divBN**, os casos de teste foram:

```
testDivBNPosPos :: (BigNumber, BigNumber)
testDivBNPosPos = divBN [4,5,6] [3]


testDivBNPosNeg :: (BigNumber, BigNumber)
testDivBNPosNeg = divBN [4,5,6] [-3]


testDivBNNegPos :: (BigNumber, BigNumber)
testDivBNNegPos = divBN [-4,5,6] [3]


testDivBNNegNeg :: (BigNumber, BigNumber)
testDivBNNegNeg = divBN [-4,5,6] [-3]
```
para o qual obtivemos o seguinte output:

![](https://i.imgur.com/TehMenp.png)


Para a função **safeDivBN**, os casos de teste foram:

```
testSafeDivBNPosPos :: Maybe (BigNumber, BigNumber)
testSafeDivBNPosPos = safeDivBN [4,5,6] [3]


testSafeDivBNPosNeg :: Maybe (BigNumber, BigNumber)
testSafeDivBNPosNeg = safeDivBN [4,5,6] [-3]


testSafeDivBNNegPos :: Maybe (BigNumber, BigNumber)
testSafeDivBNNegPos = safeDivBN [-4,5,6] [3]


testSafeDivBNNegNeg :: Maybe (BigNumber, BigNumber)
testSafeDivBNNegNeg = safeDivBN [-4,5,6] [-3]


testSafeDivBNPosZero :: Maybe (BigNumber, BigNumber)
testSafeDivBNPosZero = safeDivBN [4,5,6] [0]


testSafeDivBNNegZero :: Maybe (BigNumber, BigNumber)
testSafeDivBNNegZero = safeDivBN [-4,5,6] [0]
```
para o qual obtivemos o seguinte output:

![](https://i.imgur.com/g0X8iR5.png)


## Funcionamento de Funções

### Fib.hs

#### Funções Principais

**fibRec -** Uma função que recebe um número (n) e calcula o n-ésimo número de fibonacci por recursão.
Exemplo:
Input - 10
Output - 55

**fibLista -** Uma função que recebe um número (n) e calcula o n-ésimo número de fibonacci usando uma lista que guarda os números anteriores (programação dinâmica).
Input - 10
Output - 55

**fibListaInfinita -** Uma função que recebe um número (n) e retorna o n-ésimo número presente na lista infinita gerada pela função **fibs**.
Input - 10
Output - 55

**fibRecBN -** Uma função que recebe um BigNumber (n) e calcula o n-ésimo número de fibonacci por recursão mas usando BigNumbers.
Input - [1,0]
Output - [5,5]

**fibListaBN -** Uma função que recebe um BigNumber (n) e calcula o n-ésimo número de fibonacci usando uma lista que guarda os números anteriores (programação dinâmica) mas usando BigNumbers.
Input - [1,0]
Output - [5,5]

**fibListaInfinitaBN -** Uma função que recebe um BigNumber (n) e retorna o n-ésimo BigNumber presente na lista infinita gerada pela função **fibsBN**.
Input - [1,0]
Output - [5,5]

#### Funções Auxiliares

**fibs -** Uma função que gera uma lista infinita com os números de fibonacci.

**fibsBN -** Uma função que gera uma lista infinita com os números de fibonacci representados por BigNumbers.

**getNthBN -** Uma função que retorna o n-ésimo BigNumber da lista de BigNumbers recebida.


### BigNumber.hs

#### Funções Principais

**scanner -** Uma função que recebe uma string, e transforma-a num Big-Number.
Exemplo:
*Input* - "123"
*Output* - [1,2,3]

**output:** Uma função que recebe um Big-Number, e transforma-o numa string.
Exemplo:
*Input* - [1,2,3]
*Output* - "123"

**somaBN:** Uma função que recebe dois Big-Numbers e calcula a sua soma.
Exemplo:
*Input* - [1,2,3] [1,2,3]
*Output* - [2,4,6]

**subBN:** Uma função que recebe dois Big-Numbers e calcula a subtração de um do outro.
Exemplo:
*Input* - [1,2,3] [4,5,6]
*Output* - [-3,3,3]

**mulBN:** Uma função que recebe dois Big-Numbers e calcula a sua multiplicação.
Exemplo:
*Input* - [1,2,3] [4,5,6]
*Output* - [5,6,0,8,8]

**divBN:** Uma função que recebe dois Big-Numbers e calucla a sua divisão, mostrando o resultado como um tuplo de duas listas. A primeira sendo o quociente e a segunda o resto.
Exemplo:
*Input* - [4,5,6] [3]
*Output* - ([1,5,2][0])

**safeDivBN:** Uma função que faz o mesmo que ***divBN*** mas como funcionalidade extra, deteta divisões por 0.

#### Funções Auxiliares

**removeZerosBN -** Uma função que recebe um Big-Number e remove todos os zeros no início do Big-Number.
Exemplo:
*input* - [0,0,0,2,3]
*Output* - [2,3]

**changeSignBN -** Uma função que recebe um Big-Number e inverte o seu sinal.
Exemplo:
*Input* - [-1,2,3]
*Output* - [1,2,3]

**changeSignFormatBN -** Uma função que recebe um Big-Number e remove todos os zeros no início do Big-Number ***e*** inverte o seu sinal.
Exemplo:
*Input* - [0,0,0,4,5]
*Output* - [-4,5]

**changeSignFormatPair -** Uma função que recebe um par de Big-Numbers e inverte o sinal de cada um.
Exemplo:
*Input* - ([1,2,3], [-4,5])
*Output* - ([-1,2,3], [4,5])

**isNegBN -** Uma função que recebe um Big-Number e verifica o seu sinal. Retorna True se for negativo e False se for positivo.
Exemplo:
*Input* - [-1,2,3]
*Output* - True

**isBiggerPosBN -** Uma função que recebe dois Big-Numbers positivos e verifica se um é maior que o outro.
Exemplo:
*Input* - [1,0] [9,8]
*Output* - False


**isBiggerNegBN -** Uma função que recebe dois Big-Numbers negativos e verifica se um é maior que o outro. Nota: Esta função não recebe o primeiro dígito de cada BigNumber nem o sinal negativo.
Exemplo:
*Input* - [1,0] [9,8]
*Output* - True

**isBiggerBN -** Uma função que recebe dois Big-Numbers e verifica se um é maior que o outro.
Exemplo:
*Input* - [1,0,0] [9,8]
*Output* - True

**addZeros -** Uma função que recebe um Big-Number e um Int e adiciona zeros multiplicando o Big-Number por 10<sup>n</sup>.
Exemplo:
*Input* - [1,2,3] 3
*Output* - [1,2,3,0,0,0]

**fixCarry -** Uma função que recebe um Big-Number e trata de qualquer número maior que 9.
Exemplo:
*Input* - [1,2,11]
*Output* - [1,3,1]

**fixCarryPair -** Uma função que faz o mesmo que ***fixCarry*** mas para um par de Big-Numbers.
Exemplo:
*Input* - ([1,2,11], [5,9,10])
*Output* - ([1,3,2], [6,0,0])

## Implementação da Alínea 2

Para as funções do BigNumber.hs utilizamos algumas estratégias e funções auxiliares para facilitar os cálculos e simplificar o código.

Para facilitar a implentação das funções, aproveitamos as seguintes equivalências:
- n1 + n2 = -((-n1) + (-n2))
- p + n = p - (-n)
- n + p = p - (-n)
- n - p = n + (-p)
- n1 - n2 = (-n2) - (-n1)
- n1 * n2 = (-n1) * (-n2)
- p * n = -(p * (-n))
- n * p = -((-n) * p)
- n1 / n2 = (-n1) / (-n2)
- p / n = -(p / (-n))
- n / p = -((-n) / p)

Nota: **p** representa números positivos e **n**, **n1** e **n2** representam números negativos.

Uma das estratégias que utilizamos foi chamar a função ***somaBN*** na função ***subBN*** no caso de estarmos a subtrair um número negativo. De modo similar, chamamos a função ***subBN*** na função ***somaBN*** no caso de estarmos a tentar somar um número negativo. Para facilitar estas operações, criamos a função ***isNegBN*** para verificar se um número era negativo ou não, e as funções ***changeSignBN***, ***changeSignFormatBN*** e ***changeSignFormatPair*** para modificar os sinais de um BigNumber caso fosse necessário.

Criamos também as duas funções ***fixCarry*** e ***fixCarryPair***, para no final de uma operação, receberem o cálculo do Big-Number e fazerem o tratamento dos restos nos números maiores que 9, assim transformando como por exemplo [1,12,8] no Big-Number [2,2,8].


## Resposta a Alínea 4

Ao correr as seguintes funções com os seguintes inputs obtemos:
- fibRec
    - Input: 92 Output: 7540113804746346429
    - Input: 93 Output: -6246583658587674878
- fibLista
    - Input: 92 Output: 7540113804746346429
    - Input: 93 Output: -6246583658587674878
- fibListaInfinita
    - Input: 92 Output: 7540113804746346429
    - Input: 93 Output: -6246583658587674878
- fibRecBN
    - Input: [9,2] Output: [7,5,4,0,1,1,3,8,0,4,7,4,6,3,4,6,4,2,9]
    - Input: [9,3] Output: [1,2,2,0,0,1,6,0,4,1,5,1,2,1,8,7,6,7,3,8]
- fibListaBN
    - Input: [9,2] Output: [7,5,4,0,1,1,3,8,0,4,7,4,6,3,4,6,4,2,9]
    - Input: [9,3] Output: [1,2,2,0,0,1,6,0,4,1,5,1,2,1,8,7,6,7,3,8]
- fibListaInfinitaBN
    - Input: [9,2] Output: [7,5,4,0,1,1,3,8,0,4,7,4,6,3,4,6,4,2,9]
    - Input: [9,3] Output: [1,2,2,0,0,1,6,0,4,1,5,1,2,1,8,7,6,7,3,8]

Como podemos analisar, as funções relacionadas com os números de fibonacci que usam o tipo Int, retornam um número negativo com o argumento "93". Isto significa que está a haver overflow e que nenhum número de Fibonacci a partir do elemento 93 vão estar mal calculados.

Ao usar tipos BigNumber, já não corremos este problema. Como estamos a usar listas para representar números, não haverá overflows e os números de Fibonacci serão calculados corretamente.
