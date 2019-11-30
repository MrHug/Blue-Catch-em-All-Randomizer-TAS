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
	walkTo(pallet_route_1)
  turnAndTakeSteps(UP)
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
	savestate.saveslot(9)
	walkTo(pallet_route_1)
  turnAndTakeSteps(UP)
	route1_pallet_to_viridian()
	viridian_entrace_to_mart()
	savestate.saveslot(0)
	goToMartCounter()
	talkToMart()
	buyItem(POKEBALL_ID,12)
	stopTalkingToMart()
	exitMart()
end


function getPCPotion()
	walkTo(my_room_pc)
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
	walkTo(my_room_stairs)
	transition()
	walkTo(my_house_exit)
  turnAndTakeSteps(DOWN)
	transition()
	walkTo(pallet_exit_grass)
end

function walkWithOak()
	while memory.readbyte(MAP_NUM_MEM) ~= 40 or memory.readbyte(MY_X_MEM) ~= 5 or memory.readbyte(MY_Y_MEM) ~= 3 do
    pressAndAdvance(B)
  end
end

function inspectPokes()
	walkTo(oak_lab_ball_1,UP)
	inspectAndRejectPoke()
	walkTo(oak_lab_ball_2,UP)
	inspectAndRejectPoke()
	walkTo(oak_lab_ball_3,UP)
	inspectAndRejectPoke()
end

function inspectPoke()
	advanceFrame(2)
	pressAndAdvance(A,180)
	pressAndAdvance(A,5)
	console.log("Pokemon at Oaks: " .. pokemon_lookup[memory.readbyte(0xCF91)])
	pressAndAdvance(A,25)
end

function inspectAndRejectPoke()
	inspectPoke()
	pressAndAdvance(B,20)
	pressAndAdvance(B,20)
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
	walkTo(oak_lab_rival_fight)
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
	walkTo(oak_lab_exit)
  turnAndTakeSteps(DOWN)
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
	mashText(75)
	advanceFrame(100) -- Rival walking
end