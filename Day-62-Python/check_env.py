 # Get the Environment  from the user and print it to the console
env = input("Enter the environment (dev, test, prod): ")  # Get the environment from the user(  keyboard input) env is variable and input is function and dev, test, prod are constants
print("The environment you entered is:", env)  # Print the environment to the console

# conditional statement - if else
#if env == "prod":  # Check if the environment is prod
 #   print("Don't Deploy on Friday")  # If the environment is prod, print a warning message
#else:  # If the environment is not prod
 #   print("You can deploy on any day it's  safe")  # Print a message indicating that deployment is allowed 

if env == "prod":  # Check if the environment is prod
    print("Don't Deploy on Friday")  # If the environment is prod, print a warning message
elif env == "stg":  # Check if the environment is dev
    print("Take backup & test well")  # If the environment is dev, print a message indicating that deployment is allowed
else:  # If the environment is not prod or dev
    print("You can deploy on any day it's  safe")  # Print a message indicating that deployment is allowed



a = int(input("Enter a number: 1"))  # Get a number from the user
b = int(input("Enter another number: 2"))  # Get another number from the user
print(type(a))  # Print the data type of a
print(type(b))  # Print the data type of b

print("Multiplication of a and b is: ",a * b)  # Multiply the two numbers and print the result
print("Addition of a and b is: ",a + b)  # Add the two numbers and print the result
print("Subtraction of a and b is: ",a - b)  # Subtract the two numbers and print the result
print("Division of a and b is: ",a / b)  # Divide the two numbers and print the result