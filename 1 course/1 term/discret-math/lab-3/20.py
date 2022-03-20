def count(l, kod):
    if n >= kod >= 0:
        return int(arr[2 * n -
                       l - 1][kod] * 2 **
                   ((2 * n - l - kod) // 2))
    else:
        return 0


def v(line):
    find = 0
    cnr = 0
    array = []
    for i in range(2 * n):
        if line[i] == '(':
            array.append('(')
            cnr += 1
        elif line[i] == ')':
            find += count(i, cnr + 1)
            array.pop()
            cnr -= 1
        elif line[i] == '[':
            find += count(i, cnr + 1)
            if len(array) > 0 and\
                    array[-1] == '(':
                find += count(i, cnr - 1)
            array.append('[')
            cnr += 1
        elif line[i] == ']':
            find += count(i, cnr + 1)
            if len(array) > 0 and\
                    array[-1] == '(':
                find += count(i, cnr - 1)
            find += count(i, cnr + 1)
            array.pop()
            cnr -= 1
    return str(find)


line = input().split()[0]
n = int(len(line) / 2)
arr = [[0 for i in range(n + 2)]
       for i in range(2 * n + 1)]
arr[0][0] = 1
for m in range(2 * n):
    for j in range(n + 2):
        if j + 1 <= n:
            arr[m + 1][j + 1] +=\
                arr[m][j]
        if j > 0:
            arr[m + 1][j - 1] +=\
                arr[m][j]
print(v(line))
