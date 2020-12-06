namenode_ip = open("namenode_ip.txt", "r").read()
f = open("namenode_ip.txt", "w")
f.write((namenode_ip.rstrip()).strip("\""))
f.close()

namenode_ip = open("namenode_ip_priv.txt", "r").read()
f = open("namenode_ip_priv.txt", "w")
f.write((namenode_ip.rstrip()).strip("\""))
f.close()



lines = open("datanode_ip.txt", "r").readlines()
f = open("datanode_ip.txt", "w")
for i in range(len(lines)-1):
    f.write((lines[i].strip()).strip("\""))
    f.write("\n")
f.write((lines[len(lines)-1].strip()).strip("\""))
f.close()


lines = open("datanode_ip_priv.txt", "r").readlines()
f = open("datanode_ip_priv.txt", "w")
for i in range(len(lines)-1):
    f.write((lines[i].strip()).strip("\""))
    f.write("\n")
f.write((lines[len(lines)-1].strip()).strip("\""))
f.close()