num = int(input ("enter the number of tables you want to print: ")) # taking input from the user (keyboard)

#string formatting "f" is used to format the string and print the value of the variable num in the string
name = input("enter friend name")
print(f"Hello Friend Good Morning,{name} ")


for i in range(1,11): # for loop to print the tables from 10
 print(f" {num} * {i} = {num*i}") # printing the tables of the number entered by the user