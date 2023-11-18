extends Node

func bytesFromFile(dir:String)->PoolByteArray:
	var file = File.new();
	if !file.file_exists(dir):
		printerr("File at:'"+dir+"' can't be opened.");
	file.open(dir, File.READ);
	return file.get_buffer(8);

func extractBytes(src:PoolByteArray, start:int, length:int)->PoolByteArray:
	var dest = [];
	var i = 0;
	while i<length:
		dest.append(src[start+i]);
		i += 1;
	return dest as PoolByteArray;

func bytesToString(bytes:PoolByteArray)->String:
	var string = "";
	var i = 0;
	while i<bytes.size():
		string += char(bytes[i])
		i += 1;
	return string
