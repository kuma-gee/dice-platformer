extends Area2D

class_name HurtBox

signal hit
signal damaged(dmg)

func damage(dmg: int):
	emit_signal("damaged", dmg)
	emit_signal("hit")

