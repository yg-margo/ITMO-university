def v(kod):
    print(' '.join(kod))
    if (len(kod) != 0):
        for i in range(int(kod[-1]) + 1, n + 1):
            gg = kod.copy()
            gg.append(str(i))
            v(gg)
    else:
        for i in range(1, n + 1):
            gg = kod.copy()
            gg.append(str(i))
            v(gg)
n = int(input())
v([])
