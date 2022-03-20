def v(arr):
    i = n - 2
    while (i >= 0) and\
            (arr[i] >= arr[i + 1]):
        i -= 1
    if i >= 0:
        j = i + 2
        while (j < n) and\
                (arr[j] > arr[i]):
            j += 1
        arr[i], arr[j - 1] = \
            arr[j - 1], arr[i]
        return [*arr[:i + 1],
                *reversed(arr[i + 1:n])]
    else:
        return [0] * n


n = int(input())
arr = list(map(int, input().split()))
print(' '.join(map(str, v(arr))))
