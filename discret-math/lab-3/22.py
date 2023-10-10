def v(kod):
    ans = 0
    gg = 1
    line = 0
    for i in range(len(kod)):
        for j in range(gg,
                       kod[i]):
            ans += array[n - line - j][j]
        gg = kod[i]
        line += kod[i]
    return ans


arr = list(map(int,
               input().split('+')))
n = sum(arr)
array = [[0 for i in range(n + 1)]
         for i in range(n + 1)]
for i in range(n + 1):
    for j in range(i, -1, -1):
        if i == j:
            array[i][j] = 1
        elif i < j:
            array[i][j] = 0
        else:
            array[i][j] =\
                array[i][j + 1] +\
                array[i - j][j]
print(str(v(arr)))
