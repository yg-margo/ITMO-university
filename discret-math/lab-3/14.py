import math
def v(kod):
    m = 0
    for i in range(len(kod)):
        for j in range(1, kod[i]):
            if (j not in kod[:i]):
                m += math.factorial(n - (i + 1))
    return m
n = int(input())
kod = list(map(int, input().split()))
print(str(v(kod)))
