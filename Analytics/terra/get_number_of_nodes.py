number_of_nodes = input("Please input the number of nodes: ")
print("Noted, will create", number_of_nodes, "nodes.")

f = open("number_of_nodes.txt", "w")
f.write(number_of_nodes)
f.close()
