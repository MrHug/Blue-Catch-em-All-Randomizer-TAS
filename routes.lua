my_room_pc = { [0] = 2, [1] = 0}
my_room_stairs = { [0] = 1, [1] = 7}
my_house_exit = {[0] = 7, [1] = 3}


-- Pallet Town
pallet_exit_grass = {[0] = 1, [1] = 10}
pallet_route_1 = {[0]=0, [1] = 10}


-- Oak's lab
oak_lab_ball_1 = {[0] = 4, [1] =6}
oak_lab_ball_2 = {[0] = 4, [1] =7}
oak_lab_ball_3 = {[0] = 4, [1] =8}
oak_lab_rival_fight = {[0]=6, [1] = 5}
oak_lab_exit = {[0]= 11, [1] = 5}


-- Route 1
route_1_pallet = { [0] = 35, [1] = 10 }
route_1_viridian = { [0] = 0, [1] = 11} 

-- Viridian

viridian_center = { [0] = 26, [1] = 23}
viridian_mart = { [0] = 20, [1] = 29}
viridian_route_2 = { [0] = 0, [1] = 18}
viridian_route_1 = { [0] = 32, [1] = 21}


-- Route 2

route_2_viridian = { [0] = 71, [1] = 8}
route_2_forest_viridian_side = { [0] = 44, [1] = 3}

-- Viridian Forest

viridian_forest_south_gate_viridian = {[0] = 7, [1] = 5}
viridian_forest_south_gate_forest = {[0] = 1, [1] = 5}
viridian_forest_south_entrance = { [0] = 47, [1] = 17}
viridian_forest_tree_item = { [0] = 42, [1] = 15}
viridian_forest_west_item = { [0] = 31, [1] = 2}
viridian_forest_north_entrance = { [0] = 0, [1] = 1}

-- Pokemarts
pokemart_counter = { [0] = 5, [1] = 2}
pokemart_exit = { [0] = 0, [1] = 5}

function route1_pallet_to_viridian()
	moveTo(route_1_viridian)
end

function route1_viridian_to_pallet_encounterless()
	moveTo(route_1_pallet)
end

function viridian_entrace_to_mart()
	turnAndTakeSteps(LEFT,2)
	turnAndTakeSteps(UP,4)
	turnAndTakeSteps(RIGHT,4)
	-- Check if Center is needed
	turnAndTakeSteps(RIGHT,3)
	turnAndTakeSteps(UP,6)
	turnAndTakeSteps(RIGHT,3)
	turnAndTakeSteps(UP,1)
	transition()
end

function viridian_entrace_to_pokecenter()
	turnAndTakeSteps(LEFT,1)
	turnAndTakeSteps(UP,4)
	turnAndTakeSteps(RIGHT,4)
end

function viridian_center_to_route1catching()
	turnAndTakeSteps(DOWN,1)
	turnAndTakeSteps(DOWN,2)
	turnAndTakeSteps(LEFT,2)
	turnAndTakeSteps(DOWN,10)
	turnAndTakeSteps(DOWN,1)
	turnAndTakeSteps(RIGHT,3)
end

function route1catching_to_viridian_center()
	turnAndTakeSteps(UP,2)
	turnAndTakeSteps(LEFT,4)
	turnAndTakeSteps(UP,12)
	turnAndTakeSteps(LEFT,1)
	turnAndTakeSteps(UP,2)
	turnAndTakeSteps(RIGHT,4)
end

function viridian_mart_to_entrance()
	turnAndTakeSteps(LEFT,3)
	turnAndTakeSteps(DOWN,6)
	takeHop(DOWN)
	takeSteps(DOWN,2)
	turnAndTakeSteps(LEFT,5)
end

function pallet_entrance_to_lab()
	takeSteps(DOWN,5)
	turnAndTakeSteps(LEFT,1)
	turnAndTakeSteps(DOWN,5)
	turnAndTakeSteps(RIGHT,3)
	turnAndTakeSteps(UP,1)
	transition()
end

function lab_to_pallet_entrance()
	turnAndTakeSteps(LEFT,3)
	turnAndTakeSteps(UP,10)
	turnAndTakeSteps(RIGHT,1)
	turn(UP)
end

function oaks_lab_behind_oak()
	takeSteps(UP,8)
	turnAndTakeSteps(LEFT,1)
	turnAndTakeSteps(UP,2)
	turnAndTakeSteps(RIGHT,1)
	turn(DOWN)
end

function behind_oak_exit_lab()
	turnAndTakeSteps(LEFT,1)
	turnAndTakeSteps(DOWN,11)
	transition()
end

function viridian_center_to_forest(pick_up)
	turnAndTakeSteps(LEFT,4)
	turnAndTakeSteps(UP,20)
	-- Dodge the dude
	cnt = 0
	while memory.readbyte(SPRITE_X_POS_MEM + 0x10 * 7) == memory.readbyte(SPRITE_X_POS_MEM) do
		turnAndTakeSteps(LEFT,1)
		cnt = cnt + 1
	end
	turnAndTakeSteps(UP,2)
	while cnt > 0 do
		cnt = cnt - 1
		turnAndTakeSteps(RIGHT,1)
	end
	if pick_up then
		turnAndTakeSteps(LEFT,4)
		pickupItem(RIGHT)
		turnAndTakeSteps(RIGHT,3)
	else 
		turnAndTakeSteps(LEFT)
	end
	turnAndTakeSteps(UP,14)
	turnAndTakeSteps(LEFT)
	turnAndTakeSteps(UP,5)
	turnAndTakeSteps(LEFT,3)
	turnAndTakeSteps(UP,5)
	turnAndTakeSteps(RIGHT,6)
	turnAndTakeSteps(UP,8)
	turnAndTakeSteps(LEFT,7)
	turnAndTakeSteps(UP)
	transition()
end