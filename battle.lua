function battleTrainer()
  console.log("Fighting trainer")
	battleOpening()
	local result = true
  goToMenuItem(0)
  local numEnemyPoke = memory.readbyte(ENEMY_NUM_POKE_MEM)
	while numEnemyPoke > 0 and myHP() > 0 do
    goToMenuItem(0, B)
    logAll(numEnemyPoke)
		pressAndAdvance(A)
		local x=findAndPerformMostPowerfullMove()
    if enemyHP() == 0 then
      console.log("Killed enemy")
      numEnemyPoke = numEnemyPoke - 1
      console.log(numEnemyPoke .. " pokes remaining")
    elseif myHP() == 0 then
      console.log("Got killed")
      if memory.readbyte(MY_NUM_OF_POKES) == 1 then
        console.log("Lost all pokes")
        result = false
      end
    end
  end
  console.log("Battle is done!")
	
	while battleType() > 0 do
		pressAndAdvance(B)
	end
	advanceFrame(30)
	return result
end

function battleWild()
  console.log("Fighting wild")
	battleOpening()
	local pokeball_id = hasPokeballs()
  goToMenuItem(0)
	if pokeball_id < 0 or own(memory.readbyte(ENEMY_POKE_MEM)) then
		console.log("Will try to run")
		
		while battleType() ~= 0 do
			runFromBattle()
		end
	else 
		while enemyHP() > 0 and myHP() > 0 do
			logAll(1)
			if enemyHP() > enemyMaxHP() / 2 then 
				goToMenuItem(0)
				pressAndAdvance(A)
				local x=findAndPerformMostPowerfullMove()
			else 
				if throwPokeball() then
					while battleType() ~= 0 do
						pressAndAdvance(B,3)
					end
					pressAndAdvance(B,10)
					while battleType() ~= 0 do
						pressAndAdvance(B,3)
					end
					console.log("Done with battle: " .. battleType())
					return
				else
					waitForNextTurn()
				end
			end
		end
		console.log("Accidentally killed it")
		while battleType() > 0 do
			pressAndAdvance(B)
		end
		advanceFrame(30)
	end
end

function throwPokeball()
	console.log("Trying to throw Pokeball")
	before = totalOwned()
	goToMenuItem(1)
	index = findItemInInventory(POKEBALL_ID)
	pressAndAdvance(A,5)
	goToMenuItem(0)
	goDir(DOWN,index)
	pressAndAdvance(A,5)
	advanceFrame(400)
	mashText(5)
	if totalOwned() > before then
		console.log("Caught it!")
		console.log("Now own: " .. totalOwned())
		mashText(5)
		return true
	end
	return false
end

function battleOpening()
  waitForNextTurn()
	 while memory.readbyte(SELECTED_MENU_ITEM_MEM) ~= 0 or enemyHP() ==0 do
		pressAndAdvance(B,2)
    pressAndAdvance(UP,2)
	end
end

function mostPowerfullMoveID() 
	enemy_type1, enemy_type2 = enemyTypes()
	
	goToMenuItem(1)
	index = -1
	mostPower = 0
	for i=1,4 do
		movePower = memory.readbyte(MY_SELECTED_MOVE_POWER)
		moveType = memory.readbyte(MY_SELECTED_MOVE_TYPE)
		moveAcc = memory.readbyte(MY_SELECTED_MOVE_ACC)
		movePP = memory.readbyte(MY_MOVES_PP_MEM + (i-1))
		eff = effectiveness(moveType, enemy_type1, enemy_type2)
		combined = movePower * moveAcc/255 * eff
		if mostPower < combined and movePP > 0 then
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

function findAndPerformMostPowerfullMove()
	
	local y = mostPowerfullMoveID()
	local x = memory.readbyte(SELECTED_MENU_ITEM_MEM)
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
	local factor = types_effectiveness[moveType][enemy_type1]
	if factor == nil then
		factor = 1
	end
	local factor2 = types_effectiveness[moveType][enemy_type2]
	if factor2 == nil then
		factor2 = 1
	end
	return factor * factor2
end

function waitForNextTurn()

  console.log("Waiting for next turn")
  while memory.readbyte(SELECTED_MENU_ITEM_MEM) == 0 and myHP() > 0 and battleType() > 0 do
		pressAndAdvance(B,2)
    pressAndAdvance(DOWN,2)
	end
  while memory.readbyte(SELECTED_MENU_ITEM_MEM) ~= 0 and enemyHP() > 0 and myHP() > 0 and battleType() > 0 do
		pressAndAdvance(B,2)
    pressAndAdvance(UP,2)
	end
  console.log("Next turn starting" .. enemyHP() .. "," .. myHP() .. "," .. battleType())
  -- client.pause()
end

function enemyMaxHP() 
	return memory.readbyte(ENEMY_MAX_HP_MEM) * 256 + memory.readbyte(ENEMY_MAX_HP_MEM+1)
end

function enemyHP()
	return memory.readbyte(ENEMY_HP_MEM) * 256 + memory.readbyte(ENEMY_HP_MEM+1)
end

function myHP()
	return memory.readbyte(MY_HP_MEM) * 256 + memory.readbyte(MY_HP_MEM+1)
end

function enemyTypes()
	return memory.readbyte(ENEMY_TYPE_1_MEM), memory.readbyte(ENEMY_TYPE_2_MEM)
end

function logAll(numEnemyPoke)
	console.log("##########")
	console.log("Turn: " .. memory.readbyte(IN_BATTLE_TURNS_MEM))
	logMe()
	logEnemy()
  console.log("Enemy still has " .. numEnemyPoke .. " poke alive")
	console.log("##########")
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
  console.log(memory.readbyte(MY_POKE_MEM))
	console.log("My Poke " .. pokemon_lookup[memory.readbyte(MY_POKE_MEM)])
	console.log("HP: " .. myHP())
	console.log("-------")
end

function runFromBattle()
	pressAndAdvance(RIGHT)
	goToMenuItem(1)
	pressAndAdvance(A,20)
	waitForNextTurn()
	console.log("Run attempt resolved")
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