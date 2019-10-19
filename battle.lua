function battleTrainer()
	battleOpening()
	result = true
	x=1
	while enemyHP() > 0 and myHP() > 0 do
		logEnemy()
		logMe()
		pressAndAdvance(A)
		x=findAndPerformMostPowerfullMove(x)
	end
	if enemyHP() == 0 then
		console.log("Killed enemy")
	elseif myHP() == 0 then
		console.log("Got killed")
		if memory.readbyte(MY_NUM_OF_POKES) == 1 then
			console.log("Lost all pokes")
			result = false
		end
	end
	
	while battleType() > 0 do
		pressAndAdvance(A)
	end
	advanceFrame(30)
	return result
end

function battleWild()
	battleOpening()
	pokeball_id = hasPokeballs()
	if pokeball_id < 0 then
		runFromBattle()
		if battleType() == 0 then
			return
		end
	end
end

function battleOpening()
	if battleType() == 1 then -- Wild
		advanceFrame(400)
	else 
		advanceFrame(240) -- Trainer
	end
	mashText(1)
	advanceFrame(400)
end

function mostPowerfullMoveID() 
	enemy_type1, enemy_type2 = enemyTypes()
	
	index = -1
	mostPower = 0
	for i=1,4 do
		movePower = memory.readbyte(MY_SELECTED_MOVE_POWER)
		moveType = memory.readbyte(MY_SELECTED_MOVE_TYPE)
		moveAcc = memory.readbyte(MY_SELECTED_MOVE_ACC)
		eff = effectiveness(moveType, enemy_type1, enemy_type2)
		combined = movePower * moveAcc/255 * eff
		if mostPower < combined then
			mostPower = combined
			index = i
		end
		console.log(combined .. "\t For: " .. movePower .. " " .. types_lookup[moveType] .. " " .. moveAcc .. " " .. eff)
		pressAndAdvance(DOWN)
	end
	if index < 0 then
		console.log("No moves that can damage enemy :(")
	end
	return index
end

function findAndPerformMostPowerfullMove(x)
	while x > 1 do
		pressAndAdvance(DOWN)
		x = x - 1
	end
	y = mostPowerfullMoveID()
	while y ~= x do
		pressAndAdvance(DOWN)
		x = x + 1
		if x > 4 then
			x = 1
		end
    end
	pressAndAdvance(A)
	waitForNextTurn()
	return y
end

function effectiveness(move_type, enemy_type1, enemy_type2)
	factor = types_effectiveness[moveType][enemy_type1]
	if factor == Nil then
		factor = 1
	end
	factor2 = types_effectiveness[moveType][enemy_type2]
	if factor2 == Nil then
		factor2 = 1
	end
	return factor * factor2
end

function waitForNextTurn()
	while memory.readbyte(X_COORD_MENU_MEM) ~= 14 and enemyHP() > 0 and myHP() > 0 do
		pressAndAdvance(A)
	end
end

function enemyHP()
	return memory.readbyte(ENEMY_HP_MEM) * 255 + memory.readbyte(ENEMY_HP_MEM+1)
end

function myHP()
	return memory.readbyte(MY_HP_MEM) * 255 + memory.readbyte(MY_HP_MEM+1)
end

function enemyTypes()
	return memory.readbyte(ENEMY_TYPE_1_MEM), memory.readbyte(ENEMY_TYPE_2_MEM)
end

function logEnemy()
	console.log("-------")
	console.log("Facing " .. pokemon_lookup[memory.readbyte(ENEMY_POKE_MEM)])
	enemy_type1, enemy_type2 = enemyTypes()
	console.log("Types: " .. types_lookup[enemy_type1] .. " " .. types_lookup[enemy_type2])
	console.log("HP: " .. enemyHP())
	console.log("-------")
end

function logMe()
	console.log("-------")
	console.log("My Poke " .. pokemon_lookup[memory.readbyte(MY_POKE_MEM)])
	console.log("HP: " .. myHP())
	console.log("-------")
end

function runFromBattle()
	pressAndAdvance(RIGHT)
	pressAndAdvance(DOWN)
	pressAndAdvance(A,20)
	pressAndAdvance(A,50)
end

function battleType() 
	return memory.readbyte(IN_BATTLE_MEM)
end

function hasPokeballs()
	total_items = memory.readbyte(TOTAL_ITEMS_MEM)
	for i=0,total_items-1 do
		if memory.readbyte(ITEM_1_MEM+2*i) == POKEBALL_ID and memory.readbyte(ITEM_1_QUANTITY_MEM + 2*i) > 0 then
			return i
		end
	end
	return -1
end