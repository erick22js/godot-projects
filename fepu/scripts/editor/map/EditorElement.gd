extends Node
class_name EditorElement


# Properties
var _selected:bool = false
var _removed:bool = true

enum Type{
	UNDEFINED,
	POINT,
	LINEDEF,
	FACEDEF,
	SIDEDEF,
	SECTOR
}
var type = Type.UNDEFINED

#
#	Access and control methods
#
func isSelected()-> bool:
	return _selected

