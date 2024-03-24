@tool
extends EditorPlugin

var j_dock : Control

func _enter_tree() -> void:
	j_dock = preload("res://addons/j_test/dock/j_dock.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_LEFT_BR, j_dock)


func _exit_tree() -> void:
	j_dock.queue_free()
