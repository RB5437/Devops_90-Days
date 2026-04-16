root@ip-172-31-33-210:/home# ls
dir1  dir2  file.txt_hardlink  text  text_soft.txt  ubuntu
root@ip-172-31-33-210:/home# cd dir1
root@ip-172-31-33-210:/home/dir1# cd ..
root@ip-172-31-33-210:/home# pwd
/home
root@ip-172-31-33-210:/home# mkdir ritik
root@ip-172-31-33-210:/home# ls
dir1  dir2  file.txt_hardlink  ritik  text  text_soft.txt  ubuntu
root@ip-172-31-33-210:/home# ls -la
total 32
drwxr-xr-x  6 root   root   4096 Apr 13 07:48 .
drwxr-xr-x 22 root   root   4096 Apr 13 06:46 ..
drwxr-xr-x  2 root   root   4096 Apr 13 07:07 dir1
drwxr-xr-x  2 root   root   4096 Apr 13 06:56 dir2
-rw-r--r--  1 root   root     75 Apr 13 07:27 file.txt_hardlink
drwxr-xr-x  2 root   root   4096 Apr 13 07:48 ritik
-rw-r--r--  1 root   root     23 Apr 13 07:16 text
lrwxrwxrwx  1 root   root      8 Apr 13 07:15 text_soft.txt -> text.txt
drwxr-x---  4 ubuntu ubuntu 4096 Apr 13 06:55 ubuntu
root@ip-172-31-33-210:/home# ls -i
262276 dir1  262278 dir2   33614 file.txt_hardlink  262279 ritik   33617 text   33616 text_soft.txt  262224 ubuntu
root@ip-172-31-33-210:/home# mkdir file1
root@ip-172-31-33-210:/home# mkdir file1.txt
root@ip-172-31-33-210:/home# rm -rvf file1.txt/
removed directory 'file1.txt/'
root@ip-172-31-33-210:/home# rmdir -rvf file1/
rmdir: invalid option -- 'r'
Try 'rmdir --help' for more information.
root@ip-172-31-33-210:/home# rmdir  file1/
root@ip-172-31-33-210:/home# ls
dir1  dir2  file.txt_hardlink  ritik  text  text_soft.txt  ubuntu
root@ip-172-31-33-210:/home# cat file.txt_hardlink
 i am the boos fo this filed and genius persion in devops and cloud domain
root@ip-172-31-33-210:/home# touch touch.txt
root@ip-172-31-33-210:/home# ls
dir1  dir2  file.txt_hardlink  ritik  text  text_soft.txt  touch.txt  ubuntu
root@ip-172-31-33-210:/home# head -2 file.txt_hardlink
 i am the boos fo this filed and genius persion in devops and cloud domain
root@ip-172-31-33-210:/home# tail -3 /root/anaconda-ks.cfg
tail: cannot open '/root/anaconda-ks.cfg' for reading: No such file or directory
root@ip-172-31-33-210:/home# tail -1 file.txt_hardlink
 i am the boos fo this filed and genius persion in devops and cloud domain
root@ip-172-31-33-210:/home# less file.txt_hardlink

[3]+  Stopped                 less file.txt_hardlink
root@ip-172-31-33-210:/home# more file.txt_hardlink
 i am the boos fo this filed and genius persion in devops and cloud domain
root@ip-172-31-33-210:/home# echo " Day1 of my devops for linux command > fi
> more file.txt_hardlink ^C
root@ip-172-31-33-210:/home# echo " Day1 of my devops for linux command" >file.txt_hardlink
root@ip-172-31-33-210:/home# cat file.txt_hardlink
 Day1 of my devops for linux command
root@ip-172-31-33-210:/home# cp text dir1
root@ip-172-31-33-210:/home# ls dir1/
text  text,txt
root@ip-172-31-33-210:/home# mv text dir1
root@ip-172-31-33-210:/home# ls
dir1  dir2  file.txt_hardlink  ritik  text_soft.txt  touch.txt  ubuntu
root@ip-172-31-33-210:/home# wc touch.txt
0 0 0 touch.txt
root@ip-172-31-33-210:/home# wc file.txt_hardlink
 1  7 37 file.txt_hardlink
root@ip-172-31-33-210:/home# vi file.txt_hardlink
root@ip-172-31-33-210:/home# ln touch.txt  touch_hardlink.txt
root@ip-172-31-33-210:/home# ls
dir1  dir2  file.txt_hardlink  ritik  text_soft.txt  touch.txt  touch_hardlink.txt  ubuntu
root@ip-172-31-33-210:/home# cat touch.txt
root@ip-172-31-33-210:/home# echo "The `-n` option is used to display the content of a file along with line numbers. It helps in identifying and referring to specific lines in a file" > touch.txt
-n: command not found
root@ip-172-31-33-210:/home# echo "The n option is used to display the content of a file along with line numbers. It helps in identifying and referring to specific lines in a file" > touch.txt
root@ip-172-31-33-210:/home# cat touch.txt
The n option is used to display the content of a file along with line numbers. It helps in identifying and referring to specific lines in a file
root@ip-172-31-33-210:/home# ln -s touch.txt touch_soft.txt
root@ip-172-31-33-210:/home# ls
dir1  dir2  file.txt_hardlink  ritik  text_soft.txt  touch.txt  touch_hardlink.txt  touch_soft.txt  ubuntu
root@ip-172-31-33-210:/home# ls -la
total 36
drwxr-xr-x  6 root   root   4096 Apr 13 07:59 .
drwxr-xr-x 22 root   root   4096 Apr 13 06:46 ..
drwxr-xr-x  2 root   root   4096 Apr 13 07:56 dir1
drwxr-xr-x  2 root   root   4096 Apr 13 06:56 dir2
-rw-r--r--  1 root   root     71 Apr 13 07:57 file.txt_hardlink
drwxr-xr-x  2 root   root   4096 Apr 13 07:48 ritik
lrwxrwxrwx  1 root   root      8 Apr 13 07:15 text_soft.txt -> text.txt
-rw-r--r--  2 root   root    145 Apr 13 07:59 touch.txt
-rw-r--r--  2 root   root    145 Apr 13 07:59 touch_hardlink.txt
lrwxrwxrwx  1 root   root      9 Apr 13 07:59 touch_soft.txt -> touch.txt
drwxr-x---  4 ubuntu ubuntu 4096 Apr 13 06:55 ubuntu
root@ip-172-31-33-210:/home# cut -b 1 touch
cut: touch: No such file or directory
root@ip-172-31-33-210:/home# cut -b 1 touch.txt
T
root@ip-172-31-33-210:/home# cut -b 5 touch.txt
n
root@ip-172-31-33-210:/home# echo " The cat command provides different options to enhance how file content is displayed. Some commonly used options are shown below" | tee touch.txt
 The cat command provides different options to enhance how file content is displayed. Some commonly used options are shown below
root@ip-172-31-33-210:/home# cat touch.txt
 The cat command provides different options to enhance how file content is displayed. Some commonly used options are shown below
root@ip-172-31-33-210:/home#
root@ip-172-31-33-210:/home# ls
dir1  dir2  file.txt_hardlink  ritik  text_soft.txt  touch.txt  touch_hardlink.txt  touch_soft.txt  ubuntu
root@ip-172-31-33-210:/home# diff dir1 dir2
Only in dir1: text
Only in dir1: text,txt
root@ip-172-31-33-210:/home# diff touch.txt  touch_hardlink.txt
root@ip-172-31-33-210:/home# diff touch.txt  file.txt_hardlink
1c1,6
<  The cat command provides different options to enhance how file content is displayed. Some commonly used options are shown below
---
>  Day1 of my devops for linux command
> lskjcvvu
> vjvbewube
> ljdsuv
> ckxcon
>
root@ip-172-31-33-210:/home# df -h
Filesystem       Size  Used Avail Use% Mounted on
/dev/root        6.8G  1.9G  4.9G  28% /
tmpfs            456M     0  456M   0% /dev/shm
tmpfs            183M  876K  182M   1% /run
tmpfs            5.0M     0  5.0M   0% /run/lock
efivarfs         128K  3.6K  120K   3% /sys/firmware/efi/efivars
/dev/nvme0n1p16  881M   94M  726M  12% /boot
/dev/nvme0n1p15  105M  6.2M   99M   6% /boot/efi
tmpfs             92M   12K   92M   1% /run/user/1000
root@ip-172-31-33-210:/home# df -T
Filesystem      Type     1K-blocks    Used Available Use% Mounted on
/dev/root       ext4       7034376 1903188   5114804  28% /
tmpfs           tmpfs       466664       0    466664   0% /dev/shm
tmpfs           tmpfs       186668     876    185792   1% /run
tmpfs           tmpfs         5120       0      5120   0% /run/lock
efivarfs        efivarfs       128       4       120   3% /sys/firmware/efi/efivars
/dev/nvme0n1p16 ext4        901520   95584    742808  12% /boot
/dev/nvme0n1p15 vfat        106832    6250    100582   6% /boot/efi
tmpfs           tmpfs        93332      12     93320   1% /run/user/1000
root@ip-172-31-33-210:/home# df -i
Filesystem      Inodes IUsed  IFree IUse% Mounted on
/dev/root       917504 82908 834596   10% /
tmpfs           116666     2 116664    1% /dev/shm
tmpfs           819200   664 818536    1% /run
tmpfs           116666     3 116663    1% /run/lock
efivarfs             0     0      0     - /sys/firmware/efi/efivars
/dev/nvme0n1p16  58496   601  57895    2% /boot
/dev/nvme0n1p15      0     0      0     - /boot/efi
tmpfs            23333    32  23301    1% /run/user/1000
root@ip-172-31-33-210:/home# df -m
Filesystem      1M-blocks  Used Available Use% Mounted on
/dev/root            6870  1859      4995  28% /
tmpfs                 456     0       456   0% /dev/shm
tmpfs                 183     1       182   1% /run
tmpfs                   5     0         5   0% /run/lock
efivarfs                1     1         1   3% /sys/firmware/efi/efivars
/dev/nvme0n1p16       881    94       726  12% /boot
/dev/nvme0n1p15       105     7        99   6% /boot/efi
tmpfs                  92     1        92   1% /run/user/1000
root@ip-172-31-33-210:/home# free
               total        used        free      shared  buff/cache   available
Mem:          933328      373504      283708        2764      438276      559824
Swap:              0           0           0
root@ip-172-31-33-210:/home# free -m
               total        used        free      shared  buff/cache   available
Mem:             911         364         277           2         428         546
Swap:              0           0           0
root@ip-172-31-33-210:/home# free -h
               total        used        free      shared  buff/cache   available
Mem:           911Mi       364Mi       277Mi       2.7Mi       428Mi       546Mi
Swap:             0B          0B          0B
root@ip-172-31-33-210:/home# du -h
4.0K    ./ubuntu/.cache
8.0K    ./ubuntu/.ssh
28K     ./ubuntu
12K     ./dir1
4.0K    ./ritik
4.0K    ./dir2
60K     .
root@ip-172-31-33-210:/home# du -sh file.txt_hardlink
4.0K    file.txt_hardlink
root@ip-172-31-33-210:/home# du -sh dir1
12K     dir1
root@ip-172-31-33-210:/home#

root@ip-172-31-33-210:/home# ls
dir1  dir2  file.txt_hardlink  ritik  text_soft.txt  touch.txt  touch_hardlink.txt  touch_soft.txt  ubuntu
root@ip-172-31-33-210:/home# ps -ef
UID          PID    PPID  C STIME TTY          TIME CMD
root           1       0  0 06:45 ?        00:00:02 /sbin/init
root           2       0  0 06:45 ?        00:00:00 [kthreadd]
root           3       2  0 06:45 ?        00:00:00 [pool_workqueue_release]
root           4       2  0 06:45 ?        00:00:00 [kworker/R-rcu_gp]
root           5       2  0 06:45 ?        00:00:00 [kworker/R-sync_wq]
root           6       2  0 06:45 ?        00:00:00 [kworker/R-kvfree_rcu_reclaim]
root           7       2  0 06:45 ?        00:00:00 [kworker/R-slub_flushwq]
root           8       2  0 06:45 ?        00:00:00 [kworker/R-netns]
root          10       2  0 06:45 ?        00:00:00 [kworker/0:0H-events_highpri]
root          13       2  0 06:45 ?        00:00:00 [kworker/R-mm_percpu_wq]
root          14       2  0 06:45 ?        00:00:00 [ksoftirqd/0]
root          15       2  0 06:45 ?        00:00:00 [rcu_sched]
root          16       2  0 06:45 ?        00:00:00 [rcu_exp_par_gp_kthread_worker/0]
root          17       2  0 06:45 ?        00:00:00 [rcu_exp_gp_kthread_worker]
root          18       2  0 06:45 ?        00:00:00 [migration/0]
root          19       2  0 06:45 ?        00:00:00 [idle_inject/0]
root          20       2  0 06:45 ?        00:00:00 [cpuhp/0]
root          21       2  0 06:45 ?        00:00:00 [cpuhp/1]
root          22       2  0 06:45 ?        00:00:00 [idle_inject/1]
root          23       2  0 06:45 ?        00:00:00 [migration/1]
root          24       2  0 06:45 ?        00:00:00 [ksoftirqd/1]
root          26       2  0 06:45 ?        00:00:00 [kworker/1:0H-events_highpri]
root          27       2  0 06:45 ?        00:00:00 [kdevtmpfs]
root          28       2  0 06:45 ?        00:00:00 [kworker/R-inet_frag_wq]
root          29       2  0 06:45 ?        00:00:00 [rcu_tasks_rude_kthread]
root          30       2  0 06:45 ?        00:00:00 [rcu_tasks_trace_kthread]
root          31       2  0 06:45 ?        00:00:00 [kauditd]
root          32       2  0 06:45 ?        00:00:00 [khungtaskd]
root          34       2  0 06:45 ?        00:00:00 [oom_reaper]
root          35       2  0 06:45 ?        00:00:00 [kworker/R-writeback]
root          37       2  0 06:45 ?        00:00:00 [kcompactd0]
root          38       2  0 06:45 ?        00:00:00 [ksmd]
root          39       2  0 06:45 ?        00:00:00 [khugepaged]
root          40       2  0 06:45 ?        00:00:00 [kworker/R-kblockd]
root          41       2  0 06:45 ?        00:00:00 [kworker/R-blkcg_punt_bio]
root          42       2  0 06:45 ?        00:00:00 [kworker/R-kintegrityd]
root          43       2  0 06:45 ?        00:00:00 [irq/9-acpi]
root          44       2  0 06:45 ?        00:00:00 [kworker/1:1-mm_percpu_wq]
root          45       2  0 06:45 ?        00:00:00 [kworker/R-tpm_dev_wq]
root          46       2  0 06:45 ?        00:00:00 [kworker/R-ata_sff]
root          47       2  0 06:45 ?        00:00:00 [kworker/R-md]
root          48       2  0 06:45 ?        00:00:00 [kworker/R-md_bitmap]
root          49       2  0 06:45 ?        00:00:00 [kworker/R-edac-poller]
root          50       2  0 06:45 ?        00:00:00 [kworker/R-devfreq_wq]
root          51       2  0 06:45 ?        00:00:00 [watchdogd]
root          52       2  0 06:45 ?        00:00:00 [kworker/R-quota_events_unbound]
root          53       2  0 06:45 ?        00:00:00 [kworker/0:1H-kblockd]
root          54       2  0 06:45 ?        00:00:00 [kswapd0]
root          55       2  0 06:45 ?        00:00:00 [ecryptfs-kthread]
root          56       2  0 06:45 ?        00:00:00 [kworker/R-kthrotld]
root          57       2  0 06:45 ?        00:00:00 [kworker/R-acpi_thermal_pm]
root          58       2  0 06:45 ?        00:00:00 [kworker/R-nvme-wq]
root          59       2  0 06:45 ?        00:00:00 [kworker/R-nvme-reset-wq]
root          60       2  0 06:45 ?        00:00:00 [kworker/R-nvme-delete-wq]
root          61       2  0 06:45 ?        00:00:00 [kworker/R-nvme-auth-wq]
root          64       2  0 06:45 ?        00:00:00 [kworker/R-mld]
root          65       2  0 06:45 ?        00:00:00 [kworker/R-ipv6_addrconf]
root          66       2  0 06:45 ?        00:00:00 [kworker/R-kstrp]
root          68       2  0 06:45 ?        00:00:00 [kworker/u9:0]
root          79       2  0 06:45 ?        00:00:00 [kworker/R-charger_manager]
root          80       2  0 06:45 ?        00:00:00 [kworker/1:1H-kblockd]
root          81       2  0 06:45 ?        00:00:00 [jbd2/nvme0n1p1-8]
root          82       2  0 06:45 ?        00:00:00 [kworker/R-ext4-rsv-conversion]
root         122       1  0 06:46 ?        00:00:00 /usr/lib/systemd/systemd-journald
root         155       2  0 06:46 ?        00:00:00 [kworker/R-kmpathd]
root         156       2  0 06:46 ?        00:00:00 [kworker/R-kmpath_handlerd]
root         172       2  0 06:46 ?        00:00:00 [kworker/u8:4-events_unbound]
root         183       1  0 06:46 ?        00:00:00 /sbin/multipathd -d -s
root         193       1  0 06:46 ?        00:00:00 /usr/lib/systemd/systemd-udevd
root         206       2  0 06:46 ?        00:00:00 [psimon]
root         236       2  0 06:46 ?        00:00:00 [kworker/R-ena]
root         276       2  0 06:46 ?        00:00:00 [jbd2/nvme0n1p16-8]
root         277       2  0 06:46 ?        00:00:00 [kworker/R-ext4-rsv-conversion]
systemd+     328       1  0 06:46 ?        00:00:00 /usr/lib/systemd/systemd-resolved
systemd+     516       1  0 06:46 ?        00:00:00 /usr/lib/systemd/systemd-networkd
root         578       1  0 06:46 ?        00:00:00 /usr/sbin/acpid
root         582       1  0 06:46 ?        00:00:00 /usr/sbin/cron -f -P
message+     583       1  0 06:46 ?        00:00:00 @dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation --syslog-only
root         588       1  0 06:46 ?        00:00:00 /usr/sbin/irqbalance
root         591       1  0 06:46 ?        00:00:00 /usr/bin/python3 /usr/bin/networkd-dispatcher --run-startup-triggers
polkitd      592       1  0 06:46 ?        00:00:00 /usr/lib/polkit-1/polkitd --no-debug
root         597       1  0 06:46 ?        00:00:00 /usr/lib/snapd/snapd
root         600       1  0 06:46 ?        00:00:00 /usr/lib/systemd/systemd-logind
root         603       1  0 06:46 ?        00:00:00 /usr/libexec/udisks2/udisksd
root         663       1  0 06:46 ttyS0    00:00:00 /sbin/agetty -o -p -- \u --keep-baud 115200,57600,38400,9600 - vt220
syslog       685       1  0 06:46 ?        00:00:00 /usr/sbin/rsyslogd -n -iNONE
_chrony      689       1  0 06:46 ?        00:00:00 /usr/sbin/chronyd -F 1
root         716       1  0 06:46 tty1     00:00:00 /sbin/agetty -o -p -- \u --noclear - linux
_chrony      726     689  0 06:46 ?        00:00:00 /usr/sbin/chronyd -F 1
root         732       1  0 06:46 ?        00:00:00 /usr/bin/python3 /usr/share/unattended-upgrades/unattended-upgrade-shutdown --wait-for-signal
root         778       1  0 06:46 ?        00:00:00 /usr/sbin/ModemManager
root         952       1  0 06:46 ?        00:00:00 /snap/amazon-ssm-agent/12322/amazon-ssm-agent
root        1013       1  0 06:46 ?        00:00:00 sshd: /usr/sbin/sshd -D -o AuthorizedKeysCommand /usr/share/ec2-instance-connect/eic_run_authorized_keys
root        1022    1013  0 06:50 ?        00:00:00 sshd: ubuntu [priv]
root        1027       2  0 06:50 ?        00:00:00 [psimon]
ubuntu      1029       1  0 06:50 ?        00:00:00 /usr/lib/systemd/systemd --user
ubuntu      1030    1029  0 06:50 ?        00:00:00 (sd-pam)
ubuntu      1134    1022  0 06:50 ?        00:00:06 sshd: ubuntu@pts/0
ubuntu      1135    1134  0 06:50 pts/0    00:00:00 -bash
root        1181       2  0 06:50 ?        00:00:00 [kworker/R-tls-strp]
root        1241    1135  0 06:55 pts/0    00:00:00 sudo su -
root        1242    1241  0 06:55 pts/1    00:00:00 sudo su -
root        1243    1242  0 06:55 pts/1    00:00:00 su -
root        1244    1243  0 06:55 pts/1    00:00:00 -bash
root        1297    1244  0 07:00 pts/1    00:00:00 less -2 file.txt
root        1320    1244  0 07:02 pts/1    00:00:00 less file.txt
root        1446       2  0 07:14 ?        00:00:00 [kworker/u8:0-flush-259:0]
root        1654       2  0 07:38 ?        00:00:00 [kworker/u8:2-flush-259:0]
root        1663       2  0 07:42 ?        00:00:00 [kworker/0:1-cgroup_free]
root        2163       2  0 07:50 ?        00:00:00 [kworker/0:0-events]
root        2615    1244  0 07:53 pts/1    00:00:00 less file.txt_hardlink
root        2717       2  0 08:00 ?        00:00:00 [kworker/1:2-cgroup_free]
root        2785    1244  0 08:08 pts/1    00:00:00 ps -ef
root@ip-172-31-33-210:/home# ps -aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  1.4  22512 13700 ?        Ss   06:45   0:02 /sbin/init
root           2  0.0  0.0      0     0 ?        S    06:45   0:00 [kthreadd]
root           3  0.0  0.0      0     0 ?        S    06:45   0:00 [pool_workqueue_release]
root           4  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/R-rcu_gp]
root           5  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/R-sync_wq]
root           6  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/R-kvfree_rcu_reclaim]
root           7  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/R-slub_flushwq]
root           8  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/R-netns]
root          10  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/0:0H-events_highpri]
root          13  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/R-mm_percpu_wq]
root          14  0.0  0.0      0     0 ?        S    06:45   0:00 [ksoftirqd/0]
root          15  0.0  0.0      0     0 ?        I    06:45   0:00 [rcu_sched]
root          16  0.0  0.0      0     0 ?        S    06:45   0:00 [rcu_exp_par_gp_kthread_worker/0]
root          17  0.0  0.0      0     0 ?        S    06:45   0:00 [rcu_exp_gp_kthread_worker]
root          18  0.0  0.0      0     0 ?        S    06:45   0:00 [migration/0]
root          19  0.0  0.0      0     0 ?        S    06:45   0:00 [idle_inject/0]
root          20  0.0  0.0      0     0 ?        S    06:45   0:00 [cpuhp/0]
root          21  0.0  0.0      0     0 ?        S    06:45   0:00 [cpuhp/1]
root          22  0.0  0.0      0     0 ?        S    06:45   0:00 [idle_inject/1]
root          23  0.0  0.0      0     0 ?        S    06:45   0:00 [migration/1]
root          24  0.0  0.0      0     0 ?        S    06:45   0:00 [ksoftirqd/1]
root          26  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/1:0H-events_highpri]
root          27  0.0  0.0      0     0 ?        S    06:45   0:00 [kdevtmpfs]
root          28  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/R-inet_frag_wq]
root          29  0.0  0.0      0     0 ?        I    06:45   0:00 [rcu_tasks_rude_kthread]
root          30  0.0  0.0      0     0 ?        I    06:45   0:00 [rcu_tasks_trace_kthread]
root          31  0.0  0.0      0     0 ?        S    06:45   0:00 [kauditd]
root          32  0.0  0.0      0     0 ?        S    06:45   0:00 [khungtaskd]
root          34  0.0  0.0      0     0 ?        S    06:45   0:00 [oom_reaper]
root          35  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/R-writeback]
root          37  0.0  0.0      0     0 ?        S    06:45   0:00 [kcompactd0]
root          38  0.0  0.0      0     0 ?        SN   06:45   0:00 [ksmd]
root          39  0.0  0.0      0     0 ?        SN   06:45   0:00 [khugepaged]
root          40  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/R-kblockd]
root          41  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/R-blkcg_punt_bio]
root          42  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/R-kintegrityd]
root          43  0.0  0.0      0     0 ?        S    06:45   0:00 [irq/9-acpi]
root          44  0.0  0.0      0     0 ?        I    06:45   0:00 [kworker/1:1-events]
root          45  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/R-tpm_dev_wq]
root          46  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/R-ata_sff]
root          47  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/R-md]
root          48  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/R-md_bitmap]
root          49  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/R-edac-poller]
root          50  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/R-devfreq_wq]
root          51  0.0  0.0      0     0 ?        S    06:45   0:00 [watchdogd]
root          52  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/R-quota_events_unbound]
root          53  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/0:1H-kblockd]
root          54  0.0  0.0      0     0 ?        S    06:45   0:00 [kswapd0]
root          55  0.0  0.0      0     0 ?        S    06:45   0:00 [ecryptfs-kthread]
root          56  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/R-kthrotld]
root          57  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/R-acpi_thermal_pm]
root          58  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/R-nvme-wq]
root          59  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/R-nvme-reset-wq]
root          60  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/R-nvme-delete-wq]
root          61  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/R-nvme-auth-wq]
root          64  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/R-mld]
root          65  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/R-ipv6_addrconf]
root          66  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/R-kstrp]
root          68  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/u9:0]
root          79  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/R-charger_manager]
root          80  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/1:1H-kblockd]
root          81  0.0  0.0      0     0 ?        S    06:45   0:00 [jbd2/nvme0n1p1-8]
root          82  0.0  0.0      0     0 ?        I<   06:45   0:00 [kworker/R-ext4-rsv-conversion]
root         122  0.0  1.5  50436 14724 ?        S<s  06:46   0:00 /usr/lib/systemd/systemd-journald
root         155  0.0  0.0      0     0 ?        I<   06:46   0:00 [kworker/R-kmpathd]
root         156  0.0  0.0      0     0 ?        I<   06:46   0:00 [kworker/R-kmpath_handlerd]
root         172  0.0  0.0      0     0 ?        I    06:46   0:00 [kworker/u8:4-events_unbound]
root         183  0.0  2.9 288960 27292 ?        SLsl 06:46   0:00 /sbin/multipathd -d -s
root         193  0.0  0.8  26492  8384 ?        Ss   06:46   0:00 /usr/lib/systemd/systemd-udevd
root         206  0.0  0.0      0     0 ?        S    06:46   0:00 [psimon]
root         236  0.0  0.0      0     0 ?        I<   06:46   0:00 [kworker/R-ena]
root         276  0.0  0.0      0     0 ?        S    06:46   0:00 [jbd2/nvme0n1p16-8]
root         277  0.0  0.0      0     0 ?        I<   06:46   0:00 [kworker/R-ext4-rsv-conversion]
systemd+     328  0.0  1.3  21604 12916 ?        Ss   06:46   0:00 /usr/lib/systemd/systemd-resolved
systemd+     516  0.0  1.0  22420  9896 ?        Ss   06:46   0:00 /usr/lib/systemd/systemd-networkd
root         578  0.0  0.2   2728  2020 ?        Ss   06:46   0:00 /usr/sbin/acpid
root         582  0.0  0.3   7232  2824 ?        Ss   06:46   0:00 /usr/sbin/cron -f -P
message+     583  0.0  0.6   9808  5708 ?        Ss   06:46   0:00 @dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation --sysl
root         588  0.0  0.4  82928  4624 ?        Ssl  06:46   0:00 /usr/sbin/irqbalance
root         591  0.0  2.2  32424 20688 ?        Ss   06:46   0:00 /usr/bin/python3 /usr/bin/networkd-dispatcher --run-startup-triggers
polkitd      592  0.0  1.0 383712 10044 ?        Ssl  06:46   0:00 /usr/lib/polkit-1/polkitd --no-debug
root         597  0.0  4.0 1923348 37396 ?       Ssl  06:46   0:00 /usr/lib/snapd/snapd
root         600  0.0  0.9  18000  8900 ?        Ss   06:46   0:00 /usr/lib/systemd/systemd-logind
root         603  0.0  1.4 469004 13900 ?        Ssl  06:46   0:00 /usr/libexec/udisks2/udisksd
root         663  0.0  0.2   6156  2228 ttyS0    Ss+  06:46   0:00 /sbin/agetty -o -p -- \u --keep-baud 115200,57600,38400,9600 - vt220
syslog       685  0.0  0.6 222516  6212 ?        Ssl  06:46   0:00 /usr/sbin/rsyslogd -n -iNONE
_chrony      689  0.0  0.4  19412  3888 ?        S    06:46   0:00 /usr/sbin/chronyd -F 1
root         716  0.0  0.2   6112  2108 tty1     Ss+  06:46   0:00 /sbin/agetty -o -p -- \u --noclear - linux
_chrony      726  0.0  0.2  11084  2432 ?        S    06:46   0:00 /usr/sbin/chronyd -F 1
root         732  0.0  2.4 110020 22792 ?        Ssl  06:46   0:00 /usr/bin/python3 /usr/share/unattended-upgrades/unattended-upgrade-shutdown --wait-for-si
root         778  0.0  1.3 318156 12908 ?        Ssl  06:46   0:00 /usr/sbin/ModemManager
root         952  0.0  2.1 1830616 20364 ?       Ssl  06:46   0:00 /snap/amazon-ssm-agent/12322/amazon-ssm-agent
root        1013  0.0  0.8  12032  8176 ?        Ss   06:46   0:00 sshd: /usr/sbin/sshd -D -o AuthorizedKeysCommand /usr/share/ec2-instance-connect/eic_run_
root        1022  0.0  1.1  14748 10628 ?        Ss   06:50   0:00 sshd: ubuntu [priv]
root        1027  0.0  0.0      0     0 ?        S    06:50   0:00 [psimon]
ubuntu      1029  0.0  1.2  20264 11472 ?        Ss   06:50   0:00 /usr/lib/systemd/systemd --user
ubuntu      1030  0.0  0.3  21164  3592 ?        S    06:50   0:00 (sd-pam)
ubuntu      1134  0.1  0.7  15004  7172 ?        S    06:50   0:06 sshd: ubuntu@pts/0
ubuntu      1135  0.0  0.5   9200  5544 pts/0    Ss   06:50   0:00 -bash
root        1181  0.0  0.0      0     0 ?        I<   06:50   0:00 [kworker/R-tls-strp]
root        1241  0.0  0.7  17140  7044 pts/0    S+   06:55   0:00 sudo su -
root        1242  0.0  0.2  17140  2524 pts/1    Ss   06:55   0:00 sudo su -
root        1243  0.0  0.4   9816  4416 pts/1    S    06:55   0:00 su -
root        1244  0.0  0.6   9200  5612 pts/1    S    06:55   0:00 -bash
root        1297  0.0  0.2   6508  2724 pts/1    T    07:00   0:00 less -2 file.txt
root        1320  0.0  0.2   6508  2720 pts/1    T    07:02   0:00 less file.txt
root        1446  0.0  0.0      0     0 ?        I    07:14   0:00 [kworker/u8:0-events_unbound]
root        1654  0.0  0.0      0     0 ?        I    07:38   0:00 [kworker/u8:2-events_unbound]
root        1663  0.0  0.0      0     0 ?        I    07:42   0:00 [kworker/0:1-cgroup_free]
root        2163  0.0  0.0      0     0 ?        I    07:50   0:00 [kworker/0:0-events]
root        2615  0.0  0.2   6508  2720 pts/1    T    07:53   0:00 less file.txt_hardlink
root        2717  0.0  0.0      0     0 ?        I    08:00   0:00 [kworker/1:2-cgroup_free]
root        2786  0.0  0.5  12628  5352 pts/1    R+   08:08   0:00 ps -aux
root@ip-172-31-33-210:/home#root@ip-172-31-33-210:/home# top
top - 08:09:57 up  1:23,  1 user,  load average: 0.00, 0.00, 0.00
Tasks: 113 total,   1 running, 109 sleeping,   3 stopped,   0 zombie
%Cpu(s):  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
MiB Mem :    911.5 total,    276.7 free,    364.4 used,    428.8 buff/cache
MiB Swap:      0.0 total,      0.0 free,      0.0 used.    547.0 avail Mem

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
      1 root      20   0   22512  13700   9520 S   0.0   1.5   0:02.02 systemd
      2 root      20   0       0      0      0 S   0.0   0.0   0:00.00 kthreadd
      3 root      20   0       0      0      0 S   0.0   0.0   0:00.00 pool_workqueue_release
      4 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 kworker/R-rcu_gp
      5 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 kworker/R-sync_wq
      6 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 kworker/R-kvfree_rcu_reclaim
      7 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 kworker/R-slub_flushwq
      8 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 kworker/R-netns
     10 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 kworker/0:0H-events_highpri
     13 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 kworker/R-mm_percpu_wq
     14 root      20   0       0      0      0 S   0.0   0.0   0:00.01 ksoftirqd/0
     15 root      20   0       0      0      0 I   0.0   0.0   0:00.23 rcu_sched
     16 root      20   0       0      0      0 S   0.0   0.0   0:00.00 rcu_exp_par_gp_kthread_worker/0
     17 root      20   0       0      0      0 S   0.0   0.0   0:00.00 rcu_exp_gp_kthread_worker
     18 root      rt   0       0      0      0 S   0.0   0.0   0:00.02 migration/0
     19 root     -51   0       0      0      0 S   0.0   0.0   0:00.00 idle_inject/0
     20 root      20   0       0      0      0 S   0.0   0.0   0:00.00 cpuhp/0
     21 root      20   0       0      0      0 S   0.0   0.0   0:00.00 cpuhp/1
     22 root     -51   0       0      0      0 S   0.0   0.0   0:00.00 idle_inject/1
     23 root      rt   0       0      0      0 S   0.0   0.0   0:00.05 migration/1
     24 root      20   0       0      0      0 S   0.0   0.0   0:00.02 ksoftirqd/1
     26 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 kworker/1:0H-events_highpri
     27 root      20   0       0      0      0 S   0.0   0.0   0:00.00 kdevtmpfs
     28 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 kworker/R-inet_frag_wq
     29 root      20   0       0      0      0 I   0.0   0.0   0:00.00 rcu_tasks_rude_kthread
     30 root      20   0       0      0      0 I   0.0   0.0   0:00.00 rcu_tasks_trace_kthread
     31 root      20   0       0      0      0 S   0.0   0.0   0:00.00 kauditd
     32 root      20   0       0      0      0 S   0.0   0.0   0:00.00 khungtaskd
     34 root      20   0       0      0      0 S   0.0   0.0   0:00.00 oom_reaper
     35 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 kworker/R-writeback
     37 root      20   0       0      0      0 S   0.0   0.0   0:00.17 kcompactd0
     38 root      25   5       0      0      0 S   0.0   0.0   0:00.00 ksmd
     39 root      39  19       0      0      0 S   0.0   0.0   0:00.00 khugepaged
     40 root       0 -20       0      0      0 I   0.0   0.0   0:00.00 kworker/R-kblockd
[4]+  Stopped                 top
root@ip-172-31-33-210:/home#root@ip-172-31-33-210:/home# kill 40
root@ip-172-31-33-210:/home# kill  -g 40
-bash: kill: g: invalid signal specification
root@ip-172-31-33-210:/home#root@ip-172-31-33-210:/home# vi health.sh
root@ip-172-31-33-210:/home# chmod 744 health.sh
root@ip-172-31-33-210:/home# ./health.sh
===============================
   SYSTEM HEALTH CHECK REPORT
===============================
Date: Mon Apr 13 08:13:20 UTC 2026
Hostname: ip-172-31-33-210

---- CPU Usage ----
CPU Usage: 8.6%

---- Memory Usage ----
               total        used        free      shared  buff/cache   available
Mem:           911Mi       364Mi       276Mi       2.7Mi       429Mi       547Mi
Swap:             0B          0B          0B

---- Disk Usage ----
Filesystem       Size  Used Avail Use% Mounted on
/dev/root        6.8G  1.9G  4.9G  28% /
tmpfs            456M     0  456M   0% /dev/shm
tmpfs            183M  876K  182M   1% /run
tmpfs            5.0M     0  5.0M   0% /run/lock
efivarfs         128K  3.6K  120K   3% /sys/firmware/efi/efivars
/dev/nvme0n1p16  881M   94M  726M  12% /boot
/dev/nvme0n1p15  105M  6.2M   99M   6% /boot/efi
tmpfs             92M   12K   92M   1% /run/user/1000

---- System Uptime ----
 08:13:21 up  1:27,  1 user,  load average: 0.00, 0.00, 0.00

---- Load Average ----
0.00 0.00 0.00 1/155 2808

---- Top 5 Memory Consuming Processes ----
    PID    PPID CMD                         %MEM %CPU
    597       1 /usr/lib/snapd/snapd         4.0  0.0
    183       1 /sbin/multipathd -d -s       2.9  0.0
    732       1 /usr/bin/python3 /usr/share  2.4  0.0
    591       1 /usr/bin/python3 /usr/bin/n  2.2  0.0
    952       1 /snap/amazon-ssm-agent/1232  2.1  0.0

---- Network Status ----
    inet 127.0.0.1/8 scope host lo
    inet6 ::1/128 scope host noprefixroute
    inet 172.31.33.210/20 metric 100 brd 172.31.47.255 scope global dynamic ens5
    inet6 fe80::29:abff:fe52:61d3/64 scope link

===============================
 Health Check Completed
===============================
root@ip-172-31-33-210:/home# cat health.sh
#!/bin/bash

echo "==============================="
echo "   SYSTEM HEALTH CHECK REPORT  "
echo "==============================="
echo "Date: $(date)"
echo "Hostname: $(hostname)"
echo ""

# CPU Usage
echo "---- CPU Usage ----"
top -bn1 | grep "Cpu(s)" | awk '{print "CPU Usage: " $2 + $4 "%"}'
echo ""

# Memory Usage
echo "---- Memory Usage ----"
free -h
echo ""

# Disk Usage
echo "---- Disk Usage ----"
df -h
echo ""

# System Uptime
echo "---- System Uptime ----"
uptime
echo ""

# Load Average
echo "---- Load Average ----"
cat /proc/loadavg
echo ""

# Running Processes
echo "---- Top 5 Memory Consuming Processes ----"
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head -n 6
echo ""

# Network Status
echo "---- Network Status ----"
ip a | grep inet
echo ""

echo "==============================="
echo " Health Check Completed "
echo "==============================="
root@ip-172-31-33-210:/home#root@ip-172-31-33-210:/home# ls
dir1  dir2  file.txt_hardlink  health.sh  nohup.out  ritik  text_soft.txt  touch.txt  touch_hardlink.txt  touch_soft.txt  ubuntu
root@ip-172-31-33-210:/home# nohup ./health.sh &
[5] 2833
root@ip-172-31-33-210:/home# nohup: ignoring input and appending output to 'nohup.out'
^C
[5]   Done                    nohup ./health.sh
root@ip-172-31-33-210:/home# ls
dir1  dir2  file.txt_hardlink  health.sh  nohup.out  ritik  text_soft.txt  touch.txt  touch_hardlink.txt  touch_soft.txt  ubuntu
root@ip-172-31-33-210:/home# cat nohup.out
===============================
   SYSTEM HEALTH CHECK REPORT
===============================
Date: Mon Apr 13 08:16:54 UTC 2026
Hostname: ip-172-31-33-210

---- CPU Usage ----
CPU Usage: 0%

---- Memory Usage ----
               total        used        free      shared  buff/cache   available
Mem:           911Mi       363Mi       276Mi       2.7Mi       429Mi       547Mi
Swap:             0B          0B          0B

---- Disk Usage ----
Filesystem       Size  Used Avail Use% Mounted on
/dev/root        6.8G  1.9G  4.9G  28% /
tmpfs            456M     0  456M   0% /dev/shm
tmpfs            183M  876K  182M   1% /run
tmpfs            5.0M     0  5.0M   0% /run/lock
efivarfs         128K  3.6K  120K   3% /sys/firmware/efi/efivars
/dev/nvme0n1p16  881M   94M  726M  12% /boot
/dev/nvme0n1p15  105M  6.2M   99M   6% /boot/efi
tmpfs             92M   12K   92M   1% /run/user/1000

---- System Uptime ----
 08:16:55 up  1:30,  1 user,  load average: 0.00, 0.00, 0.00

---- Load Average ----
0.00 0.00 0.00 1/154 2842

---- Top 5 Memory Consuming Processes ----
    PID    PPID CMD                         %MEM %CPU
    597       1 /usr/lib/snapd/snapd         4.0  0.0
    183       1 /sbin/multipathd -d -s       2.9  0.0
    732       1 /usr/bin/python3 /usr/share  2.4  0.0
    591       1 /usr/bin/python3 /usr/bin/n  2.2  0.0
    952       1 /snap/amazon-ssm-agent/1232  2.1  0.0

---- Network Status ----
    inet 127.0.0.1/8 scope host lo
    inet6 ::1/128 scope host noprefixroute
    inet 172.31.33.210/20 metric 100 brd 172.31.47.255 scope global dynamic ens5
    inet6 fe80::29:abff:fe52:61d3/64 scope link

===============================
 Health Check Completed
===============================
root@ip-172-31-33-210:/home#root@ip-172-31-33-210:/home# vmstat
procs -----------memory---------- ---swap-- -----io---- -system-- -------cpu-------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st gu
 2  0      0 283340  20048 419580    0    0    60    61  102    0  0  0 100  0  0  0
root@ip-172-31-33-210:/home# vmstat 3
procs -----------memory---------- ---swap-- -----io---- -system-- -------cpu-------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st gu
 2  0      0 283340  20048 419620    0    0    60    61  102    0  0  0 100  0  0  0
 0  0      0 283340  20048 419620    0    0     0     0  138   99  0  0 100  0  0  0
 0  0      0 283340  20048 419620    0    0     0     0   22   27  0  0 100  0  0  0
 0  0      0 283340  20048 419620    0    0     0     0   29   25  0  0 100  0  0  0
 0  0      0 283340  20048 419620    0    0     0     0   27   30  0  0 100  0  0  0
 0  0      0 283340  20048 419620    0    0     0     0   18   20  0  0 100  0  0  0
 0  0      0 283340  20048 419620    0    0     0     0   24   25  0  0 100  0  0  0
 0  0      0 283340  20056 419612    0    0     0     4   27   27  0  0 100  0  0  0
 0  0      0 283340  20056 419620    0    0     0     0   27   30  0  0 100  0  0  0
 0  0      0 283340  20056 419620    0    0     0     0   25   25  0  0 100  0  0  0
 0  0      0 283340  20056 419620    0    0     0     0   24   24  0  0 100  0  0  0


======user & file Management======
root@ip-172-31-33-210:/home#root@ip-172-31-33-210:/home# uname
Linux
root@ip-172-31-33-210:/home# uname -a
Linux ip-172-31-33-210 6.17.0-1007-aws #7~24.04.1-Ubuntu SMP Thu Jan 22 21:04:49 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
root@ip-172-31-33-210:/home# uptime
 08:22:09 up  1:36,  1 user,  load average: 0.00, 0.00, 0.00
root@ip-172-31-33-210:/home# date
Mon Apr 13 08:22:23 UTC 2026
root@ip-172-31-33-210:/home# who
ubuntu   pts/0        2026-04-13 06:50 (223.185.36.26)
ubuntu   pts/1        2026-04-13 06:55 (223.185.36.26)
root@ip-172-31-33-210:/home# whoami
root
root@ip-172-31-33-210:/home# which
root@ip-172-31-33-210:/home# which ls
/usr/bin/ls
root@ip-172-31-33-210:/home# which sudo
/usr/bin/sudo
root@ip-172-31-33-210:/home# which cat
/usr/bin/cat
root@ip-172-31-33-210:/home#root@ip-172-31-33-210:/home# sudo su -
root@ip-172-31-33-210:~# sudo apt update
Hit:1 http://ap-south-1.ec2.archive.ubuntu.com/ubuntu noble InRelease
Get:2 http://ap-south-1.ec2.archive.ubuntu.com/ubuntu noble-updates InRelease [126 kB]
Get:3 http://ap-south-1.ec2.archive.ubuntu.com/ubuntu noble-backports InRelease [126 kB]
Get:4 http://ap-south-1.ec2.archive.ubuntu.com/ubuntu noble/universe amd64 Packages [15.0 MB]
root@ip-172-31-33-210:~# id
uid=0(root) gid=0(root) groups=0(root)
root@ip-172-31-33-210:/home# ls
dir1  dir2  file.txt_hardlink  health.sh  nohup.out  ritik  text_soft.txt  touch.txt  touch_hardlink.txt  touch_soft.txt  ubuntu
root@ip-172-31-33-210:/home# apt
apt 2.8.3 (amd64)
Usage: apt [options] command

apt is a commandline package manager and provides commands for
searching and managing as well as querying information about packages.
It provides the same functionality as the specialized APT tools,
like apt-get and apt-cache, but enables options more suitable for
interactive use by default.

Most used commands:
  list - list packages based on package names
  search - search in package descriptions
  show - show package details
  install - install packages
  reinstall - reinstall packages
  remove - remove packages
  autoremove - automatically remove all unused packages
  update - update list of available packages
  upgrade - upgrade the system by installing/upgrading packages
  full-upgrade - upgrade the system by removing/installing/upgrading packages
  edit-sources - edit the source information file
  satisfy - satisfy dependency strings

See apt(8) for more information about the available commands.
Configuration options and syntax is detailed in apt.conf(5).
Information about how to configure sources can be found in sources.list(5).
Package and version choices can be expressed via apt_preferences(5).
Security details are available in apt-secure(8).
                                        This APT has Super Cow Powers.
root@ip-172-31-33-210:/home# apt update
Hit:1 http://ap-south-1.ec2.archive.ubuntu.com/ubuntu noble InRelease
Hit:2 http://ap-south-1.ec2.archive.ubuntu.com/ubuntu noble-updates InRelease
Hit:3 http://ap-south-1.ec2.archive.ubuntu.com/ubuntu noble-backports InRelease
Hit:4 http://security.ubuntu.com/ubuntu noble-security InRelease
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
44 packages can be upgraded. Run 'apt list --upgradable' to see them.
root@ip-172-31-33-210:/home# useradd ritik
root@ip-172-31-33-210:/home# cat /etc/passwd
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
polkitd:x:989:989:User for polkitd:/:/usr/sbin/nologin
ec2-instance-connect:x:109:65534::/nonexistent:/usr/sbin/nologin
_chrony:x:110:112:Chrony daemon,,,:/var/lib/chrony:/usr/sbin/nologin
ubuntu:x:1000:1000:Ubuntu:/home/ubuntu:/bin/bash
ritik:x:1001:1001::/home/ritik:/bin/sh
root@ip-172-31-33-210:/home#root@ip-172-31-33-210:/home# useradd  -m misty
root@ip-172-31-33-210:/home# ls
dir1  dir2  file.txt_hardlink  health.sh  misty  nohup.out  ritik  text_soft.txt  touch.txt  touch_hardlink.txt  touch_soft.txt  ubuntu
root@ip-172-31-33-210:/home#root@ip-172-31-33-210:/home# ls
dir1  dir2  file.txt_hardlink  health.sh  misty  nohup.out  ritik  text_soft.txt  touch.txt  touch_hardlink.txt  touch_soft.txt  ubuntu
root@ip-172-31-33-210:/home# su ritik
$ ls
dir1  dir2  file.txt_hardlink  health.sh  misty  nohup.out  ritik  text_soft.txt  touch.txt  touch_hardlink.txt  touch_soft.txt  ubuntu
$ exit
root@ip-172-31-33-210:/home# passwd ritik
New password:
Retype new password:
passwd: password updated successfully
root@ip-172-31-33-210:/home# userdel ritik
root@ip-172-31-33-210:/home# cat /etc/passwd
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
root@ip-172-31-33-210:/home# ls
dir1  dir2  file.txt_hardlink  health.sh  nohup.out  ritik  text_soft.txt  touch.txt  touch_hardlink.txt  touch_soft.txt  ubuntu
root@ip-172-31-33-210:/home# groupadd devops
root@ip-172-31-33-210:/home# cat /etc/group
root:x:0:
daemon:x:1:
bin:x:2:
netdev:x:111:
_chrony:x:112:
ubuntu:x:1000:
devops:x:1001:
root@ip-172-31-33-210:/home#
root@ip-172-31-33-210:/home# umask
0022
root@ip-172-31-33-210:/home# ls -l
total 36
drwxr-xr-x 2 root   root   4096 Apr 13 07:56 dir1
drwxr-xr-x 2 root   root   4096 Apr 13 06:56 dir2
-rw-r--r-- 1 root   root     71 Apr 13 07:57 file.txt_hardlink
-rwxr--r-- 1 root   root    876 Apr 13 08:13 health.sh
-rw------- 1 root   root   1720 Apr 13 08:16 nohup.out
drwxr-xr-x 2 root   root   4096 Apr 13 07:48 ritik
lrwxrwxrwx 1 root   root      8 Apr 13 07:15 text_soft.txt -> text.txt
-rw-r--r-- 2 root   root    129 Apr 13 08:02 touch.txt
-rw-r--r-- 2 root   root    129 Apr 13 08:02 touch_hardlink.txt
lrwxrwxrwx 1 root   root      9 Apr 13 07:59 touch_soft.txt -> touch.txt
drwxr-x--- 4 ubuntu ubuntu 4096 Apr 13 08:35 ubuntu
root@ip-172-31-33-210:/home# chmod 755 nohup.out
root@ip-172-31-33-210:/home# ls -l nohup.out
-rwxr-xr-x 1 root root 1720 Apr 13 08:16 nohup.out
root@ip-172-31-33-210:/home#
root@ip-172-31-33-210:/home# ls -l
total 36
drwxr-xr-x 2 root   root   4096 Apr 13 07:56 dir1
drwxr-xr-x 2 root   root   4096 Apr 13 06:56 dir2
-rw-r--r-- 1 root   root     71 Apr 13 07:57 file.txt_hardlink
-rwxr--r-- 1 root   root    876 Apr 13 08:13 health.sh
-rwxr-xr-x 1 root   root   1720 Apr 13 08:16 nohup.out
drwxr-xr-x 2 root   root   4096 Apr 13 07:48 ritik
lrwxrwxrwx 1 root   root      8 Apr 13 07:15 text_soft.txt -> text.txt
-rw-r--r-- 2 root   root    129 Apr 13 08:02 touch.txt
-rw-r--r-- 2 root   root    129 Apr 13 08:02 touch_hardlink.txt
lrwxrwxrwx 1 root   root      9 Apr 13 07:59 touch_soft.txt -> touch.txt
drwxr-x--- 4 ubuntu ubuntu 4096 Apr 13 08:35 ubuntu
root@ip-172-31-33-210:/home# chown  ritik touch.txt
root@ip-172-31-33-210:/home# ls -l
total 36
drwxr-xr-x 2 root   root   4096 Apr 13 07:56 dir1
drwxr-xr-x 2 root   root   4096 Apr 13 06:56 dir2
-rw-r--r-- 1 root   root     71 Apr 13 07:57 file.txt_hardlink
-rwxr--r-- 1 root   root    876 Apr 13 08:13 health.sh
-rwxr-xr-x 1 root   root   1720 Apr 13 08:16 nohup.out
drwxr-xr-x 2 root   root   4096 Apr 13 07:48 ritik
lrwxrwxrwx 1 root   root      8 Apr 13 07:15 text_soft.txt -> text.txt
-rw-r--r-- 2 ritik  root    129 Apr 13 08:02 touch.txt
-rw-r--r-- 2 ritik  root    129 Apr 13 08:02 touch_hardlink.txt
lrwxrwxrwx 1 root   root      9 Apr 13 07:59 touch_soft.txt -> touch.txt
drwxr-x--- 4 ubuntu ubuntu 4096 Apr 13 08:35 ubuntu
root@ip-172-31-33-210:/home#
root@ip-172-31-33-210:/home# chgrp devops touch.txt
root@ip-172-31-33-210:/home# ls -l
total 36
drwxr-xr-x 2 root   root   4096 Apr 13 07:56 dir1
drwxr-xr-x 2 root   root   4096 Apr 13 06:56 dir2
-rw-r--r-- 1 root   root     71 Apr 13 07:57 file.txt_hardlink
-rwxr--r-- 1 root   root    876 Apr 13 08:13 health.sh
-rwxr-xr-x 1 root   root   1720 Apr 13 08:16 nohup.out
drwxr-xr-x 2 root   root   4096 Apr 13 07:48 ritik
lrwxrwxrwx 1 root   root      8 Apr 13 07:15 text_soft.txt -> text.txt
-rw-r--r-- 2 ritik  devops  129 Apr 13 08:02 touch.txt
-rw-r--r-- 2 ritik  devops  129 Apr 13 08:02 touch_hardlink.txt
lrwxrwxrwx 1 root   root      9 Apr 13 07:59 touch_soft.txt -> touch.txt
drwxr-x--- 4 ubuntu ubuntu 4096 Apr 13 08:35 ubuntu
