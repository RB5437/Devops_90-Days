for i in range(5):
    env = input("Enter the environment ") # taking input from the user (keyboard)

    print("The user input Env is : ", env) # printing the user input

    #conditional statement

    # == != > < >= <=

if env == "prod":  # true or false
    print("Don't Deploy on Friday")  
elif env == "stg":  # true or false
    print("Take backup & test well")  # If the environment is dev, print a message indicating that deployment is allowed
elif env == "test":  # true or false
    print("test it well")  # Print a message indicating that deployment is allowed
else:  # false
    print("You can deploy on any day it's  safe")  # Print a message indicating that deployment is allowed
