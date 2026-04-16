

##  What I Practiced

* Directory navigation (`cd`, `pwd`)
* Listing files (`ls`, `ls -la`)
* Creating directories (`mkdir`)
* Removing directories (`rm`, `rmdir`)
* Viewing file content (`cat`, `head`, `tail`)
* Understanding inode (`ls -i`)
* Observed hard link and soft link

---

##  Directory Navigation

* `cd dir1` → move inside directory
* `cd ..` → go back
* `pwd` → shows current path

 Example:

```bash
cd dir1
cd ..
pwd
```

---

##  File & Directory Management

### Create

* `mkdir ritik` → create directory
* `touch touch.txt` → create file

### Delete

* `rm -rf file1.txt/` → force delete directory
* `rmdir file1/` → delete empty directory

---

##  Mistake I Made (Important Learning)

```bash
rmdir -rvf file1/
```

 Error: invalid option

 Learned:

* `rmdir` does NOT support `-rf`
* It only deletes empty directories

✔ Correct usage:

```bash
rmdir file1/
```

---

##  File Viewing Commands

```bash
cat file.txt_hardlink
head -2 file.txt_hardlink
tail -3 /root/anaconda-ks.cfg
```

 Learning:

* `cat` → full content
* `head` → first lines
* `tail` → last lines

 Error faced:

* File not found while using `tail`
* Learned to check correct file path

---

##  Inode Concept

```bash
ls -i
```
 Learning:

* Every file has unique inode number
* Hard links share same inode
* Helps in identifying file relationships

---

##  Hard Link vs Soft Link

### From my system:

* `file.txt_hardlink`
* `text_soft.txt -> text.txt`

### Hard Link

* Same inode
* Works even if original file is deleted

### Soft Link

* Different inode
* Breaks if original file is deleted

---

##  Key Takeaways

* Linux commands need correct syntax
* Small mistakes cause errors
* File system understanding is important
* Practice is necessary for DevOps

---

##  DevOps Connection

* Linux is used in AWS EC2 servers
* All deployments happen via terminal
* Commands like `ls`, `cd`, `rm` are used daily in real projects
