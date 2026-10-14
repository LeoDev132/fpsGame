@abstract class_name Item extends Node3D

var spawn_pool
var rarity
var equippable
var pickup_mesh_path #path of the meshinstance in the prefab
var identifier
var pickup_rot
var prefab_path  #prefab for equipped
var custom_attributes = {}
var display_name

@abstract func on_equip(entity)
