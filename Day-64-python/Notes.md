# Day 64 Notes - Lists, Tuples & File Automation Script

## 1. Lists (Mutable)

```python
s3_bucket_list = ["ritik_demo_bucket", "mis_demo_bucket", "ayu_demo_bucket", "rik_demo_bucket"]
```
- Defined using square brackets `[]`
- Ordered collection - items have a position/index (starting from 0)
- **Mutable** - can be changed after creation

### List Operations Practiced
| Operation | Code | Result |
|---|---|---|
| Print whole list | `print(s3_bucket_list)` | `['ritik_demo_bucket', 'mis_demo_bucket', 'ayu_demo_bucket', 'rik_demo_bucket']` |
| Add item | `s3_bucket_list.append("john_demo_bucket")` | adds "john_demo_bucket" at the end |
| Remove item | `s3_bucket_list.remove("rik_demo_bucket")` | removes "rik_demo_bucket" from the list |
| Access by index | `s3_bucket_list[2]` | returns the item at position 2 (e.g., "ayu_demo_bucket") |
| Check type | `type(s3_bucket_list)` | `<class 'list'>` |

## 2. Tuples (Immutable)

```python
s3_bucket_list = ("ritik_demo_bucket", "mis_demo_bucket", "ayu_demo_bucket", "rik_demo_bucket")
```
- Defined using round brackets `()`
- Ordered collection like a list
- **Immutable** - once created, CANNOT be modified (no append, no remove, no item assignment)

### Proof of Immutability
```python
s3_buckets_lists = ("abhishek_demo_bucket", "ramu_demo_bucket", "tim_demo_bucket", "john_demo_bucket")
s3_buckets_lists.append("new_s3_bucket")
```
Error:
```
AttributeError: 'tuple' object has no attribute 'append'
```
- Confirms tuples don't support `.append()` (or `.remove()`, etc.) - these are list-only methods

## 3. List vs Tuple - Quick Comparison
| Aspect | List | Tuple |
|---|---|---|
| Syntax | `[ ]` | `( )` |
| Mutable? | Yes | No |
| Methods available | append, remove, insert, sort, etc. | very limited (count, index) |
| Memory | Slightly more (allows resizing) | Slightly less (fixed size) |
| Use case | Data that changes (server list, queue) | Data that's fixed (constants, config values, coordinates) |

## 4. Real Automation Script - `list_files_in_folders.py`

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

### Line-by-Line Understanding
- `import os` - brings in the `os` module, which lets Python interact with the operating system (files, directories, environment variables)
- `os.listdir(folder_path)` - returns a **list** of all files/folders inside `folder_path`
- `def list_files_in_folder(folder_path):` - a function that takes one input (folder path) and returns two values: the list of files (or `None`) and an error message (or `None`)
- `try / except FileNotFoundError / except PermissionError` - handles two different failure scenarios separately, instead of crashing the script
- `input("...").split()` - takes a single line of user input (e.g., "/tmp /abc") and converts it into a **list**: `["/tmp", "/abc"]`
- `for folder_path in folder_paths:` - loops through each folder path entered by the user
- `if files:` - checks if `files` is not `None`/empty before trying to loop over it
- `if __name__ == "__main__":` - ensures `main()` only runs when the script is executed directly (standard Python script structure)

### Sample Run (Concept)
```
Enter a list of folder paths separated by spaces: /tmp /abc
Files in /tmp:
file1.log
file2.log
Error in /abc: Folder not found
```

## 5. Preview - Day 65 (Dictionaries & Sets)
- Dictionary = key-value pairs, e.g.:
```python
student = {
    "name": "abhishek",
    "id": 101,
    "class": "DevOps",
    "age": 25
}
```
- Useful for representing "properties of an object/instance" - e.g., a server's config (name, IP, region, status) as one dictionary
- A list of dictionaries = list of students/servers, each with their own properties: `student_list = [{"name": "abhi", ...}, {"name": "ram", ...}]`
- Sets - unordered collection of unique items, useful for removing duplicates (e.g., unique environments from a list: `set(["dev","prod","dev"])` -> `{"dev","prod"}`)

## Key Takeaway
Lists and Tuples are both ordered sequences, but the mutability difference (list = changeable, tuple = fixed) decides which one to use. The file-listing script ties together lists (`os.listdir` output, `.split()` input), functions, and exception handling into one real automation tool - a strong step toward writing production-style DevOps scripts.

## Doubts / To Explore
- When does Python actually use the "memory footprint" advantage of tuples in practice - is it noticeable for small DevOps scripts?
- Can a function return more than 2 values? (Yes - Python returns them as a tuple - connects back to today's tuple topic!)
- What other `os` module functions are commonly used in DevOps scripts (`os.path.exists`, `os.makedirs`, `os.remove`, etc.)?
