extends CollectableComponent
class_name CollectableSword


func consume(body: BaseCharacter):
	body.update_sword_state(true)

