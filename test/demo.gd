#test/demo.gd
@tool
extends jTest


func _init():
	add_test(simple_test)

	add_test(test_math_sqrt.bind(9.0, 3.0))
	add_test(test_math_sqrt.bind(16.0, 3.0))
	add_test(test_math_sqrt.bind(42.0, 6.48))

	add_test(test_mod.bind(5, 2, 1))
	add_test(test_mod.bind(5, 7, 5))
	add_test(test_mod.bind(5, 5, -1))

	add_test(test_capitalize.bind("hello", "Hello"))
	add_test(test_capitalize.bind("HELLo_goDot", "Hello Godot"))
	add_test(test_capitalize.bind("godot", "Godot"))


func simple_test():
	if abs(-1 - 1) != 1:
		fail("This test should fail.")


func test_math_sqrt(input: float, expected: float):
	var result = sqrt(input)
	j_is_close_to(result, expected, 0.01)


func test_mod(value: int, modulo: int, expected: int):
	j_is(value % modulo, expected)


func test_capitalize(input: String, expected: String):
	var result = input.capitalize()
	j_is(result, expected)
