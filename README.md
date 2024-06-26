# jTest

Minimal test framework as plugin for Godot.  
Made for use in my projects.

![alt text](docs/demo.png)

## Usage

Add a `@tool` script file to `res://test`.  
Extend from `jTest` and call `add_test()` on your test functions in `_init()`.  
**Optionally** bind parameters to the test functions.

```gdscript
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
	pass


func test_math_sqrt(input: float, expected: float):
	var result = sqrt(input)
	j_is_close_to(result, expected, 0.01)


func test_mod(value: int, modulo: int, expected: int):
	j_is(value % modulo, expected)


func test_capitalize(input: String, expected: String):
	var result = input.capitalize()
	j_is(result, expected)

```

Then execute from the provided editor dock:

> Use `Debug` if you want to use breakpoints in the editor.

![dock](docs/image.png)

Or execute via shell:

```shell
godot -s addons/j_test/run.gd
```

## Assertions

Using the provided assertions is **optional**.

You may write your own check functions which just report a failure via calling `fail`.

| Assertion     | Description                                           |
| ------------- | ----------------------------------------------------- |
| j_is          | Checks for same type and value.                       |
| j_is_close_to | Checks two floats are within tolerance of each other. |

## Development

After cloning this repository configure git to use the checked in `.githooks` folder instead of the default.

```shell
git config core.hooksPath .githooks
```

The checked-in hooks are used for versioning and branch protection.

## Release

Manually trigger the GitHub Action `create-release` to create a release draft.  
Check for necessary changes and publish.
