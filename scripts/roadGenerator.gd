extends Node

var straightTile = preload("res://scenes/straightTile.tscn")
var cornerTile = preload("res://scenes/cornerTile.tscn")

var newestBranch
var batchNum = 0
var corner = 50
var rightCornerCount = 0
var parentList = []

# npc cars, wider highways (sometimes), gas stations, police, surface stuff, bg music, sound effects, 
# carpark that you spawn in facing the way you are forced to spawn in to make it act like im not bad at coding :)

@onready var car: Node2D = $Car

func _ready():
	genBatch(10)

func _process(delta: float) -> void:
	if newestBranch != null:
		if (newestBranch.global_position - car.transform.origin).length() < 1500:
			batchNum += 1
			genBatch(50)
			
			if batchNum > 5:
				parentList.pop_back().queue_free()

func newTile(parent):
	if newestBranch == null:
		var tile = straightTile.instantiate()
		parent.add_child.call_deferred(tile)
		tile.global_position = car.global_position
		newestBranch = tile.get_child(0).get_child(0)
	else:
		if randi_range(1, 50) > corner:
			corner = 50
			var tile = cornerTile.instantiate()
			parent.add_child.call_deferred(tile)
			print(rightCornerCount)
			if rightCornerCount < 2 and rightCornerCount > -2:
				if randi_range(0,2) == 0:
					tile.get_child(0).scale.y *= -1
					tile.get_child(0).get_child(0).rotation = PI
					tile.get_child(0).position.x = -24
					rightCornerCount -= 1
				else:
					rightCornerCount +=1
			else:
				if rightCornerCount == 2:
					tile.get_child(0).scale.y *= -1
					tile.get_child(0).get_child(0).rotation = PI
					tile.get_child(0).position.x = -24
					rightCornerCount -= 1
				else:
					rightCornerCount += 1
				
			tile.global_position = newestBranch.global_position
			tile.rotation = newestBranch.global_rotation
			newestBranch = tile.get_child(0).get_child(0)
		else:
			corner -= 1
			var tile = straightTile.instantiate()
			parent.add_child.call_deferred(tile)
			tile.global_position = newestBranch.global_position
			tile.rotation = newestBranch.global_rotation
			newestBranch = tile.get_child(0).get_child(0)

func genBatch(length):
	var parent = Node2D.new()
	get_tree().root.add_child.call_deferred(parent)
	parentList.push_front(parent)
	for i in range(length): newTile(parent)
