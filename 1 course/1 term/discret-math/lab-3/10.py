def v(kod, m):
    if (m == 0):
        print('+'.join(kod))
    if (len(kod) != 0):
        for i in range(int(kod[-1]), n + 1):
            if (m >= i):
                gg = kod.copy()
                gg.append(str(i))
                v(gg, m - i)
    else:
        for i in range(1, n + 1):
            if (m >= i):
                gg = kod.copy()
                gg.append(str(i))
                v(gg, m - i)
n = int(input())
v([], n)
