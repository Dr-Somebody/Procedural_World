extends TileMap

#Screen Resolution
@export var width = 1080 * 3
@export var height = 720 * 3

#Generate Noise Maps
var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()

#Width and Height measured in tiles
var mapWidth = width / 8
var mapHeight = height / 8
#Center to Corner Distance
var diag = sqrt(pow(mapWidth/2, 2.0) + pow(mapHeight/2, 2.0))

func _ready():
	#Generate random seeds
	moisture.seed = randi()
	temperature.seed = randi()
	altitude.seed = randi()
	
	generate_world()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func generate_world():
	#Generate noise data for every coordinate
	for y in range(mapHeight):
		for x in range(mapWidth):
			var moist = abs(moisture.get_noise_2d(x,y))
			var _temp = abs(temperature.get_noise_2d(x,y))
			var alt = abs(altitude.get_noise_2d(x,y))
			
			#Calculate distance from center to point
			var distance = sqrt(pow(mapWidth/2 - x, 2.0) + pow(mapHeight/2 - y, 2.0))
			
			#Lerp between vanilla alt and adjusted. Last number changes intensity of change
			alt = lerp(alt, alt * (-pow(distance + mapHeight/2, 3.0) / pow(diag, 3.0) + 1), 0.7)
			
			#Assign tile based on noise value
			##Ocean
			if(alt < 0.05):
				set_cell(0, Vector2i(x,y), 0, Vector2i(0,0))
			#Shore
			elif(alt < 0.075):
				set_cell(0, Vector2i(x,y), 0, Vector2i(0,1))
			#Grassland
			elif(alt < 0.3 && moist < 0.35):
				set_cell(0, Vector2i(x,y), 0, Vector2i(0,2))
			#Forest
			elif(alt < 0.3):
				set_cell(0, Vector2i(x,y), 0, Vector2i(1,2))
			#Snow
			elif(alt > 0.35 && moist > 0.25):
				set_cell(0, Vector2i(x,y), 0, Vector2i(1,3))
			#Mountain
			else:
				set_cell(0, Vector2i(x,y), 0, Vector2i(0,3))
			
