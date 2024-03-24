extends Node


func _ready() -> void:
	$Quit.pressed.connect(quit)
	jTest.run()


func quit() -> void:
	get_tree().quit()
