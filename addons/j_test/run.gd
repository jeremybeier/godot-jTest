extends SceneTree


func _init() -> void:
	jTest._use_bbc = false
	jTest.run()
	quit()
