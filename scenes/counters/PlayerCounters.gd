extends Node

var money: int = 0;
var exp: int = 0;

func add_money():
	money+=1*get_randog_factor(1, 5)
	
	
func add_exp():
	exp+=(100 * get_randog_factor(0.1, 2))
	
	
func minus_money(sum: int):
	money-=sum
	
	
func minus_exp(sum: int):
	exp-=sum


func get_randog_factor(min:int, max: int):
	var rng = RandomNumberGenerator.new()
	return rng.randf_range(min, max)
