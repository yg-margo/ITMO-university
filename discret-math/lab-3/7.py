def v(kod):
    if (2*n == len(kod)):
        print(kod)
    for i in range(1, n + 1):
        if (str(i) not in kod):
            v(kod + str(i) + ' ')
n = int(input())
v('')
