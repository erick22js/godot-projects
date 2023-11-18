extends Node2D



func _ready():
	#print(OS.get_class());
	if(OS.get_name()=="Windows"):
		$FileDialog.current_dir = "C:Users/"+OS.get_environment("USERNAME")+"/Documents";
	else:
		$FileDialog.current_dir = "/sdcard";
#	var arquivo = File.new();
#	arquivo.open("src://testeDoGodot.txt", File.WRITE);
#	arquivo.store_string("Texto armazenado!");
	#OS.set_use_file_access_save_and_swap()
	#OS.
	pass # Replace with function body.

func updateText():
	$infoData.text = "Quantidade: "+str(DataGlobal.quantity);

func alert(text: String, title: String='Message') -> void:
	var dialog = AcceptDialog.new()
	dialog.dialog_text = text
	dialog.window_title = title
	dialog.rect_scale.x = 2;
	dialog.rect_scale.y = 2;
	dialog.connect('modal_closed', dialog, 'queue_free')
	add_child(dialog)
	dialog.popup_centered()

func _on_Button_pressed():
	DataGlobal.quantity += 1;
	updateText();
	pass # Replace with function body.


func _on_Button2_pressed():
	DataGlobal.quantity -= 1;
	updateText();
	pass # Replace with function body.




func _on_Button4_pressed():
	var dados = File.new();
	var resultado = dados.open("user://salvo.sav",File.WRITE);
	if(resultado!=OK):
		alert("Não foi possível carregar.","");
	else:
		dados.store_var(DataGlobal.quantity);
		dados.close();
		alert("Arquivo salvo!","");
	pass # Replace with function body.


func _on_Button3_pressed():
	var dados = File.new();
	var resultado = dados.open("user://salvo.sav",File.READ);
	print(dados.is_open())
	if(dados.is_open()==false):
		print("Non loaded");
		alert("Não foi possível carregar.","");
	else:
		DataGlobal.quantity = dados.get_var();
		updateText();
		dados.close();
		alert("Arquivo carregado!","");
	pass # Replace with function body.


func _on_FileDialog_file_selected(path):
	print(path);
	var file = File.new();
	if($FileDialog.mode == FileDialog.MODE_OPEN_FILE):
		file.open(path, File.READ);
		$infoData.text = file.get_as_text();
		#print(file.get_as_text());
	else:
		file.open(path, File.WRITE);
		file.store_string("Arquivo gerado pelo programa Introduction.");
	pass # Replace with function body.


func _on_loadFile_pressed():
	var file = File.new();
	file.open($CaminhoDeSave.text, File.READ);
	$infoData.text = file.get_as_text();
	file.close();
#	$FileDialog.mode = FileDialog.MODE_OPEN_FILE;
#	$FileDialog.window_title = "Abrir arquivo";
#	$FileDialog.popup();
	pass # Replace with function body.


func _on_saveFile_pressed():
	var file = File.new();
	file.open($CaminhoDeSave.text, File.WRITE);
	file.store_string("Arquivo gerado pelo programa Introduction.");
	file.close();
#	if(OS.get_name()!="Windows"):
#		var file = File.new();
#		file.open("/sdcard/godotFileGenerated.txt", File.WRITE);
#		file.store_string("Arquivo gerado pelo programa Introduction.");
#	$FileDialog.mode = FileDialog.MODE_SAVE_FILE;
#	$FileDialog.window_title = "Salvar arquivo";
#	$FileDialog.popup();
	pass # Replace with function body.


func _on_saveData2_pressed():
	DataGlobal.run_script($evalInput.text);
	pass # Replace with function body.
