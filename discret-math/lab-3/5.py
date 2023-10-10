def v(n):
    if (n == 1):
        return [str(i) for i in range(k)]
    else:
        res, arr = [], v(n - 1)
        for i in range(k):
            if (i % 2 == 0):
                res = [*res, *arr]
            else:
                res = [*res, *reversed(arr)]
        for i in range(k):
            for j in range(k ** (n - 1)):
                res[i * (k ** (n - 1)) + j] += str(i)
        return res

n, k = map(int, input().split())
print('\n'.join(v(n)))