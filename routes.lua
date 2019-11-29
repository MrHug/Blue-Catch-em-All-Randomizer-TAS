function route1_pallet_to_viridian()
	turnAndTakeSteps(UP,8)
	turnAndTakeSteps(LEFT,2)
	turnAndTakeSteps(UP,6)
	turnAndTakeSteps(RIGHT,4)
	turnAndTakeSteps(UP,4)
	turnAndTakeSteps(LEFT,3)
	turnAndTakeSteps(UP,7)
	turnAndTakeSteps(RIGHT,5)
	
	-- Dodge the dude
	cnt = 0
	while memory.readbyte(SPRITE_X_POS_MEM + 0x10 * 2) == memory.readbyte(SPRITE_X_POS_MEM) do
		turnAndTakeSteps(RIGHT,1)
		cnt = cnt + 1
	end
	turnAndTakeSteps(UP,3)
	while cnt > 0 do
		cnt = cnt - 1
		turnAndTakeSteps(LEFT,1)
	end
	
	turnAndTakeSteps(UP,9)
	turnAndTakeSteps(LEFT,3)
	turnAndTakeSteps(UP,10)
end

function route1_viridian_to_pallet_encounterless()
	turnAndTakeSteps(DOWN,8)
	turnAndTakeSteps(LEFT,3)
	turnAndTakeSteps(DOWN,2)
	takeHop(DOWN,1)
	takeSteps(DOWN,2)
	takeHop(DOWN,1)
	takeSteps(DOWN,2)
	takeHop(DOWN,1)
	takeSteps(DOWN,4)
	takeHop(DOWN,1)
	
	turnAndTakeSteps(RIGHT,8)
	turnAndTakeSteps(DOWN,3)
	takeHop(DOWN)
	takeSteps(DOWN,1)
	turnAndTakeSteps(LEFT,6)
	turn(DOWN)
	takeHop(DOWN)
	turnAndTakeSteps(DOWN,10)
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