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
	if inventory_items[item.resource_type] < max_items_per_type:
		inventory_items[item.resource_type] = inventory_items[item.resource_type] + 1
		print_debug(inventory_items)
		return true
	else:
		return false
