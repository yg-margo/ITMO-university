def num(line):
    kod = 0
    cnt = 0
    for i in range(2 * n):
        if line[i] == '(':
            cnt += 1
        elif line[i] == ')':
            kod += arr[2 * n -
                       i - 1][cnt + 1]
            cnt -= 1
    return str(kod)


line = input().split()[0]
n = int(len(line) / 2)
arr = [[0 for i in range(n + 2)]
       for i in range(2 * n + 1)]
arr[0][0] = 1
for i in range(2 * n):
    for j in range(n + 2):
        if j + 1 <= n:
            arr[i + 1][j + 1] +=\
                arr[i][j]
        if j > 0:
            arr[i + 1][j - 1] +=\
                arr[i][j]

print(num(line))
