def v(kod):
    if (n == len(kod)):
        arr.append(kod)
        return
    v(kod + '0')
    v(kod + '1')
n = int(input())
arr, res = [], []
v('')
for i in arr:
    if ('11' not in i):
        res.append(i)
print(str(len(res)))
for j in res:
    print(j)
    