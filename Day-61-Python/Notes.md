# Day 61 Notes - Python for DevOps Setup

## Topic: Python For DevOps - What? Why? How?

### What is Python for DevOps?
Python is a high-level, easy-to-read programming language widely used by DevOps engineers to automate infrastructure, cloud, and operational tasks.

### Why Python for DevOps?
- Simple syntax, easy to learn compared to other languages
- Huge ecosystem of libraries (Boto3 for AWS, paramiko for SSH, requests for APIs)
- Used to write automation scripts for CI/CD pipelines
- Helps build custom tools, monitoring scripts, and AI agents
- Most cloud SDKs (AWS, GCP, Azure) have Python support

### How to get started?
1. Install Python on your system
2. Set up VS Code with Python extension
3. Create a project folder structure
4. Write and run your first script
5. Gradually move to automation use cases (file handling, APIs, AWS)

---

## Environment Setup

- Created root project folder: `Python_For_DevOps`
- Created subfolder: `Day-01`
- Created file: `my-first-file.py`

## First Python Program

```python
print("Hello, World!")
```

## Running the Script

```bash
PS D:\Python_For_DevOps> cd .\Day-01\
PS D:\Python_For_DevOps\Day-01> python .\my-first-file.py
Hello, World!
```

## Commands Used
| Command | Purpose |
|---|---|
| `cd .\Day-01\` | Navigate into Day-01 folder |
| `ls` | List files/folders in current directory |
| `python .\my-first-file.py` | Run the Python script |

## Key Takeaway
The first step in any language is `print("Hello, World!")` - confirms the environment setup is correct and ready for further development.

## Doubts / To Explore
- Difference between running with `python` vs `python3`
- How VS Code integrated terminal detects Python interpreter automatically
