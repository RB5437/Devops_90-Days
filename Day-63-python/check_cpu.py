import  psutil  #import the lib from pypi



def check_cpu_threshold():
    check_cpu_threshold = int(input("enter the cpu threshold"))

    current_cpu = psutil.cpu_percent(interval=1)
    print("current cpu %: ",current_cpu)
    if current_cpu > check_cpu_threshold:
        print("cpu alert email sent ...")
    else:
        print("cpu in safe state")
        
check_cpu_threshold()
