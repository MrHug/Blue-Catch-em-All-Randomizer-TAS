local GRASS_COST = 20

local tileToWalkable = {
	[0] = { -- overworld
		[01] = {[0] = 1, [1] = 1, [2] = 1, [3] = 1},
    [07] = {[0] = 1, [1] = 1, [2] = -1, [3] = -1},    
		[08] = {[0] = 1, [1] = 1, [2] = 1, [3] = 0},
    [10] = {[0] = 1, [1] = 1, [2] = 1, [3] = 1},
		[11] = {[0] = GRASS_COST, [1] = GRASS_COST, [2] = GRASS_COST, [3] = GRASS_COST},
    [26] = {[0] = 1, [1] = 1, [2] = -1, [3] = -1},
		[28] = {[0] = 1, [1] = 1, [2] = 0, [3] = 0},    
    [47] = {[0] = 1, [1] = 1, [2] = -1, [3] = 1},
    [49] = {[0] = 1, [1] = 1, [2] = 1, [3] = 1},
    [66] = {[0] = 1, [1] = 0, [2] = -1, [3] = 0},
		[85] = {[0] = 1, [1] = 1, [2] = 1, [3] = 1},
		[86] = {[0] = 1, [1] = 1, [2] = 0, [3] = 0},
    [108] = {[0] = 0, [1] = 0, [2] = 1, [3] = 1},    
    [109] = {[0] = 1, [1] = 0, [2] = 1, [3] = 0},    
    [110] = {[0] = 1, [1] = 0, [2] = 1, [3] = 0},    
		[111] = {[0] = 1, [1] = 1, [2] = 0, [3] = 0},
    [116] = {[0] = 1, [1] = 1, [2] = 1, [3] = 1},
		[119] = {[0] = 1, [1] = 1, [2] = 0, [3] = 0},
		[124] = {[0] = 0, [1] = 0, [2] = 0, [3] = 1},
	},
  [1] = { -- Is used for ground floor of reds house?
    [07] = {[0] = 0, [1] = 0, [2] = 1, [3] = 1},
		[11] = {[0] = 1, [1] = 1, [2] = 1, [3] = 1},
		[15] = {[0] = 1, [1] = 1, [2] = 1, [3] = 1},
  },
  [3] = { -- Viridian Forst
    [06] = {[0] = 0, [1] = 0, [2] = GRASS_COST, [3] = GRASS_COST},
    [24] = {[0] = 0, [1] = 0, [2] = 1, [3] = 1},
    [27] = {[0] = 1, [1] = 1, [2] = 1, [3] = 1},
  },
	[4] = { -- reds house
		[05] = {[0] = 0, [1] = 0, [2] = 1, [3] = 1},
		[08] = {[0] = 0, [1] = 0, [2] = 1, [3] = 1},
		[13] = {[0] = 1, [1] = 0, [2] = 1, [3] = 0},
		[15] = {[0] = 1, [1] = 1, [2] = 1, [3] = 1},
	},
  [5] = { -- Oaks lab / Gym
    [4] = {[0] = 1, [1] = 1, [2] = 1, [3] = 1},
    [5] = {[0] = 1, [1] = 1, [2] = 1, [3] = 1},
    [109] = {[0] = 1, [1] = 1, [2] = 1, [3] = 1},
    [110] = {[0] = 1, [1] = 1, [2] = 1, [3] = 1},
    [103] = {[0] = 1, [1] = 1, [2] = 1, [3] = 1},
    [105] = {[0] = 1, [1] = 1, [2] = 0, [3] = 0},
    [116] = {[0] = 1, [1] = 1, [2] = 0, [3] = 1},
  },
	[6] = { -- Pokecenter
		[04] = {[0] = 0, [1] = 0, [2] = 1, [3] = 1},
		[05] = {[0] = 0, [1] = 0, [2] = 1, [3] = 1},
		[07] = {[0] = 0, [1] = 0, [2] = 1, [3] = 1},
    [08] = {[0] = 0, [1] = 1, [2] = 0, [3] = 1},
		[10] = {[0] = 1, [1] = 1, [2] = 1, [3] = 1},
		[11] = {[0] = 1, [1] = 1, [2] = 1, [3] = 1},
		[15] = {[0] = 1, [1] = 1, [2] = 1, [3] = 1},
		[25] = {[0] = 1, [1] = 1, [2] = 1, [3] = 1},
		[26] = {[0] = 1, [1] = 1, [2] = 1, [3] = 1},
		[27] = {[0] = 1, [1] = 1, [2] = 1, [3] = 1},
		[33] = {[0] = 0, [1] = 0, [2] = 1, [3] = 1},
		[34] = {[0] = 0, [1] = 0, [2] = 1, [3] = 1},
		[35] = {[0] = 0, [1] = 0, [2] = 1, [3] = 0},
	},
  [9] = { -- Gate
		[0] = {[0] = 1, [1] = 1, [2] = 1, [3] = 1},
		[11] = {[0] = 1, [1] = 1, [2] = 1, [3] = 1},
		[115] = {[0] = 0, [1] = 1, [2] = 1, [3] = 1},
  }
}
tileToWalkable[2] = tileToWalkable[6] -- Mart is also Pokecenter

function readMap()
	map_num = memory.readbyte(MAP_NUM_MEM)
	map_height = memory.readbyte(0xD368)
	map_width = memory.readbyte(0xD369)
	map_tileset = memory.readbyte(0xD367)
	--console.log("Map " .. map_num .. ", of size " .. map_width .. " by " .. map_height .. ", with tile set " .. map_tileset)
	
	mem_index = memory.readbyte(0xD36A) + memory.readbyte(0xD36B) *256
	--console.log(mem_index)
	
	map_data = {}
	for i = 0,map_height-1 do
		map_data[i] = {}
		for j = 0, map_width-1 do
			map_data[i][j] = memory.readbyte(mem_index)
			mem_index = mem_index + 1
		end
	end
	return mapDataToWalkableMap(map_data, map_height, map_width, map_tileset)
end

function mapDataToWalkableMap(map_data, map_height, map_width, map_tileset)
	
	map = {}
	width = 2*map_width
	height = 2*map_height
	for i = 0,map_height-1 do
		map[2*i] = {}
		map[2*i+1] = {}
		for j = 0, map_width-1 do
			converted = convertTile2Walkable(map_data[i][j], map_tileset)
			map[2*i][2*j] = converted[0]
			map[2*i][2*j+1] = converted[1]
			map[2*i+1][2*j] = converted[2]
			map[2*i+1][2*j+1] = converted[3]
		end
	end
	--printMap(map, height, width)
	return map
end

function convertTile2Walkable(tile, tileset)
	dict = tileToWalkable[tileset]
	if dict[tile] ~= nil then
		return dict[tile]
	end
	return {[0] = 0, [1] = 0, [2] = 0, [3] = 0}
end



-- UTIL / DEBUG FUNCTIONS --

function printMap(map_data, height, width) 
	for i=0,height-1 do
		s = ""
		for j=0,width-1 do
			s = s .. " " .. map_data[i][j]
		end
		if (i % 2 == 0) then
			--console.log("------")
		end
		console.log(s)
	end
end