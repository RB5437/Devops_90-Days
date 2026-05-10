
##  Navigation Commands

```bash
ls
pwd
cd dir1
cd ..
```

##  Create Directories & Files

```bash
mkdir ritik
mkdir file1
touch touch.txt
```

##  Delete Files & Directories

```bash
rm -rf file1.txt/
rmdir file1/
```

##  List Files (Detailed View)

```bash
ls -la
```

##  Check Inode Number

```bash
ls -i
```

##  View File Content

```bash
cat file.txt
head -2 file.txt
tail -3 /root/anaconda-ks.cfg
```

##  Links (Observed in Practice)

* Hard Link: `file.txt_hardlink`
* Soft Link: `text_soft.txt -> text.txt`

##  Notes

* `rm -rf` deletes files/directories forcefully
* `rmdir` deletes only empty directories
* `ls -la` shows hidden files and permissions
* `ls -i` displays inode numbers
* Hard links share same inode
* Soft links act as shortcuts
