access_key = input("Please input the access key: ")

f = open("access_key.txt", "w")
f.write(access_key)
f.close()
