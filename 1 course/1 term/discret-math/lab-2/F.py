n = int(input())
arr = []
arr.append(list(map(int, input().split())))
dict = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
res = []
arr2 = []

while len(arr[0]) > 0:
    tc = dict[arr[0][0]]
    pos = 1
    while tc in dict:
        if pos > len(arr[0]) - 1:
            break
        if len(dict) > arr[0][pos]:
            tc += dict[arr[0][pos]][:1]
        else:
            tc += dict[arr[0][pos - 1]][:1]
        pos += 1
    if not (tc in dict):
        dict.append(tc)

    res.append(dict[arr[0][0]])
    arr[0].pop(0)

    tc = ""

print(''.join(res))
