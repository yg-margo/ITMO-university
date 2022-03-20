def v(n, k):
    kod = 0
    res = ''
    arr = []
    for i in range(n * 2 - 1, -1, -1):
        if kod + 1 <= n:
            cnt = int(array[i][kod + 1] *
                      2 ** ((i - (kod + 1)) / 2))
        else:
            cnt = 0
        if cnt >= k:
            res += '('
            arr.append('(')
            kod += 1
            continue
        k = k - cnt
        if len(arr) > 0 and arr[-1] ==\
                '(' and kod - 1 >= 0:
            cnt = int(array[i][kod - 1] * 2 **
                      ((i - kod + 1) / 2))
        else:
            cnt = 0
        if cnt >= k:
            res += ')'
            arr.pop()
            kod -= 1
            continue
        k -= cnt
        if kod + 1 <= n:
            cnt = int(array[i][kod + 1] * 2 **
                      ((i - (kod + 1)) / 2))
        else:
            cnt = 0
        if cnt >= k:
            res += '['
            arr.append('[')
            kod += 1
            continue
        k -= cnt
        res += ']'
        arr.pop()
        kod -= 1
    return res


n, k = map(int, input().split())
array = [[0 for i in range(n + 1)]
         for i in range(2 * n + 1)]
array[0][0] = 1
for i in range(2 * n):
    for j in range(n + 1):
        if j + 1 <= n:
            array[i + 1][j + 1] +=\
                array[i][j]
        if j > 0:
            array[i + 1][j - 1] +=\
                array[i][j]
print(v(n, k + 1))
