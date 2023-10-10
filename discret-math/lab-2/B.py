strk = input()
let = list(strk)
list = []
for i in range(len(let)):
    word = strk[-1] + strk[:-1]
    new = ''.join(word)
    strk = new
    list.append(new)
    i += 1
sort = sorted(list)
for i in range(len(let)):
    element = sort[i]
    last = element[- 1]
    i = i + 1
    print(last, end="")
