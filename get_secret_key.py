secret_key = input("Please input the secret key: ")

f = open("secret_key.txt", "w")
f.write(secret_key)
f.close()
