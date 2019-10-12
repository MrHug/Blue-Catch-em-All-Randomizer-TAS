function route1_pallet_to_viridian()
	turnAndTakeSteps(UP,8)
	turnAndTakeSteps(LEFT,2)
	turnAndTakeSteps(UP,6)
	turnAndTakeSteps(RIGHT,4)
	turnAndTakeSteps(UP,4)
	turnAndTakeSteps(LEFT,3)
	turnAndTakeSteps(UP,7)
	turnAndTakeSteps(RIGHT,5)
	turnAndTakeSteps(UP,12)
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
	
	turnAndTakeSteps(RIGHT,9)
	turnAndTakeSteps(DOWN,3)
	takeHop(DOWN)
	takeSteps(DOWN,2)
	turnAndTakeSteps(LEFT,6)
	turn(DOWN)
	takeHop(DOWN,1)
	turnAndTakeSteps(DOWN,11)
end

function viridian_entrace_to_mart()
	turnAndTakeSteps(LEFT,2)
	turnAndTakeSteps(UP,4)
	turnAndTakeSteps(RIGHT,3)
	-- Check if Center is needed
	turnAndTakeSteps(RIGHT,7)
	turnAndTakeSteps(UP,8)
	turnAndTakeSteps(UP,2)
	transition()
end

function viridian_mart_to_entrance()
	turnAndTakeSteps(LEFT,3)
	turnAndTakeSteps(DOWN,6)
	takeHop(DOWN)
	takeSteps(DOWN,2)
	turnAndTakeSteps(LEFT,6)
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