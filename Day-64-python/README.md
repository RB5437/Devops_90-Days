# Day 64: Python for DevOps - Lists, Tuples & Real Automation Script

## Concepts Covered:
- Lists - mutable, ordered collections in Python
- Tuples - immutable, ordered collections in Python
- List operations: `append()`, `remove()`, indexing
- Difference between Lists and Tuples (mutable vs immutable, memory footprint)
- `type()` function to check data type of a variable
- Practical DevOps example: managing a list of S3 bucket names
- Real automation script: listing files in multiple folders using the `os` module
- Exception handling basics (`try/except`) with `FileNotFoundError` and `PermissionError`
- Intro/preview of Dictionaries and Sets (key-value pairs, properties of an object/instance)

## Key Learning:

### 1. Lists - Mutable Sequences
A list is created using square brackets `[]` and can be modified after creation.
```python
# list
s3_bucket_list = ["ritik_demo_bucket", "mis_demo_bucket", "ayu_demo_bucket", "rik_demo_bucket"]
print(s3_bucket_list)
```
Output:
```
['ritik_demo_bucket', 'mis_demo_bucket', 'ayu_demo_bucket', 'rik_demo_bucket']
```

`append()` adds a new item to the list:
```python
s3_bucket_list.append("john_demo_bucket")
print(s3_bucket_list)
```
Output: `['ritik_demo_bucket', 'mis_demo_bucket', 'ayu_demo_bucket', 'rik_demo_bucket', 'john_demo_bucket']`

`remove()` deletes an item by value:
```python
s3_bucket_list.remove("rik_demo_bucket")
print(s3_bucket_list)
```
Output: `['ritik_demo_bucket', 'mis_demo_bucket', 'ayu_demo_bucket']`

Indexing - access items by position (0-based):
```python
print(s3_bucket_list[2])
```
Output: `ayu_demo_bucket`

### 2. Tuples - Immutable Sequences
A tuple is created using round brackets `()` - once created, it cannot be changed.
```python
s3_bucket_list = ("ritik_demo_bucket", "mis_demo_bucket", "ayu_demo_bucket", "rik_demo_bucket")
print(type(s3_bucket_list))
```
Output: `<class 'tuple'>` (vs `<class 'list'>` for the list version)

Trying `append()` on a tuple fails:
```python
s3_buckets_lists = ("abhishek_demo_bucket", "ramu_demo_bucket", "tim_demo_bucket", "john_demo_bucket")
s3_buckets_lists.append("new_s3_bucket")
```
Output:
```
AttributeError: 'tuple' object has no attribute 'append'
```

### 3. List vs Tuple - When to Use What
- List -> use when data needs to change (add/remove/update items) - e.g., a list of servers that can scale up/down
- Tuple -> use when data should NOT change - e.g., a fixed set of credentials, a coordinate pair, or config values that must remain constant. Tuples are also slightly more memory-efficient since Python doesn't need to allocate extra space for resizing.

### 4. Real Automation Script - List Files in Multiple Folders
This script combines lists, functions, the `os` module, and exception handling - a genuine DevOps automation pattern (e.g., checking log directories across multiple paths).

```python
import os

def list_files_in_folder(folder_path):
    try:
        files = os.listdir(folder_path)
        return files, None
    except FileNotFoundError:
        return None, "Folder not found"
    except PermissionError:
        return None, "Permission denied"

def main():
    folder_paths = input("Enter a list of folder paths separated by spaces: ").split()

    for folder_path in folder_paths:
        files, error_message = list_files_in_folder(folder_path)
        if files:
            print(f"Files in {folder_path}:")
            for file in files:
                print(file)
        else:
            print(f"Error in {folder_path}: {error_message}")

if __name__ == "__main__":
    main()
```

Key points learned from this script:
- `.split()` on user input converts a space-separated string into a list of folder paths
- `os.listdir(path)` returns a list of files/directories inside a given path
- `try/except` with multiple `except` blocks handles different error types separately (missing folder vs permission denied)
- A function can return multiple values (`return files, None`) - very useful for returning both result and error
- `if __name__ == "__main__":` is the standard entry point pattern for Python scripts

## Why This Matters for DevOps:
Lists and tuples are the most-used data structures in DevOps automation - server lists, bucket names, file paths, IP addresses, all get stored and looped over as lists. Tuples are useful for fixed/constant data that shouldn't accidentally be modified. The file-listing script is a real building block for tools that scan multiple log/config directories across servers.

