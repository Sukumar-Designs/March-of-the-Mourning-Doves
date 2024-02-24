extends Node

var max_items_per_type = 3
var inventory_items = {
	"pine":0,
	"acorn":0,
	"pebble":0,
	"seed":0
} 

func try_pick_up_item(item):
	""" This function controls trying to pick up an item """
	if inventory_items[item.resource_type] <= max_items_per_type:
		inventory_items[item.resource_type] = inventory_items[item.resource_type] + 1
		return true
	else:
		return false
		
func try_deposite_item(depository):
	for item in inventory_items:
		var amount_left_over = depository.try_deposite_item(item, inventory_items[item])
		# Assign amount left over to inventory
		inventory_items[item] = amount_left_over
