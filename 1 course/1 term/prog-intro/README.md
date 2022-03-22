# java-prog-intro-2021

[Условия домашних заданий](https://www.kgeorgiy.info/courses/prog-intro/homeworks.html)


## Домашнее задание 13. Обработка ошибок

Модификации
 * *Base*
    * Класс `ExpressionParser` должен реализовывать интерфейс
        [Parser](java/expression/exceptions/Parser.java)
    * Классы `CheckedAdd`, `CheckedSubtract`, `CheckedMultiply`,
        `CheckedDivide` и `CheckedNegate` должны реализовывать интерфейс
        [TripleExpression](java/expression/TripleExpression.java)
    * Нельзя использовать типы `long` и `double`
    * Нельзя использовать методы классов `Math` и `StrictMath`
    * [Исходный код тестов](java/expression/exceptions/ExceptionsTest.java)
        * Первый аргумент: `easy` или `hard`
        * Последующие аргументы: модификации
 * *PowLog* (36-39)
    * Дополнительно реализуйте бинарные операции (максимальный приоритет):
        * `**` – возведение в степень, `2 ** 3` равно 8;
        * `//` – логарифм, `10 // 2` равно 3.
 * *MinMax* (31-37)
    * Дополнительно реализуйте бинарные операции (минимальный приоритет):
        * `min` – минимум, `2 min 3` равно 2;
        * `max` – максимум, `2 max 3` равно 3.
 * *Abs* (36-39)
    * Дополнительно реализуйте унарную операцию
        * `abs` – модуль числа, `abs -5` равно 5.


## Домашнее задание 12. Разбор выражений

Модификации
 * *Base*
    * Класс `expression.parser.ExpressionParser` должен реализовывать интерфейс
        [Parser](java/expression/parser/Parser.java)
    * Результат разбора должен реализовывать интерфейс
        [TripleExpression](java/expression/TripleExpression.java)
    * [Исходный код тестов](java/expression/parser/ParserTest.java)
        * Первый аргумент: `easy` или `hard`
        * Последующие аргументы: модификации
 * *MinMax* (34-37)
    * Дополнительно реализуйте бинарные операции (минимальный приоритет):
        * `min` – минимум, `2 min 3` равно 2;
        * `max` – максимум, `2 max 3` равно 3.
 * *Zeroes* (31-33, 36-39)
    * Дополнительно реализуйте унарные операции
      * `l0` – число старших нулевых бит, `l0 123456` равно 15;
      * `t0` – число младших нулевых бит, `t0 123456` равно 6.


## Домашнее задание 11. Выражения

Модификации
 * *Base*
    * Реализуйте интерфейс [Expression](java/expression/Expression.java)
    * [Исходный код тестов](java/expression/ExpressionTest.java)
        * Первый аргумент: `easy` или `hard`
        * Последующие аргументы: модификации
 * *Triple* (31-39)
    * Дополнительно реализуйте поддержку выражений с тремя переменными: `x`, `y` и `z`.
    * Интерфейс [TripleExpression](java/expression/TripleExpression.java).
 * *BigInteger* (36-37)
    * Дополнительно реализуйте вычисления в типе `BigInteger`.
    * Интерфейс [BigIntegerExpression](java/expression/BigIntegerExpression.java).


## Домашнее задание 10. Игра m,n,k

Тесты не предусмотрены. Решение должно находиться в пакете `game`.

Модификации
 * *Турнир* (36-37)
    * Добавьте поддержку кругового турнира для нескольких участников.
    * В рамках кругового турнира каждый с каждым должен сыграть две партии,
      по одной каждым цветом.
    * Выведите таблицу очков по схеме:
        * 3 очка за победу;
        * 1 очко за ничью;
        * 0 очков за поражение.


## Домашнее задание 9. Markdown to HTML

Модификации
 * *Базовая*
    * [Исходный код тестов](java/md2html/Md2HtmlTester.java)
    * [Откомпилированные тесты](artifacts/Md2HtmlTest.jar)
        * Аргументы командной строки: модификации
 * Var (31-33)
   * Добавьте поддержку %переменных%: <var>переменных</var> 

## Домашнее задание 7. Разметка

Модификации
 * *Base*
    * Исходный код тестов:
        * [MarkupTester.java](java/markup/MarkupTester.java)
        * [MarkupTest.java](java/markup/MarkupTest.java)
        * Аргументы командной строки: модификации
 * *BBCode* (31-33)
    * Дополнительно реализуйте метод toBBCode, генерирующий BBCode-разметку:
        * выделеный текст окружается тегом i;
        * сильно выделеный текст окружается тегом b;
        * зачеркнутый текст окружается тегом s.


## Домашнее задание 6. Подсчет слов++

Модификации
 * *Base*
    * Класс должен иметь имя `Wspp`
    * Исходный код тестов: 
        [WsppTest.java](java/wspp/WsppTest.java), 
        [WsppTester.java](java/wspp/WsppTester.java)
    * Откомпилированные тесты: [WsppTest.jar](artifacts/WsppTest.jar)
        * Аргументы командной строки: модификации
 * Position (31-33)
   * Вместо номеров вхождений во всем файле надо указывать <номер строки>:<номер в строке>
   * Класс должен иметь имя WsppPosition


## Домашнее задание 5. Свой сканнер

Модификации
 * *Base*
    * Исходный код тестов: [FastReverseTest.java](java/reverse/FastReverseTest.java)
    * Откомпилированные тесты: [FastReverseTest.jar](artifacts/FastReverseTest.jar)
        * Аргументы командной строки: модификации
 * Abc2 (31-33)
   * Во вводе и выводе используются числа, записаные буквами: нулю соответствует буква a, единице – b и так далее
   * Класс должен иметь имя ReverseAbc2


## Домашнее задание 4. Подсчет слов

Модификации
 * *Base*
    * Класс должен иметь имя `WordStatInput`
    * Исходный код тестов:
        [WordStatTest.java](java/wordStat/WordStatTest.java),
        [WordStatTester.java](java/wordStat/WordStatTester.java),
        [WordStatChecker.java](java/wordStat/WordStatChecker.java)
    * Откомпилированные тесты: [WordStatTest.jar](artifacts/WordStatTest.jar)
        * Аргументы командной строки: модификации
 * *Words* (31, 32, 33, 36, 37)
    * В выходном файле слова должны быть упорядочены в лексикографическом порядке
    * Класс должен иметь имя `WordStatWords`


## Домашнее задание 3. Реверс

Модификации
 * *Base*
    * Исходный код тестов:
        [ReverseTest.java](java/reverse/ReverseTest.java),
        [ReverseTester.java](java/reverse/ReverseTester.java)
    * Откомпилированные тесты: [ReverseTest.jar](artifacts/ReverseTest.jar)
        * Аргументы командной строки: модификации
 * Odd2 (31-33)
   * Выведите (в реверсивном порядке) только числа, у которых сумма номеров строки и столбца нечетная
   * Класс должен иметь имя ReverseOdd2


## Домашнее задание 2. Сумма чисел

Модификации
 * Long (31-33)
   * Входные данные являются 64-битными целыми числами
   * Класс должен иметь имя SumLong