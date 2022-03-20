def v(line):
    one = 0
    two = 0
    for i in range(len(line) - 1,
                   -1, -1):
        if line[i] == '(':
            two += 1
            if one > two:
                break
        else:
            one += 1
    line = line[:len(line) - (two +
                              one)]
    if line == '':
        return "-"
    else:
        line = line + ')' + '(' * two +\
            ')' * (one - 1)
    return line


line = input().split()[0]
print(v(line))
