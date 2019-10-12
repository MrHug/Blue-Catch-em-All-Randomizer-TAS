function start_game()
	savestate.saveslot(1)
	getPCPotion()
	moveToGrass()
	walkWithOak()
	mashText(15)
	advanceFrame(6)
	mashText(5)
	savestate.saveslot(2)
	inspectPokes()
	pickPoke()
	savestate.saveslot(3)
	waitForRival()
	battleRival()
	savestate.saveslot(4)
	exitLabAfterRivalFight()
	lab_to_pallet_entrance()
	savestate.saveslot(5)
	route1_pallet_to_viridian()
	savestate.saveslot(6)
	viridian_entrace_to_mart()
	getOaksParcel()
	savestate.saveslot(7)
	viridian_mart_to_entrance()
	route1_viridian_to_pallet_encounterless()
	savestate.saveslot(8)
	pallet_entrance_to_lab()
	oaks_lab_behind_oak()
	handoverParcel()
	behind_oak_exit_lab()
end


function getPCPotion()
	turnAndTakeSteps(LEFT,2)
	turnAndTakeSteps(UP,4)
	turnAndTakeSteps(LEFT)
	turn(UP)
	enterItemBoxFromHomePC()
end

function enterItemBoxFromHomePC()
	pressAndAdvance(A,10) -- Open Menu
	mashText(4)
	advanceFrame(38)
	pressAndAdvance(A,5) -- Confirm 
	pressAndAdvance(B,10) -- Cancel item box
	pressAndAdvance(B,40) -- Close PC
	pressAndAdvance(B,5) -- Weird issue
	console.log(items_lookup[memory.readbyte(0xD31E)])
end

function moveToGrass()
	console.log("Moving to grass")
	turnAndTakeSteps(RIGHT, 7)
	turnAndTakeSteps(UP)
	transition()
	turnAndTakeSteps(DOWN,6)
	turnAndTakeSteps(LEFT,4)
	turnAndTakeSteps(DOWN)
	transition()
	turnAndTakeSteps(RIGHT,5)
	turnAndTakeSteps(UP,5)
end

function walkWithOak()
	advanceFrame(76)
	pressButton(A) -- Hey Wait
	advanceFrame(192) -- Oak walking
	mashText(5)
	pressButton(A) -- Come with me
	advanceFrame(552)
end

function inspectPokes()
	turn(RIGHT)
	inspectAndRejectPoke()
	turnAndTakeSteps(DOWN)
	turnAndTakeSteps(RIGHT,2)
	turn(UP)
	inspectAndRejectPoke()
	turnAndTakeSteps(RIGHT)
	turn(UP)
	inspectAndRejectPoke()
end

function inspectPoke()
	pressAndAdvance(A,180)
	pressAndAdvance(A,5)
	console.log("Pokemon at Oaks: " .. pokemon_lookup[memory.readbyte(0xCF91)])
	pressAndAdvance(A,20)
end

function inspectAndRejectPoke()
	inspectPoke()
	pressButton(B)
	advanceFrame(20)
	pressButton(B)
	advanceFrame(20)
end

function pickPoke()
	inspectPoke()
	pressButton(A)
	advanceFrame(20)
	pressButton(A) -- Energetic
	advanceFrame(20)
	pressButton(B) -- Give a nickname
	advanceFrame(10)
	pressButton(B)
	advanceFrame(20)
	pressButton(B)
	advanceFrame(5)
end

function waitForRival()
	advanceFrame(116)
	pressButton(A)
	advanceFrame(140)
	pressButton(A)
	advanceFrame(5)
	turnAndTakeSteps(DOWN)
	turnAndTakeSteps(LEFT,3)
end

function battleRival()
	--savestate.loadslot(6)
	turnAndTakeSteps(DOWN)
	advanceFrame(15)
	mashText(4)
	advanceFrame(78)
	battleTrainer()
end

function exitLabAfterRivalFight()
	advanceFrame(50)
	mashText(5)
	advanceFrame(205) -- Rival walks out
	takeSteps(DOWN,7)
	transition()
end

function getOaksParcel()
	mashText(3)
	advanceFrame(45)
	mashText(3)
	advanceFrame(20)
	mashText(1)
	turnAndTakeSteps(RIGHT,1)
	turnAndTakeSteps(DOWN,3)
	transition()
end

function handoverParcel()
	pressAndAdvance(A,10)
	mashText(15)
	advanceFrame(100) -- Rival walking
	mashText(46)
	advanceFrame(100) -- Rival walking
end