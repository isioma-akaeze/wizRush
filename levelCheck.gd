extends Node

var levelsCompleted := 0
var levelOneKills := 0
var levelOneCoins := 0
var levelOneTime := 0

var levelTwoKills := 0
var levelTwoCoins := 0
var levelTwoTime := 0

var levelThreeKills := 0
var levelThreeCoins := 0
var levelThreeTime := 0

var totalKills := 0
var totalCoins := 0
var totalTime := 0

onready var difficulty := get_node("/root/GlobalOptionButton")
