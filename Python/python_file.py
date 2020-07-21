
import sys

a = len(sys.argv)
b = sys.argv[1:]
filepath = "D:\\test.txt"  
with open(filepath, 'w') as f:
    f.write('Hello, world!\n')
    f.write(str(a)+'  '+b[0])
print "======read file======="
with open(filepath,'r') as f:
    print(f.read())
print "======readline file======="
with open(filepath,'r') as f:    
    print(f.readline())
print "======readlines file======="
with open(filepath,'r') as f:
    list1 = f.readlines()
for i in range(0, len(list1)):
    list1[i] = list1[i].rstrip('\n')
    print list1[i],