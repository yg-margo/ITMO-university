def v(n):
    if (n == 0):
        return ['0', '1']
    new = v(n - 1)
    for i in reversed(new):
        new.append(i)
    for i in range(len(new)):
        if (i < len(new)/2):
            new[i] = '0' + new[i]
        else:
            new[i] = '1' + new[i]
    return new

n = int(input())
for i in v(n - 1):
    print(i)
