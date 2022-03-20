def v(kod):
    if (len(kod) == 2 * n):
        print(kod)
        return
    if (kod.count('(') < n):
        v(kod + '(')
    if (kod.count('(') > kod.count(')')):
        v(kod + ')')
n = int(input())
v('')
