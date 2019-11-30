package.loaded["mart"] = nil
require "mart"
package.loaded["map_reading"] = nil
require "map_reading"

hadBattle = false

function walkInDir(dir)
	input = {}
	input[B] = true
	input[dir] = true
	--console.log(input)
	joypad.set(input)
end

function pressButton(button)
    input = {}
	input[button] = true
	joypad.set(input)
end

function pressAndAdvance(button, frames)
	frames = frames or 5
	pressButton(button)
	advanceFrame(1)
	pressButton(button)
	advanceFrame(frames-1)
end

function mashText(num)
	for i=1,num do
		pressAndAdvance(A,5) -- Hit A
	end
end


function transition()
	advanceFrame(28)
end

function advanceFrame(num)
	for i=1,num do
		emu.frameadvance()
	end
end

function turn(dir)
	cnt = 0
	while memory.readbyte(MY_DIR_MEM) ~= dir_map[dir] do
		if cnt == 0 then
			pressButton(dir)
		elseif cnt == 2 then
			cnt = -1
		end
		cnt = cnt + 1
		advanceFrame(1)
		checkInBattle()
	end
end

function turnAndTakeSteps(dir, steps)
	steps = steps or 1
	turn(dir)
	takeSteps(dir, steps)
end

function takeSteps(dir, steps)
	steps = steps or 1
	for i=1,steps do
		while memory.readbyte(MY_X_DELTA_MEM) + memory.readbyte(MY_Y_DELTA_MEM) == 0 do
			walkInDir(dir)
			advanceFrame(1)
			checkInBattle()
		end
		while memory.readbyte(MY_X_DELTA_MEM) + memory.readbyte(MY_Y_DELTA_MEM) ~= 0 do
			advanceFrame(1)
			checkInBattle()
		end
	end
end


function takeHop(dir)
	takeSteps(dir,1)
	checkInBattle()
end

function checkInBattle()
	if memory.readbyte(IN_BATTLE_MEM) > 0 and memory.readbyte(IN_BATTLE_MEM) < 100 then
		console.log("Battle detected: " .. memory.readbyte(IN_BATTLE_MEM))
		hadBattle = true
		savestate.saveslot(8)
		battleWild()
	end
end

function goToMenuItem(id)
	while memory.readbyte(SELECTED_MENU_ITEM_MEM) < id do
		pressAndAdvance(DOWN, 4)
	end
	while memory.readbyte(SELECTED_MENU_ITEM_MEM) > id do
		pressAndAdvance(UP, 4)
	end
end

function findItemInInventory(item_id)
	total_items = memory.readbyte(TOTAL_ITEMS_MEM)
	for i=0,total_items-1 do
		if memory.readbyte(ITEM_1_MEM + 2*i) == item_id then
			return i
		end
	end
end

function goDir(dir, num)
	num = num or 1
	for i=1,num do
		pressAndAdvance(dir,3)
	end
end

function own(pokemon_id)
	pokedex_id = pokemon_hex_to_pokedex[pokemon_id]
	console.log("Checking if we own: " .. pokemon_lookup[pokemon_id] .. " number " .. pokedex_id)
	cnt = 0
	while pokedex_id > 8 do
		pokedex_id = pokedex_id - 8
		cnt = cnt + 1
	end
	full_byte = memory.readbyte(POKE_OWNED_MEM + cnt)
	cnt = 1
	result = false
	--console.log("Checking in byte " .. full_byte .. " checking bit " .. pokedex_id)
	while full_byte	> 0 do
		if full_byte % 2 == 1 then
			if cnt == pokedex_id then
				result = true
				break
			end
			full_byte = full_byte -1
		end
		full_byte = full_byte / 2
		cnt = cnt + 1
	end
	return result
end

function totalOwned()
	owned = 0
	for i=0,19 do
		owned = owned + countHighBits(memory.readbyte(POKE_OWNED_MEM+i))
	end
	return owned
end

function countHighBits(inputByte)
	cnt = 0
	while inputByte > 0 do
		if inputByte % 2 == 1 then
			cnt = cnt + 1
			inputByte = inputByte -1
		end
		inputByte = inputByte / 2
	end
	return cnt
end

function enterCenterAndHeal()
	turnAndTakeSteps(UP,1)
	transition()
	turnAndTakeSteps(UP,4)
	pressAndAdvance(A)
	mashText(3)
	pressAndAdvance(A)
	mashTillTurned(DOWN)
end

function exitCenterAfterHeal()
	turnAndTakeSteps(DOWN,5)
	transition()
end

function mashTillTurned(dir)
	cnt = 0
	while memory.readbyte(MY_DIR_MEM) ~= dir_map[dir] do
		if cnt <= 1 then
			pressButton(dir)
		elseif cnt == 4 then
			cnt = -1
		end
		pressButton(B)
		cnt = cnt + 1
		advanceFrame(1)
		checkInBattle()
	end
end

function lookForEncounter()
	hadBattle = false
	while hadBattle == false do
		turn(RIGHT)
		turn(LEFT)
	end
end

function pickupItem(dir)
	pressAndAdvance(A,1)
	mashTillTurned(dir)
end

function walkTo(dst, dir)
  myY, myX = getMyPos()
  while myX ~= dst[1] or myY ~= dst[0] do
    a = findPathFromCurPos(dst)
    if a and #a > 0 then
      walkPath(a)
    else 
      console.log("Error: no path found!")
      return false
    end
    myY, myX = getMyPos()
  end
  if dir then
    turn(dir)
  end
  return true
end

function findPathFromCurPos(dst)
	map = readMap()
	_, _, src = getMyPos()
	return findPath(src, dst, map)
end

function findPath(src, dst, map)
    local queue = {src}
	
    local visited = {}
	local prev = {}
	for i=0,#map do
		visited[i] = {}
		prev[i] = {}
		for j=0,#map[i] do
			visited[i][j] = 0
			prev[i][j] = {}
		end
	end
	visited[src[0]][src[1]] = 1
	
	x_dir = {[1] = 1, [2] = -1, [3] = 0, [4] = 0}
	y_dir = {[1] = 0, [2] = 0, [3] = 1, [4] = -1}
	
	cnt = 0
	while 0 < #queue do
		node = table.remove(queue)
		cur_x = node[0]
		cur_y = node[1]
		
		--console.log(cur_x .. ":" .. cur_y)
		if node[0] == dst[0] and node[1] == dst[1] then
			return buildPath(src, dst, prev)
		end
		for i=1,4 do
			neighbour = {[0] = cur_x + x_dir[i], [1] = cur_y + y_dir[i]}
			
			if map[neighbour[0]] ~= nil and map[neighbour[0]][neighbour[1]] > 0 then 
				if visited[neighbour[0]][neighbour[1]] ~= 1 then
					visited[neighbour[0]][neighbour[1]] = 1
					prev[neighbour[0]][neighbour[1]] = node
					--console.log("Added " .. neighbour[0] .. ":" .. neighbour[1])
					table.insert(queue, 1, neighbour)
				end
			end
		end
		--logArray(queue)
		cnt = cnt + 1
		if cnt > 500 then
			console.log("TIMEOUT")
			break
		end
	end
	return false
end

function buildPath(src, dst, prev)
	path = {dst}
	console.log("Building path")
	while dst[0] ~= src[0] or dst[1] ~= src[1] do 
		dst = prev[dst[0]][dst[1]]
		--console.log(dst[0] .. ":" .. dst[1])
		table.insert(path, 1, dst)
	end
	return path 
end

function logArray(arr) 
	for i,v in ipairs(arr) do print(i,v) end
end

function walkPath(path)
	for i,v in ipairs(path) do
		my_x = memory.readbyte(MY_X_MEM)
		my_y = memory.readbyte(MY_Y_MEM)
		
		if (my_x < v[1]) then
			turnAndTakeSteps(RIGHT)
		elseif (my_x > v[1]) then
			turnAndTakeSteps(LEFT)
		else 
			if (my_y < v[0]) then
				turnAndTakeSteps(DOWN,1)
			elseif (my_y > v[0]) then
				turnAndTakeSteps (UP, 1)
			end
		end
  	my_x = memory.readbyte(MY_X_MEM)
		my_y = memory.readbyte(MY_Y_MEM)
    if (my_x ~= v[1] or my_y ~= v[0]) then
      console.log("Path interrupted!")
      return false
    end
	end
  return true
end

function getMyPos()
  src = {
		[0] = memory.readbyte(MY_Y_MEM),
		[1] = memory.readbyte(MY_X_MEM),
	}
  return src[0], src[1], src
end
