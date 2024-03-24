@tool
extends Control


func _ready() -> void:
	$Box/Run.pressed.connect(run)
	$Box/Debug.pressed.connect(debug)


func run():
	jTest.run()


func debug():
	jTest.debug()
