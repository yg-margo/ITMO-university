def v(kod):
    if (k == len(kod)):
        print(' '.join(kod))
        return
    if (len(kod) != 0):
        for i in range(int(kod[-1]) + 1, n + 1):
            if (str(i) not in kod):
                gg = kod.copy()
                gg.append(str(i))
                v(gg)
    else:
        for i in range(1, n + 1):
            gg = kod.copy()
            gg.append(str(i))
            v(gg)
n, k = map(int, input().split())
v([])
