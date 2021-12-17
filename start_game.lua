function start_game()
	getPCPotion()
	moveToGrass()
	walkWithOak()
	mashText(15)
	advanceFrame(6)
	mashText(8)
	inspectPokes()
	pickPoke()
	waitForRival()
	battleRival()
	exitLabAfterRivalFight()
	walkTo(pallet_route_1)
	turnAndTakeSteps(UP)
	route1_pallet_to_viridian()
	turnAndTakeSteps(UP)
	viridian_entrace_to_mart()
	getOaksParcel()
	viridian_mart_to_entrance()
	turnAndTakeSteps(DOWN)
	route1_viridian_to_pallet_encounterless()
	turnAndTakeSteps(DOWN)
	pallet_entrance_to_lab()
	savestate.saveslot(1)
	oaks_lab_behind_oak()
	handoverParcel()
	behind_oak_exit_lab()
	turnAndTakeSteps(DOWN)
	transition()
	walkTo(pallet_route_1)
	turnAndTakeSteps(UP)
	route1_pallet_to_viridian()
	turnAndTakeSteps(UP)
	viridian_entrace_to_mart()
	goToMartCounter()
	talkToMart()
	buyItem(POKEBALL_ID,12)
	stopTalkingToMart()
	exitMart()
	walkTo(viridian_center)
	healAndExit()
	viridian_center_to_forest(true)
	viridian_forest_up(true)
	walkTo(route_2_pewter)
	turnAndTakeSteps(UP)
	pewter_first_time()
	pewter_enter_mt_moon()
	mt_moon(true)
	savestate.saveslot(6)
	walkTo(cerulean_center)
	healAndExit()
	beatMisty()
	doNuggetBridge()
	walkTo(cerulean_center)
	healAndExit()		
	throughTrashedHouse()
	ceruleanToViridian()
	walkTo(vermillion_center)
	savestate.saveslot(7)
end


function getPCPotion()
	walkTo(my_room_pc)
	turn(UP)
	enterItemBoxFromHomePC()
end

function enterItemBoxFromHomePC()
	log(L_DEBUG, "Opening PC menu")
	pressAndAdvance(A,10) -- Open Menu
	mashText(4)
	advanceFrame(38)
	pressAndAdvance(A,5) -- Confirm 
	pressAndAdvance(B,10) -- Cancel item box
	pressAndAdvance(B,40) -- Close PC
	pressAndAdvance(B,5) -- Weird issue
	log(L_INFO, "PC item was a " .. items_lookup[memory.readbyte(0xD31E)])
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
	log(L_VERBOSE, "Entering battleRival")
	--savestate.loadslot(6)
	turnAndTakeSteps(DOWN)
	log(L_VERBOSE, "Exiting battleRival")
end

function exitLabAfterRivalFight()
	walkTo(oak_lab_exit)
    turnAndTakeSteps(DOWN)
    transition()
    log(L_VERBOSE, "Exit exitLabAfterRivalFight")
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
	mashTillTurned(LEFT)
end