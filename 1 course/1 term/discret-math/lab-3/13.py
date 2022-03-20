import math
def v(k, kod):
    if (k == 0 and len(kod) == n):
        return kod
    for i in range(1, n + 1):
        if (str(i) not in kod):
            m = math.factorial(n - (len(kod) + 1))
            if (k >= m):
                k = k - m
            else:
                return v(k, [*kod, str(i)])
n, k = map(int, input().split())
print(' '.join(v(k, [])))
