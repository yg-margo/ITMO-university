def v(gg, line, kod):
    global n
    global k
    while line != n:
        for j in range(gg, n + 1):
            if k >=\
                    array[n - line - j][j] and\
                    line + (j + 1) <= n:
                k -= array[n - line - j][j]
            else:
                kod.append(j)
                line += j
                gg = j
                break
    return kod


n, k = map(int, input().split())
array = [[0 for i in range(n + 1)]
         for i in range(n + 1)]
for i in range(n + 1):
    for j in range(i, -1, -1):
        if i == j:
            array[i][j] = 1
        elif i < j:
            array[i][j] = 0
        else:
            array[i][j] = array[i][j + 1] +\
                          array[i - j][j]
print('+'.join(map(str, v(1, 0, []))))
