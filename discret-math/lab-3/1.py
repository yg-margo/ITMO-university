def v(kod):
    if (n == len(kod)):
        print(kod)
        return
    v(kod + '0')
    v(kod + '1')
n = int(input());
v('')
