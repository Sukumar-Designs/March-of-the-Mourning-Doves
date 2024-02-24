extends Node

@export var max_items_per_type = 10
var inventory_items = {
	"pine":0,
	"acorn":0,
	"pebble":0,
	"seed":0
} 

func try_deposite_item(item, amount):
	var item_space_occupied = inventory_items[item]
	# Check the amount of space
	# (Amount of space left) - Amount to be deposited 
	var item_total = (item_space_occupied + amount) #- max_items_per_type
	var item_overflow 
	# If item_total is at most the max items
	# there's space left and the amount can be added
	if item_total <= max_items_per_type:
		inventory_items[item] += amount
		item_overflow = 0
	# Otherwise, max out inventory and return quantanty exceeded
	else:
		inventory_items[item] = max_items_per_type
		# Get the number of items in excess 
		item_overflow = item_total - max_items_per_type
	return item_overflow
