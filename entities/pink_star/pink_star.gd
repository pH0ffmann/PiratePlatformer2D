extends BaseEnemy
class_name PinkStar


func attack():
	if not is_instance_valid(player_in_range):
		return
	
	if player_in_range.is_player_alive():
		enemy_texture.action_animate("attack_anticipation")
