def v(n, k):
    if k == 1:
        return '(' * n + ')' * n
    kod = 0
    gg = ''
    for i in range(2 * n):
        if m[2 * n - (i + 1)][kod + 1]\
                >= k:
            gg += '('
            kod += 1
        else:
            k -= m[2 * n -
                   (i + 1)][kod + 1]
            gg += ')'
            kod -= 1
    return gg


n, k = map(int, input().split())
m = [[0 for i in range(n + 1)]
     for i in range(2 * n + 1)]
m[0][0] = 1
for i in range(2 * n):
    for j in range(n + 1):
        if j + 1 <= n:
            m[i + 1][j + 1]\
                += m[i][j]
        if j > 0:
            m[i + 1][j - 1]\
                += m[i][j]

print(v(n, k + 1))
