def v(array):
    array.append(n + 1)
    i = k - 1
    while (i >= 0) and\
            (array[i + 1] -
             array[i] < 2):
        i = i - 1
    if i >= 0:
        array[i] += 1
        for j in range(i + 1, k):
            array[j] = array[j - 1]\
                       + 1
        return array[:k]
    else:
        return [-1]


n, k = map(int, input().split())
array = list(map(int, input().split()))
print(' '.join(map(str, v(array))))
