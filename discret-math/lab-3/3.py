def v(kod):
    if (n == len(kod)):
        print(kod)
        print(rev(kod, 1))
        print(rev(kod, 2))
        return
    for i in range(3):
        v(kod + str(i))
def rev(a, b):
    res = ''
    for i in a:
        res += str((int(i) + b) % 3)
    return res
n = int(input())
v('0')
