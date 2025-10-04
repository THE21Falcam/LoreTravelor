extends Node
const MaxSlot = 15
var NOFund = false
var inventory = {}

func add_item(names,amount):
	for item in inventory:
		if inventory[item][0] == names:
			inventory[item][1] += amount
			NOFund = false
			return
	for i in range(MaxSlot):
		if inventory.has(i) == false:
			inventory[i] = [names, amount]
			return

func remove_item(names,amount):
	for item in inventory:
		if inventory[item][0] == names:
			inventory[item][1] -= amount
			NOFund = false
			if inventory[item][1] <= 0:
				inventory[item][1] = 0
				NOFund = true
			return
