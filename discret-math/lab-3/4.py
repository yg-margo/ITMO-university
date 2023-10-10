def v(n):
    c, l = '0' * n, True
    res = {c : 0}
    while ('0' * n != c or l):
        if(l):
            l = False
        else:
            res[c] = 0
        kod = c[1:]
        if (kod + '1' not in res.keys()):
            c = kod + '1'
        else:
            c = kod + '0'
    return res
n = int(input())
print('\n'.join(v(n).keys()))
