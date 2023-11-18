extends Node

func random(start, end):
	var random_generator = RandomNumberGenerator.new()
	random_generator.randomize()
	var random_value = random_generator.randf_range(start,end)
	return int(random_value);

func pow_progress(progress, ramp):
	return pow(progress, pow(2, ramp));
