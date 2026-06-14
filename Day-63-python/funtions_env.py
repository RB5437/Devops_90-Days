# funtion = kaam
# indented block /indentation
def sum_of_num(): # funtion definition
    num1 = int(input("enter num 1: ")) #steps
    num2 = int(input("enter num 2: "))  #steps

    sum = num1 + num2   #step
    print(sum)  #step

env = input("Enter the environment (dev, test, prod): ")  # Get the environment from the user(  keyboard input) env is variable and input is function and dev, test, prod are constants
print("The environment you entered is:", env)  # Print the environment to the console

if env == "prod":
  sum_of_num()  # funtion calling
      