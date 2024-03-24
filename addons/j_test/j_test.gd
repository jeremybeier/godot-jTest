@tool
class_name jTest
extends Resource

enum jTest_Color { Success, Warn, Error }

const _test_dir: String = "res://test"

static var _use_bbc: bool = true

static var _test_count: int = 0
static var _passed_count: int = 0
static var _failed_count: int = 0

var _checks_count: int = 0
var _failure_reports: Array[String] = []

var _test_tests: Array[Callable] = []

var _check_failed := false


static func run():
	_test_count = 0
	_passed_count = 0
	_failed_count = 0

	print()

	print_rich(_success("Run jTest..."))

	print_rich(_success("Searching %s dir..." % _warn(_test_dir)))
	var test_files: Array[String] = _get_possible_test_files_from(_test_dir)
	if test_files.size() == 0:
		print("No test files found in " + _test_dir)
		return
	test_files.map(func(f): print(f))

	print_rich(_success("Loading test files..."))
	var jTests: Array[jTest] = []
	for test_file in test_files:
		var test_resource = load(test_file)
		if test_resource == null:
			print("Failed to load: " + test_file)
			continue
		if not _is_jTest(test_resource):
			print("Not a jTest class: " + test_file)
			continue
		var test: jTest = test_resource.new()
		if test == null:
			print("Failed to instance: " + test_file)
			continue
		print("Loaded: " + test_file)
		jTests.append(test)

	print_rich(_success("Running jTests..."))
	for test in jTests:
		test._run()

	print_rich(_warn("Tests run: %d" % _test_count))
	print_rich(
		(
			_success("Passed: %d" % _passed_count)
			if _test_count == _passed_count
			else _warn("Passed: %d" % _passed_count)
		)
	)
	print_rich(
		(
			_error("Failed: %d" % _failed_count)
			if _failed_count > 0
			else _success("Failed: %d" % _failed_count)
		)
	)


static func debug():
	EditorInterface.play_custom_scene("res://addons/j_test/debug/debug.tscn")


static func _get_possible_test_files_from(res_dir: String) -> Array[String]:
	var files: Array[String] = []
	var dir := DirAccess.open(res_dir)
	if dir == null:
		return files
	dir.list_dir_begin()
	var element_name := dir.get_next()
	while element_name != "":
		var element_path := res_dir + "/" + element_name
		if dir.current_is_dir():
			var subs := _get_possible_test_files_from(element_path)
			files.append_array(subs)
		else:
			if element_name.ends_with(".gd"):
				files.append(element_path)
		element_name = dir.get_next()
	dir.list_dir_end()
	return files


static func _is_jTest(script: Script) -> bool:
	var parent := script.get_base_script()
	while parent != null:
		if parent == jTest:
			return true
		parent = parent.get_base_script()
	return false


static func _warn(value: Variant) -> String:
	return _with_color(str(value), jTest_Color.Warn)


static func _error(value: Variant) -> String:
	return _with_color(str(value), jTest_Color.Error)


static func _success(value: Variant) -> String:
	return _with_color(str(value), jTest_Color.Success)


static func _with_color(text: String, color: jTest_Color) -> String:
	if _use_bbc:
		match color:
			jTest_Color.Success:
				return "[color=chartreuse]" + text + "[/color]"
			jTest_Color.Warn:
				return "[color=orange]" + text + "[/color]"
			jTest_Color.Error:
				return "[color=crimson]" + text + "[/color]"
			_:
				return text
	else:
		match color:
			jTest_Color.Success:
				return "\u001b[32m" + text + "\u001b[0m"
			jTest_Color.Warn:
				return "\u001b[33m" + text + "\u001b[0m"
			jTest_Color.Error:
				return "\u001b[31m" + text + "\u001b[0m"
			_:
				return text


func add_test(function: Callable):
	_test_tests.append(function)


func fail(message: String = ""):
	_checks_count += 1
	_failure(message)


func j_is(value: Variant, expected: Variant, message: String = ""):
	_checks_count += 1
	if typeof(value) != typeof(expected):
		_failure("Expected type '%s' to be same as '%s'" % [_warn(value), _warn(expected)])
		return
	if value != expected:
		_failure("Expected value '%s' to be '%s'" % [_warn(value), _warn(expected)])
		return


func j_is_close_to(value: float, expected: float, tolerance: float, message: String = ""):
	_checks_count += 1
	if abs(value - expected) > tolerance:
		_failure(
			(
				"Expected '%s' to be close to '%s' with tolerance '%s'"
				% [_warn(value), _warn(expected), _warn(tolerance)]
			)
		)
		return


func _run():
	for test in _test_tests:
		_checks_count = 0
		_failure_reports = []
		_check_failed = false
		_test_count += 1
		test.call()
		if _check_failed:
			_failed_count += 1
			print_rich(_error("Failed: ") + "%s | %s" % [test, test.get_bound_arguments()])
			_failure_reports.map(func(report): print_rich(report))
		else:
			_passed_count += 1
			print_rich(_success("Passed: ") + "%s | %s" % [test, test.get_bound_arguments()])


func _failure(message: String = ""):
	_check_failed = true
	_failure_reports.append("  #%d : %s" % [_checks_count, message])
