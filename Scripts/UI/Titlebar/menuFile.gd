extends MenuButton

@onready var _fdLoad = $Load
@onready var _svFile = $Save
@onready var _nwFile = $New
@onready var _setDirs = $SetPaths

@onready var _ldr = $"/root/Main/Loader"
@export_node_path("VBoxContainer") var _ui

@export var loadShortcut: Shortcut
@export var saveShortcut: Shortcut
@export var newShortcut: Shortcut
@export var quitShortcut: Shortcut
@export var dirsShortcut: Shortcut

func _ready():
	self.get_popup().id_pressed.connect(_on_file_menu_pressed)
	get_popup().set_item_shortcut(0, loadShortcut, true)
	get_popup().set_item_shortcut(1, saveShortcut, true)
	get_popup().set_item_shortcut(2, newShortcut, true)
	get_popup().set_item_shortcut(4, dirsShortcut, true)
	get_popup().set_item_shortcut(6, quitShortcut, true)
	
	_ldr.loaded.connect(_on_loader_loaded)

func _on_file_menu_pressed(id: int):
	match id:
		0: _fdLoad.visible = true
		1: _svFile.visible = true
		4:
			get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		5: _nwFile.visible = true
		6: _setDirs.visible = true

func _on_loader_loaded(obj): # Once a level is loaded, let the user save.
	if obj == "fezlvl":
		get_popup().set_item_disabled(1, false)

func _on_new_file_selected(path: String):
	var cleanPath = path.get_basename().get_basename().get_file()
	# Have the user choose a trileset, and let the user save.
	get_popup().set_item_disabled(1, false)
	_ldr.killChildren() ## Clear out all objects
	await _ldr.loadTS(cleanPath) ## Wait for the new trileset to load
	get_node(_ui).playSound("loaded")
	pass
