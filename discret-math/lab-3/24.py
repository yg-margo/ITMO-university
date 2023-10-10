def prev(arr):
    arr = arr.copy()
    for i in range(n - 2, -1, -1):
        if arr[i] > arr[i + 1]:
            k = i + 1
            for j in range(i + 1, n, 1):
                if (arr[j] > arr[k]) and\
                        (arr[j] < arr[i]):
                    k = j
            arr[i], arr[k] =\
                arr[k], arr[i]
            return [*arr[:i + 1],
                    *reversed(arr[i + 1:n])]
    return [0] * n


def next(arr):
    arr = arr.copy()
    for i in range(n - 2, -1, -1):
        if arr[i] < arr[i + 1]:
            k = i + 1
            for j in range(i + 1, n, 1):
                if (arr[j] < arr[k]) and\
                        (arr[j] > arr[i]):
                    k = j
            arr[i], arr[k] =\
                arr[k], arr[i]
            return [*arr[:i + 1],
                    *reversed(arr[i + 1:n])]
    return [0] * n


n = int(input())
arr = list(map(int, input().split()))
print(' '.join(map(str, prev(arr))) + '\n' +
      ' '.join(map(str, next(arr))))
