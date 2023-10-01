extends Node2D


@export var inventorySize: Vector2i
@export var inventorySlot: PackedScene
@export var distanceBetweenSlots: float = 100
var inventorySlots = []
var items = []
var itemPower: int
@export var superChargeColour: Color

func _ready():
	CreateInventoryGrid()
	CenterGrid()
	UpdateLabel()

func _process(delta):
	pass

func CreateInventoryGrid():
	for x in inventorySize.x:
		for y in inventorySize.y:
			CreateInventorySlot(x, y)

func CreateInventorySlot(x, y):
	var slotInstance = inventorySlot.instantiate()
	add_child(slotInstance)
	slotInstance.position = Vector2(x * distanceBetweenSlots, y * distanceBetweenSlots)
	inventorySlots.append(slotInstance)

func CenterGrid():
	position -= Vector2(inventorySize/2 * distanceBetweenSlots)

func AddItem(newItem):
	if not items.has(newItem):
		items.append(newItem)
		itemPower += newItem.itemPower
		print(" Item Power: ", itemPower, " / ", inventorySlots.size(), " Items: ", items)
		UpdateLabel()

func RemoveItem(removedItem):
	if items.has(removedItem):
		items.erase(removedItem)
		itemPower -= removedItem.itemPower
		print(" Item Power: ", itemPower, " / ", inventorySlots.size(), " Items: ", items)
		UpdateLabel()

func UpdateLabel():
	$Label.text = str(itemPower, " / ", inventorySlots.size())
	if itemPower >= inventorySlots.size()/2:
		print(Color(255, 101, 40, 1))
		$Label.add_theme_color_override("font_color", superChargeColour)
	else:
		$Label.add_theme_color_override("font_color", Color(0, 0, 0, 1))
		
