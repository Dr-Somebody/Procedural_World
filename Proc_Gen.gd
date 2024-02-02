extends TileMap

#Screen Resolution
@export var width = 1080 * 3
@export var height = 720 * 3

var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()

#Width and Height measured in tiles
var mapWidth = width / 8
var mapHeight = height / 8

func _ready():
	moisture.seed = randi()
	temperature.seed = randi()
	altitude.seed = randi()
	
	generate_world()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func generate_world():
	for y in range(mapHeight):
		for x in range(mapWidth):
			var moist = abs(moisture.get_noise_2d(x,y))
			var _temp = abs(temperature.get_noise_2d(x,y))
			var alt = abs(altitude.get_noise_2d(x,y))
			
			##Ocean
			if(alt < 0.05):
				set_cell(0, Vector2i(x,y), 0, Vector2i(0,0))
			#Shore
			elif(alt < 0.075):
				set_cell(0, Vector2i(x,y), 0, Vector2i(0,1))
			#Grassland
			elif(alt < 0.4 && moist < 0.35):
				set_cell(0, Vector2i(x,y), 0, Vector2i(0,2))
			#Forest
			elif(alt < 0.4):
				set_cell(0, Vector2i(x,y), 0, Vector2i(1,2))
			#Snow
			elif(alt > 0.45 && moist > 0.25):
				set_cell(0, Vector2i(x,y), 0, Vector2i(1,3))
			#Mountain
			else:
				set_cell(0, Vector2i(x,y), 0, Vector2i(0,3))
			
