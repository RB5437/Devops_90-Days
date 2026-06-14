# real world

Choice  =   input("enter the choice(press q to quit):") 

while Choice != "q":
    num = int(input("enter the number you want the table for"))

    for i in range(1,11):
        print(f"{num} * {i} = {num*i}")
    Choice  =   input("enter the choice(press q to quit):")