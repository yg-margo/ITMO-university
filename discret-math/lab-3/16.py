import math


def v(arr):
    res = 0
    gg = 1
    for i in range(k):
        for j in range(gg, arr[i]):
            res += math.factorial(n -
                                  j) / (math.factorial(k -
                                                       (i + 1)) * math.factorial((n -
                                                                                  j) - (k - (i + 1))))
        gg = arr[i] + 1
    return int(res)


n, k = map(int, input().split())
arr = list(map(int, input().split()))
print(str(v(arr)))
