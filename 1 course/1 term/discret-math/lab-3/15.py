import math


def v(m, kod):
    if m == 0 and len(kod) == k:
        return kod
    for i in range(1, n + 1):
        if (len(kod) == 0
                or int(kod[-1]) < i):
            gg = math.factorial(n - i) / (math.factorial(k -
                                                        len(kod) - 1) * math.factorial((n - i) -
                                                                                       (k - len(kod) - 1)))
            if m >= gg:
                m -= gg
            else:
                return v(m, [*kod,
                             str(i)])


n, k, m = map(int, input().split())
print(' '.join(v(m, [])))
