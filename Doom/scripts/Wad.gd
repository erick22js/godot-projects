extends Node

class Wad:
	var data;
	var header;
	var lumpsNames;
	var lumpsData;
	func _init(path:String):
		var bytes = IOBytes.bytesFromFile(path);
		self.data = bytes;
		self.header = IOBytes.bytesToString(IOBytes.extractBytes(bytes, 0, 4))
		print(self.header)
		#Preload lumps
		
		print("WAD Loaded!")
	func modulo():
		pass
	pass
