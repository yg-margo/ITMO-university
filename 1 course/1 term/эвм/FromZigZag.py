a = int(input())
if a == 0:
    print (0)
if a == 1:
    print (-1)
elif a > 1 and (a % 2) != 0:
    print(((a) // 2 + 1)*(-1)) 
elif a > 1 and (a % 2) == 0:
    print(a // 2)
