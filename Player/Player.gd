extends CharacterBody2D

@export var Name = "PlaceHolder"
@export var MaxHP = 20
@export var MaxSP = 20

@onready var AttackArea = $ColorRect

@onready var ButtonMove = $BattleUI/VBoxContainer/Move
@onready var ButtonAttack = $BattleUI/VBoxContainer/Attack
@onready var ButtonSkill = $BattleUI/VBoxContainer/Skill

@onready var BattleUI = $BattleUI
@onready var Camera = $Camera2D
