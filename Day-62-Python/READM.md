# Day 62 — Notes | Python for DevOps Day 2

## 📅 Date: 13 June 2026

---

## 🐍 Concept 1: How Python Executes Code
**Docs**: https://docs.python.org/3/tutorial/interpreter.html

```
YOU write code → Python Interpreter reads top to bottom → Output
```

### Two ways to run Python:
```python
# 1. Script mode — write .py file, run it
python .\my-first-file.py

# 2. REPL (Interactive Shell) — type one line, see result immediately
# REPL = Read → Evaluate → Print → Loop
python   # opens interactive shell
>>> print("hello")
hello
```

**Why REPL matters for DevOps:** Quick testing of snippets without creating files — useful for debugging live servers.

---

## 📦 Concept 2: Variables Deep Dive
**Docs**: https://docs.python.org/3/tutorial/introduction.html

### Variable = Memory location that CHANGES
```python
output = "yes"   # output points to "yes"
output = "no"    # output now points to "no" — "yes" is gone
```

### Naming Rules (PEP8 — Python standard):
```python
# ✅ Snake case — Python standard
employee_name = "Rahul"
basic_salary = 50000
total_salary = basic_salary + 10000

# ❌ Camel case — not Python standard (used in Java/JS)
employeeName = "Rahul"   # works but not Pythonic
```
**PEP8 Docs**: https://peps.python.org/pep-0008/

### Variable vs Constant vs Operator:
```python
env = "dev"
#  ↑     ↑    ↑
# var  const  assignment operator (=)
```

---

## 🔢 Concept 3: Data Types
**Docs**: https://docs.python.org/3/library/stdtypes.html

### type() function — check data type
```python
x = 500
print(type(x))      # <class 'int'>

print(type("y"))    # <class 'str'> ← "y" in quotes = string!
print(type(y))      # <class 'int'> ← y without quotes = variable!
```

### DevOps relevance:
```python
# Reading config values — type matters!
port = "8080"        # string — from config file
port = int("8080")   # int — for arithmetic comparison

# Boolean for flags
debug_mode = True
is_production = False
```

### Type conversion:
```python
"500" + "200"   = "500200"  # string concatenation!
500  + 200      = 700       # integer addition
int("500") + int("200") = 700  # convert then add
```

---

## ➕ Concept 4: Operators
**Docs**: https://docs.python.org/3/library/operator.html

```python
# Arithmetic Operators
a + b   # addition
a - b   # subtraction
a * b   # multiplication
a / b   # division (always returns float!)
a // b  # floor division (returns int)
a % b   # modulo (remainder)
a ** b  # power

# Comparison Operators
a == b  # equal to (two equals signs!)
a != b  # not equal
a > b   # greater than
a < b   # less than

# Assignment Operator
=   # assign value (NOT comparison!)
```

### Real output from today:
```python
x = 20, y = 3
z = x * y → 60

a = 12, b = 29
Multiplication: 18    # Wait — 12*29 = 348? No, different values
Addition: 11
Subtraction: -7
Division: 0.222...
```

---

## ⌨️ Concept 5: input() Function
**Docs**: https://docs.python.org/3/library/functions.html#input

```python
# input() ALWAYS returns a STRING
name = input("Enter name: ")   # returns str
age = input("Enter age: ")     # returns str "25", NOT int 25!

# Convert to int for arithmetic
age = int(input("Enter age: "))   # now it's int
```

### Why this matters for DevOps:
```python
# Reading environment from user or config
env = input("Enter the environment (dev, test, prod): ")
# env is always a string — safe for comparison with ==
```

---

## 🔀 Concept 6: Conditional Statements
**Docs**: https://docs.python.org/3/tutorial/controlflow.html

### Structure:
```python
if condition:
    # runs if condition is True
elif another_condition:
    # runs if first is False, this is True
else:
    # runs if ALL above are False
```

### Indentation is MANDATORY in Python:
```python
# ✅ Correct
if env == "prod":
    print("Don't Deploy on Friday")   # 4 spaces indent

# ❌ Wrong — IndentationError
if env == "prod":
print("Don't Deploy on Friday")   # No indent!
```

### Real DevOps use case from today:
```python
env = input("Enter the environment (dev, test, prod): ")

if env == "prod":
    print("Don't Deploy on Friday")
elif env == "stg":
    print("Take backup & test well")
else:
    print("You can deploy on any day it's safe")
```

**This is REAL DevOps logic!** Production deployment guardrails — exactly what gets implemented in CI/CD pipelines.

---

## 💼 Concept 7: First Real Program — Salary Calculator
**File**: `my_first_prg.py`

```python
employee_name = "Rahul"
basic_salary = 50000
bonus = 10000
tax = 5000

total_salary = basic_salary + bonus - tax

print("Employee Name:", employee_name)    # Rahul
print("Total Salary:", total_salary)      # 55000
print("Data type of employee_name:", type(employee_name))  # str
print("Data type of basic_salary:", type(basic_salary))    # int
```

**Output:**
```
Employee Name: Rahul
Total Salary: 55000
Basic Salary: 50000
Bonus: 10000
Tax: 5000
Data type of employee_name: <class 'str'>
Data type of basic_salary: <class 'int'>
```

---

## 🔑 Key Points to Remember

| Concept | Remember |
|---------|----------|
| Python execution | Top to bottom — line by line |
| Variable | Can change — `output = "yes"` then `output = "no"` |
| Constant | Cannot change — `1`, `"dev"`, `True` |
| `type()` | Check data type of any value |
| `input()` | ALWAYS returns string — convert with `int()` if needed |
| `=` | Assignment (give value) |
| `==` | Comparison (check if equal) |
| Snake case | Python naming standard — `hello_dosto` not `helloDosto` |
| Indentation | 4 spaces — mandatory in Python |

---

## 📖 Official Links

| Topic | Link |
|-------|------|
| Python Tutorial | https://docs.python.org/3/tutorial/ |
| Data Types | https://docs.python.org/3/library/stdtypes.html |
| Built-in Functions | https://docs.python.org/3/library/functions.html |
| Control Flow | https://docs.python.org/3/tutorial/controlflow.html |
| PEP8 Style Guide | https://peps.python.org/pep-0008/ |
| Shubham GitHub | https://github.com/LondheShubham153/python-for-devops |
