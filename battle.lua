
BATTLE_TYPE_NONE = 0
BATTLE_TYPE_WILD = 1
BATTLE_TYPE_TRAINER = 2

STATE_BATTLE_OPENING = 0
STATE_BATTLE_DONE = 1
STATE_BATTLE_MY_TURN = 2
STATE_BATTLE_WFT = 3

STATE_BATTLE_OPENING_SUBSTATE_WFM0 = 0
STATE_BATTLE_OPENING_SUBSTATE_WFM1 = 1
STATE_BATTLE_OPENING_SUBSTATE_WFM0_2 = 2

-- Returns true if we handled it successfully or if there was no battle, false if we fainted!
function handleBattle()
	-- Check what type of battle we are in, if any
	handleTrainerWalkingUpToUs()
	
	local bType = getBattleType()
	if bType == BATTLE_TYPE_NONE or (bType ~= BATTLE_TYPE_WILD and bit.band(memory.readbyte(VARIOUS_FLAGS_3), 64) == 0) then
		return true
	end
	
	local data = {}
	data["state"] = STATE_BATTLE_OPENING
	log(L_VERBOSE, "************\nBATTLE: starting battle")
	
	while (true) do
		local state = data["state"]
		if state == STATE_BATTLE_OPENING then
			data = handleOpening(data)
		elseif state == STATE_BATTLE_MY_TURN then
			data = handleMyTurn(data)
		elseif state == STATE_BATTLE_WFT then
			data = handleWaitingForTurn(data)
		elseif state == STATE_BATTLE_DONE then
			pressAndAdvance(B,50) -- All trainers have some text right? :) TODO see if can be replaced by using better battle detection somehow. Currently fossil guy breaks this his battle bit is reset too early then set again and then reset.
			while bit.band(memory.readbyte(VARIOUS_FLAGS_3), 64) > 0 or getBattleType() == BATTLE_TYPE_WILD do
				pressAndAdvance(B)
			end
			log(L_VERBOSE, "Leaving battle state\n****************\n")
			return true
		else
			advanceFrame(1)
		end
	end
end

function handleTrainerWalkingUpToUs()
	-- NPC is approaching, but battle bit is not yet set.
	if bit.band(memory.readbyte(VARIOUS_FLAGS_7), 8) > 0 and bit.band(memory.readbyte(VARIOUS_FLAGS_3), 64) == 0 then
		log(L_INFO, "NPC approaching for battle")
		while not (bit.band(memory.readbyte(VARIOUS_FLAGS_3), 64) > 0) do
		  pressAndAdvance(B)
		end
	end
end

function handleOpening(data)	
	if data["substate"] == nil then
		data["substate"] = STATE_BATTLE_OPENING_SUBSTATE_WFM0
	end
	
	if data["substate"] == STATE_BATTLE_OPENING_SUBSTATE_WFM0 then
		if memory.readbyte(SELECTED_MENU_ITEM_MEM) ~= 0 then
			pressButton(B)
			pressAndAdvance(UP,1)
		end
		if memory.readbyte(SELECTED_MENU_ITEM_MEM) == 0 then
			data["substate"] = STATE_BATTLE_OPENING_SUBSTATE_WFM1
		end
	elseif data["substate"] == STATE_BATTLE_OPENING_SUBSTATE_WFM1 then
		if memory.readbyte(SELECTED_MENU_ITEM_MEM) ~= 1 then
			pressButton(B)
			pressAndAdvance(DOWN,1)
			advanceFrame(1)
		end
		if memory.readbyte(SELECTED_MENU_ITEM_MEM) == 1 then
			data["substate"] = STATE_BATTLE_OPENING_SUBSTATE_WFM0_2
		end
	elseif data["substate"] == STATE_BATTLE_OPENING_SUBSTATE_WFM0_2 then
		if memory.readbyte(SELECTED_MENU_ITEM_MEM) ~= 0 then
			pressButton(B)
			pressAndAdvance(UP,1)
		end
		if memory.readbyte(SELECTED_MENU_ITEM_MEM) == 0 then
			log(L_VERBOSE, "BATTLE: Swapping state to my turn")
			data["substate"] = nil
			data["state"] = STATE_BATTLE_MY_TURN
		end
	end
	return data
end

function handleMyTurn(data)
	goToMenuItem(0)
	if data["battleType"] == nil then
		data["battleType"] = getBattleType()
		log(L_VERBOSE, "I have determined we are in a battle of type " .. getBattleType())
	end
	if data["battleType"] == BATTLE_TYPE_TRAINER then
		return handleMyTrainerTurn(data)
	end
	return handleMyWildTurn(data)
end

function handleMyTrainerTurn(data)
	if data["numEnemyPoke"] == nil then
		data["numEnemyPoke"] = memory.readbyte(ENEMY_NUM_POKE_MEM)
		log(L_DEBUG, "Established we're fighting against this many pokes " .. data["numEnemyPoke"])
		--client.pause()
	end
	data['killedEnemy'] = nil
	logAll(L_VERBOSE, data["numEnemyPoke"])
	-- TODO add more logic than just attack in here
	pressAndAdvance(A)
	findAndPerformMostPowerfullMove()
	log(L_VERBOSE, "BATTLE: Swapping state to WFT")
	data["state"] = STATE_BATTLE_WFT
	return data
end

function handleWaitingForTurn(data)
	if enemyHP() == 0 and data['killedEnemy'] == nil then
		data['killedEnemy'] = true
		data['numEnemyPoke'] = data['numEnemyPoke'] - 1
		log(L_DEBUG, "Registered a kill, number of pokemon remaining " .. data['numEnemyPoke'])
	end
	if data['numEnemyPoke'] == 0 and getBattleType() == BATTLE_TYPE_NONE then
		log(L_VERBOSE, "BATTLE: Swapping state to done")
		data["state"] = STATE_BATTLE_DONE
		return data
	end
	return handleOpening(data)
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
  return y
end

function handleMyWildTurn(data)
	if data["numEnemyPoke"] == nil then
		data["numEnemyPoke"] = 1
	end
	logAll(L_VERBOSE, data["numEnemyPoke"])
	local pokeball_id = hasPokeballs()
	-- TODO expand logic
	if pokeball_id < 0 or own(memory.readbyte(ENEMY_POKE_MEM)) then
		runFromBattle()
		pressAndAdvance(B,50)
		if getBattleType() == BATTLE_TYPE_NONE then
			log(L_VERBOSE, "Run attempt worked")
			data["state"] = STATE_BATTLE_DONE
			return data
		end
	elseif enemyHP() > enemyMaxHP() / 2 then
		pressAndAdvance(A)
		findAndPerformCatchingMove()
	elseif throwPokeball() then
		log(L_VERBOSE, "BATTLE: Swapping state to Done after succesful catch, right log?")
		data["state"] = STATE_BATTLE_DONE
		return data
	end
	log(L_VERBOSE, "BATTLE: Swapping state to WFT")
	data["state"] = STATE_BATTLE_WFT
	return data
end

function throwPokeball()
  log(L_VERBOSE, "Trying to throw Pokeball")
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
    log(L_VERBOSE, "Caught it!")
    log(L_DEBUG, "Now own: " .. totalOwned())
    mashText(10)
    return true
  end
  return false
end

function mostPowerfullMoveID() 
  enemy_type1, enemy_type2 = enemyTypes()

  goToMenuItem(1)
  index = -1
  mostPower = 0
  log(L_VERBOSE, "******* Move selection starting ********")
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
    log(L_VERBOSE, combined .. "\t For: " .. movePower .. " " .. types_lookup[moveType] .. " " .. moveAcc .. " " .. eff)
    pressAndAdvance(DOWN)
  end
  log(L_VERBOSE, "********* END OF MOVE SELECTION ***********\n")
  if index < 0 then
    log(L_ERROR, "No moves that can damage enemy :(")
  end
  return index
end

function bestCatchingMoveID() 
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
    if 50 < combined and combined < 100 and movePP > 0 then
      index = i
    end
    log(L_VERBOSE, combined .. "\t For: " .. movePower .. " " .. types_lookup[moveType] .. " " .. moveAcc .. " " .. eff)
    pressAndAdvance(DOWN)
  end
  if index < 0 then
    log(L_ERROR, "No moves that can damage enemy for catching :(")
	index = mostPowerfullMoveID()
  end
  return index
end

function findAndPerformCatchingMove()
  local y = bestCatchingMoveID()
  local x = memory.readbyte(SELECTED_MENU_ITEM_MEM)
  while y ~= x do
    pressAndAdvance(DOWN)
    x = x + 1
    if x > 4 then
      x = 1
    end
  end
  pressAndAdvance(A)
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

function logAll(level, numEnemyPoke)
  log(level, "##########")
  log(level, "Turn: " .. memory.readbyte(IN_BATTLE_TURNS_MEM))
  logMe(level)
  logEnemy(level)
  log(level, "Enemy still has " .. numEnemyPoke .. " poke alive")
  log(level, "##########")
end

function logEnemy(level)
  log(level, "-------")
  log(level, "Facing " .. pokemon_lookup[memory.readbyte(ENEMY_POKE_MEM)])
  enemy_type1, enemy_type2 = enemyTypes()
  log(level, "Types: " .. types_lookup[enemy_type1] .. " " .. types_lookup[enemy_type2])
  log(level, "HP: " .. enemyHP())
  log(level, "-------")
end

function logMe(level)
  log(level, "-------")
  log(level, memory.readbyte(MY_POKE_MEM))
  if pokemon_lookup[memory.readbyte(MY_POKE_MEM)] ~= nil then
	log(level, "My Poke " .. pokemon_lookup[memory.readbyte(MY_POKE_MEM)])
  else
	log(level, "Cannot log poke for some reason?")
  end
  log(level, "HP: " .. myHP())
  log(level, "-------")
end

function runFromBattle()
  pressAndAdvance(RIGHT)
  goToMenuItem(1)
  pressAndAdvance(A,20)
  log(L_VERBOSE, "Run attempt done")
end

function getBattleType() 
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