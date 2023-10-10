def v(line):
    line[-1] -= 1
    line[-2] += 1
    if line[-2] > line[-1]:
        line[-2] += line[-1]
        line.pop()
    else:
        while line[-2] * 2 <= line[-1]:
            line.append(line[-1] - line[-2])
            line[-2] = line[-3]
    return line


line = input().split()[0]
n = line.split('=')[0]
line = list(map(int,
                line.split('=')[1].split('+')))
if len(line) != 1:
    print(n + '=' + '+'.join(map(str,
                                 v(line))))
else:
    print('No solution')
