class_name WeightedTable

var items: Array[Dictionary]
var weight_sum = 0

func add_item(name: String, item, weight: int):
	items.append({"name": name , "item": item, "weight": weight})
	weight_sum += weight


func pick_item():
	print(items)
	var chosen_weight = randi_range(1, weight_sum)
	var iteration_sum = 0
	for item in items: 
		iteration_sum += item.weight
		if chosen_weight <= iteration_sum:
			return item.item


func change_item_weight(name: String, new_weight: int):
	for item in items: 
		if item.name == name:
			item.weight = new_weight
	
