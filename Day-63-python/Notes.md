# Day 63 Notes - Loops, Conditionals, Functions & psutil

## 1. For Loop Basics

```python
for i in range(5):
    print(i)
```
- `range(5)` -> generates numbers from 0 to 4 (5 values, exclusive of 5)
- `i` is the loop variable that takes each value in the range, one at a time
- `range(start, end, increment)` -> gives full control over the loop sequence

Example: `range(1, 11)` -> 1 to 10 (used for printing multiplication tables)

## 2. While Loop (Rarely Used)

```python
suraj = "chand"

while suraj == "chand":
    print("RBB name")  # infinite loop
    break
```
- Loop continues as long as the condition is `True`
- Without a proper `break` or condition update -> **infinite loop**
- In the demo, output kept printing "RBB name" until manually stopped with `Ctrl+C` -> raised `KeyboardInterrupt`
- **Why rarely used in DevOps scripts**: `for` loops with `range()` or iterating over known data are more predictable; `while` is mostly used for things like "keep retrying until success" or "keep running until user quits"

## 3. Conditional Statements

Comparison operators: `==`, `!=`, `>`, `<`, `>=`, `<=`

```python
if env == "prod":      # true or false
    print("Don't Deploy on Friday")
elif env == "stg":
    print("Take backup & test well")
elif env == "test":
    print("test it well")
else:
    print("You can deploy on any day it's safe")
```
- `if` checks the first condition
- `elif` (else if) checks additional conditions if the first is false
- `else` runs if none of the above conditions match
- Very useful for environment-based DevOps decisions (e.g., blocking prod deploys on Fridays)

## 4. Taking Input + String Formatting (f-strings)

```python
env = input("Enter the environment ")  # always returns a string
print("The user input Env is : ", env)
```

```python
num = int(input("enter the number of tables you want to print: "))
name = input("enter friend name")

print(f"Hello Friend Good Morning, {name}")

for i in range(1, 11):
    print(f"{num} * {i} = {num*i}")
```
- `input()` always returns a string -> use `int()` to convert to a number when doing math
- f-string format: `f"some text {variable}"` -> cleaner than comma-separated print arguments

## 5. Real World Example - Choice Driven Loop

```python
choice = input("enter the choice(press q to quit):")

while choice != "q":
    num = int(input("enter the number you want the table for"))
    for i in range(1, 11):
        print(f"{num} * {i} = {num*i}")
    choice = input("enter the choice(press q to quit):")
```
- Combines `while` + `for` + `input` + f-string
- Keeps running until the user types `q`
- This pattern (menu/choice loop) is common in CLI automation tools

## 6. Functions

```python
def sum_of_num():  # function definition
    num1 = int(input("enter num 1: "))
    num2 = int(input("enter num 2: "))

    sum = num1 + num2
    print(sum)

sum_of_num()  # function calling
```

- `def function_name():` defines a function
- Everything inside the function must follow the **indented block rule** - same indentation level = part of the function body
- Function only runs when explicitly **called** by its name with `()`

### Conditional Function Call
```python
env = input("Enter the environment (dev, test, prod): ")
print("The environment you entered is:", env)

if env == "prod":
    sum_of_num()  # only runs in prod
```
- Function call wrapped inside an `if` block -> runs only when condition is true
- Useful pattern: run heavy/critical logic only for specific environments

## 7. psutil - System Monitoring Library

- `psutil` (process and system utilities) = cross-platform Python library to monitor CPU, memory, disk, and network usage
- Available on **PyPI** (Python Package Index) -> install via pip

### Installation
```bash
pip install psutil     # ERROR: Operation cancelled by user
pip3 install psutil    # Successfully installed psutil-7.2.2
```

### CPU Monitoring Script (`check_cpu.py`)
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

- `psutil.cpu_percent(interval=1)` -> measures CPU usage % over 1 second
- Compares current CPU usage with a user-given threshold
- If usage > threshold -> simulate sending an alert
- Else -> system is in safe state

### Sample Run
```
enter the cpu threshold: 10
current cpu %:  45
cpu alert email sent ...

enter the cpu threshold: 45
current cpu %:  5.3
cpu in safe state
```

## Key Takeaway
Today's session connected basic Python building blocks (loops, conditionals, functions) into a real monitoring use case using `psutil` - this is the foundation for writing custom health-check and alerting scripts in DevOps.

## Doubts / To Explore
- Why did `pip install psutil` get cancelled but `pip3 install psutil` worked? (Check PATH / multiple Python installs)
- Difference between `break` placement inside vs outside the `while` loop body (indentation impact)
- How to extend `check_cpu.py` to also check memory (`psutil.virtual_memory()`) and disk usage (`psutil.disk_usage()`)
