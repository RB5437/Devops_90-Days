# Day 62 — Python for DevOps | Day 2 🐍
## 📅 Date: 13 June 2026
## 🎯 Topic: Variables, Constants, Data Types, Operators, Input, Conditional Statements (if/elif/else)

---

## 📚 Resources Used
- 📺 **TrainWithShubham — Python for DevOps**
  - YouTube: https://www.youtube.com/watch?v=E_eoFRX1Fzw
  - GitHub: https://github.com/LondheShubham153/python-for-devops

---

## 🐍 How Python Works — Top Down Execution

```
YOU → Write Code (.py file) → Python Interpreter → Magic (Output)
```
- Python reads code **top to bottom** — line by line
- `print` = most basic instruction to show output
- **REPL** = Read → Evaluate → Print → Loop (Interactive Shell)

---

## 📦 Variables vs Constants

| Concept | Definition | Example |
|---------|-----------|---------|
| **Variable** | Named location in memory — value CAN change | `output = "yes"` then `output = "no"` |
| **Constant** | Named location — value CANNOT change | `1`, `"dev"`, `True` |
| **Script** | Set of instructions to perform a specific task | `.py` file |
| **Program** | Code → App (runs on server) | Full application |

```python
# Variable — changes
output = "yes"   # vary + able = variable
output = "no"    # changed!

# Assignment
env = "dev"      # env = variable, "dev" = constant, = is assignment operator
a = 100
b = 200
```

---

## 🔢 Data Types

| Type | Examples | Python check |
|------|----------|-------------|
| **int** | 1, 2, 3, 500, 7000 | `type(x)` → `<class 'int'>` |
| **float** | 1.0, 2.5, 500.0 | `type(x)` → `<class 'float'>` |
| **boolean** | True, False | `type(x)` → `<class 'bool'>` |
| **string** | "hello", '123' | `type(x)` → `<class 'str'>` |

```python
x = 500
y = 700
print(type(x))    # <class 'int'>
print(type("y"))  # <class 'str'>  ← "y" is string not variable!
```

---

## ➕ Operators

```python
# + - * / = (Operators)
# a + b → a, b are operands; a + b is the operation

x = 20
y = 3
z = x * y
print("the multiplication of x and y is:", z)   # 60
```

**Naming Conventions:**
- **Camel Case** → `helloDosto` (used in Java, JS)
- **Snake Case** → `hello_dosto` (Python standard ✅)

---

## ⌨️ Input from User

```python
# input() — gets keyboard input, always returns STRING
env = input("Enter the environment (dev, test, prod): ")
print("The environment you entered is:", env)

# int() — convert string to integer
a = int(input("Enter a number: 1"))
b = int(input("Enter another number: 2"))
```

---

## 🔀 Conditional Statements — if / elif / else

```python
# if / else — DevOps use case!
if env == "prod":
    print("Don't Deploy on Friday")
else:
    print("You can deploy on any day it's safe")

# if / elif / else — multiple conditions
if env == "prod":
    print("Don't Deploy on Friday")
elif env == "stg":
    print("Take backup & test well")
else:
    print("You can deploy on any day it's safe")
```

**Live output:**
```
Enter the environment: prod → "Don't Deploy on Friday" ✅
Enter the environment: test → "You can deploy on any day it's safe" ✅
Enter the environment: stg  → "Take backup & test well" ✅
```

---

## 📁 Files Created Today — Day-02

| File | What it does |
|------|-------------|
| `variable_constant.py` | Variables, constants, operators, arithmetic |
| `data-type.py` | int, float, bool, string — type() function |
| `my_first_prg.py` | Salary calculator — employee name, basic, bonus, tax |
| `check_env.py` | Environment checker — if/elif/else + input() + arithmetic |

---

## 🔗 Official Documentation Links

| Topic | Link |
|-------|------|
| Python Variables | https://docs.python.org/3/tutorial/introduction.html |
| Python Data Types | https://docs.python.org/3/library/stdtypes.html |
| Python Operators | https://docs.python.org/3/library/operator.html |
| Python Input | https://docs.python.org/3/library/functions.html#input |
| Python if/elif/else | https://docs.python.org/3/tutorial/controlflow.html |
| Python Naming Conventions | https://peps.python.org/pep-0008/#naming-conventions |
| TrainWithShubham Repo | https://github.com/LondheShubham153/python-for-devops |

---

## 📂 GitHub
https://github.com/RB5437/Devops_90-Days
