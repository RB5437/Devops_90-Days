# Day 63: Python for DevOps - Loops, Conditionals, Functions & Real-Time CPU Monitoring

## Concepts Covered:
- `for` loops using `range()` in Python
- `while` loops (and why they are rarely used in scripting)
- Conditional statements (`if`, `elif`, `else`) with comparison operators
- Taking dynamic input from the user using `input()`
- String formatting using f-strings
- Building a multiplication table generator
- A real-world choice-driven program (loop + condition + input)
- Functions: definition, indentation/block rules, and function calling
- Conditional function calls based on environment (dev/test/prod)
- Real-time CPU monitoring script using the `psutil` library

## Key Learning:
- `for i in range(5)` loops from 0 to 4, while `range(start, end, step)` gives full control over the loop range.
- `while` loops are rarely used in DevOps scripting because they can easily turn into infinite loops if the condition/break logic is not handled carefully (saw this live with a `KeyboardInterrupt`).
- Conditional operators (`==`, `!=`, `>`, `<`, `>=`, `<=`) combined with `if/elif/else` are heavily used for environment-based decision making (e.g., blocking deployments on certain days/environments).
- f-strings (`f"{variable}"`) make string formatting clean and readable - very useful for generating dynamic log/output messages.
- Functions (`def function_name():`) follow strict indentation rules - everything inside the function body must be properly indented (the indented block rule).
- Functions can be called conditionally based on user input (e.g., only run a heavy task if `env == "prod"`).
- `psutil` is a cross-platform Python library used to monitor system resources like CPU, memory, disk, and network - extremely useful for writing monitoring/alerting scripts in DevOps.
- Installed `psutil` using `pip3 install psutil` after `pip install psutil` failed.

## Practical / Hands-on Scripts:

### 1. Loop Test (`loop_test.py`)
```python
for i in range(5):
    print(i)

for i in range(10):
    print("Good Morning")
```
Output: prints 0-4, then "Good Morning" 10 times.

### 2. Environment Check with Conditionals (`loop_test.py` extended)
```python
for i in range(5):
    env = input("Enter the environment ")
    print("The user input Env is : ", env)

    if env == "prod":
        print("Don't Deploy on Friday")
    elif env == "stg":
        print("Take backup & test well")
    elif env == "test":
        print("test it well")
    else:
        print("You can deploy on any day it's safe")
```

### 3. Multiplication Table Generator (`tables.py`)
```python
num = int(input("enter the number of tables you want to print: "))

for i in range(1, 11):
    print(f"{num} * {i} = {num*i}")
```
Bonus version - greets the user by name using f-strings before printing the table.

### 4. While Loop Example (`while_loop.py`)
```python
suraj = "chand"

while suraj == "chand":
    print("RBB name")  # infinite loop
    break
```
Demonstrated why `while` loops need a careful exit condition - without proper handling this runs infinitely and needs `Ctrl+C` (KeyboardInterrupt) to stop.

### 5. Real-World Example - Choice Driven Program (`real_example.py`)
```python
# real world
choice = input("enter the choice(press q to quit):")

while choice != "q":
    num = int(input("enter the number you want the table for"))
    for i in range(1, 11):
        print(f"{num} * {i} = {num*i}")
    choice = input("enter the choice(press q to quit):")
```
Keeps asking the user for a number and prints its table until the user presses `q` to quit.

### 6. Functions (`funtions_env.py`)
```python
def sum_of_num():  # function definition
    num1 = int(input("enter num 1: "))
    num2 = int(input("enter num 2: "))

    sum = num1 + num2
    print(sum)

env = input("Enter the environment (dev, test, prod): ")
print("The environment you entered is:", env)

if env == "prod":
    sum_of_num()  # function calling
```
Learned that the function only runs when `env == "prod"` - everything else just prints the entered environment.

### 7. Real-Time CPU Monitoring (`check_cpu.py`)
```python
import psutil  # import the lib from pypi

def check_cpu_threshold():
    check_cpu_threshold = int(input("enter the cpu threshold"))

    current_cpu = psutil.cpu_percent(interval=1)
    print("current cpu %: ", current_cpu)

    if current_cpu > check_cpu_threshold:
        print("cpu alert email sent ...")
    else:
        print("cpu in safe state")

check_cpu_threshold()
```

**Setup steps:**
```bash
pip install psutil      # failed - operation cancelled
pip3 install psutil     # worked - successfully installed psutil-7.2.2
python .\check_cpu.py
```

**Sample Output:**
```
Enter the CPU threshold: 10
current cpu %:  45
cpu alert email sent ...

enter the cpu threshold: 45
current cpu %:  5.3
cpu in safe state
```

## Why This Matters for DevOps:
This is where Python starts feeling like real DevOps automation - using `psutil` to monitor CPU usage and trigger alerts is the basic building block for writing custom monitoring scripts, health-check tools, and auto-remediation agents (similar logic can be extended to memory, disk, and network checks, or wired into Slack/email alerts).

## Next Steps (Day 64):
- Lists, tuples, and dictionaries in Python
- Extending the CPU monitor to check memory and disk usage
- Writing the monitoring output to a log file
