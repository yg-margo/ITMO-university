def v(arr):
    arr = [i for i in arr]
    n = len(arr) - 1
    while (n >= 0) and\
            (arr[n] != '1'):
        arr[n] = '1'
        n -= 1
    if n == -1:
        return '-'
    arr[n] = '0'
    return ''.join(arr)


def kod(arr):
    arr = [i for i in arr]
    n = len(arr) - 1
    while (n >= 0) and\
            (arr[n] != '0'):
        arr[n] = '0'
        n -= 1
    if n == -1:
        return '-'
    arr[n] = '1'
    return ''.join(arr)


s = str(input().split()[0])
print(v(s) + '\n' + kod(s))
