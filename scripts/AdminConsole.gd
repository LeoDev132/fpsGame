class_name AdminConsole extends Object

var commands = {}


func _spawn_item(cmd_ctx: CommandContext, args):
	if args.size() > 0:
		var item_id = args[0]
		if is_instance_of(cmd_ctx.entity, PlayerController):
			var spawn_pos = cmd_ctx.entity.get_eye_ray().get_collision_point()
			ItemRegistry.spawn_item(spawn_pos + Vector3(0, 3, 0), item_id)

# Called when the node enters the scene tree for the first time.
func _init():
	commands["spawn_item"] = _spawn_item
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _split_str(str: String, val: String):
	var out = []
	var curr = ""
	for v in str:
		if v == val and curr != "":
			out.append(curr)
			curr = ""
		else:
			curr += v
	if curr != "":
		out.append(curr)
	return out
func send_command(cmd: String):
	var split_cmd = _split_str(cmd, " ")
	if split_cmd.size() == 0:
		print("command not found")
		return
	print(split_cmd, commands.keys())
	if split_cmd[0] in commands.keys():
		print("command found, calling command²²")
		var c = split_cmd.pop_at(0)
		var ctx = CommandContext.new(GameManager.player)
		commands[c].call(ctx, split_cmd)
	else:
		print("command not found")
