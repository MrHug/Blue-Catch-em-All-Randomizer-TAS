package.loaded["mart"] = nil
require "mart"
package.loaded["map_reading"] = nil
require "map_reading"
package.loaded["locationsmapping"] = nil
require "locationsmapping"

PriorityQueue = dofile("priorityqueue.lua")

hadBattle = false

function walkInDir(dir)
	local input = {}
	input[B] = true
	input[dir] = true
	--console.log(input)
	joypad.set(input)
end

function pressButton(button)
  local input = {}
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
	local cnt = 0
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
		console.log("Battle detected of type: " .. memory.readbyte(IN_BATTLE_MEM))
		hadBattle = true
		savestate.saveslot(8)
    if battleType() == BATTLE_WILD then
      battleWild()
    else 
      battleTrainer()
    end
	end
end

function goToMenuItem(id, additional_button)
	while memory.readbyte(SELECTED_MENU_ITEM_MEM) < id do
		pressAndAdvance(DOWN, 4)
    if additional_button then
      pressAndAdvance(additional_button, 1)
    end
	end
	while memory.readbyte(SELECTED_MENU_ITEM_MEM) > id do
		pressAndAdvance(UP, 4)
    if additional_button then
      pressAndAdvance(additional_button, 1)
    end
	end
end

function findItemInInventory(item_id)
	local total_items = memory.readbyte(TOTAL_ITEMS_MEM)
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
	local pokedex_id = pokemon_hex_to_pokedex[pokemon_id]
	console.log("Checking if we own: " .. pokemon_lookup[pokemon_id] .. " number " .. pokedex_id)
	local cnt = 0
	while pokedex_id > 8 do
		pokedex_id = pokedex_id - 8
		cnt = cnt + 1
	end
	local full_byte = memory.readbyte(POKE_OWNED_MEM + cnt)
	cnt = 1
	local result = false
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
	local owned = 0
	for i=0,19 do
		owned = owned + countHighBits(memory.readbyte(POKE_OWNED_MEM+i))
	end
	return owned
end

function countHighBits(inputByte)
	local cnt = 0
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
	turnAndTakeSteps(UP)
	transition()
	walkTo(pokecenter_counter)
	pressAndAdvance(A)
	mashText(3)
	pressAndAdvance(A)
	mashTillTurned(DOWN)
end

function exitCenterAfterHeal()
	walkTo(pokecenter_exit)
  turnAndTakeSteps(DOWN)
	transition()
end

function mashTillTurned(dir)
	local cnt = 0
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

function mashTillBattle(btn)
	local cnt = 0
	while memory.readbyte(IN_BATTLE_MEM) == 0 do
		if cnt <= 1 then
			pressButton(btn)
		elseif cnt == 4 then
			cnt = -1
		end
		cnt = cnt + 1
		advanceFrame(1)
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

function pickupFossil()
  mashText(15)
  mashTillTurned(DOWN)
  turnAndTakeSteps(UP)
end

function walkTo(dst, dir)
  local myY, myX, src = getMyPos()
  local cnt = 0
  while myX ~= dst[1] or myY ~= dst[0] do
    printSrcDst(src, dst)
    local a = findPathFromCurPos(dst)
    if a and #a > 0 then
      if not walkPath(a) then
        cnt = cnt + 1
      end
      if cnt >= 10 then
        return false
      end
    else 
      console.log("Error: no path found!")
      return false
    end
    myY, myX, src = getMyPos()
  end
  if dir then
    turn(dir)
  end
  return true
end

function findPathFromCurPos(dst)
	local map = readMap()
	local _, _, src = getMyPos()
	return findPath(src, dst, map)
end

function findPath(src, dst, map)
  local queue = PriorityQueue()
  queue:put(src,0)
  
  -- Init visited and prev --
  local visited = {}
	local prev = {}
  local dist = {}
	for i=0,#map do
		visited[i] = {}
		prev[i] = {}
    dist[i] = {}
		for j=0,#map[i] do
			visited[i][j] = 0
			prev[i][j] = {}
      dist[i][j] = 10000000
		end
	end
  dist[src[0]][src[1]] = 0
	
  -- 4 directions
	local x_dir = {[1] = 1, [2] = -1, [3] = 0, [4] = 0}
	local y_dir = {[1] = 0, [2] = 0, [3] = 1, [4] = -1}
	
  -- Keep a timeout
	local cnt = 0
  
  -- Start looping
	while 0 < queue:size() do
		local node, prio = queue:pop()
		local cur_y = node[0]
		local cur_x = node[1]
    
    if visited[cur_y][cur_x] ~= 1 then
      visited[cur_y][cur_x] = 1
      
      -- console.log(cur_x .. ":" .. cur_y)
      
      -- Are we there yet?
      if node[0] == dst[0] and node[1] == dst[1] then
        return buildPath(src, dst, prev)
      end
      
      -- Check all directions
      for i=1,4 do
        neighbour = {[0] = cur_y + x_dir[i], [1] = cur_x + y_dir[i]}
        if map[neighbour[0]] == nil or map[neighbour[0]][neighbour[1]] == nil or visited[neighbour[0]][neighbour[1]] == 1 then -- Impossible spot or already done
          -- Pass
        else 			
          local neighbour_value = map[neighbour[0]][neighbour[1]]
          
          local lastDir = getDir(prev[cur_y][cur_x], node)
          local curDir = getDir(node, neighbour)
          
          -- Prefer not turning
          if lastDir ~= curDir and neighbour_value > 0 then
            neighbour_value = neighbour_value + 1
          end
          
          -- It's a hop!
          if curDir == DOWN and neighbour_value == -1 and map[neighbour[0] + 1] ~= nil then
              neighbour_value = map[neighbour[0]+1][neighbour[1]]
              neighbour[0] = neighbour[0] + 1
          end
          
          local heuristic_add = metropolitanDistance(node, neighbour)
          
          -- Found something better?
          --console.log(dist[neighbour[0]][neighbour[1]])
          if neighbour_value > 0 and prio + neighbour_value + heuristic_add < dist[neighbour[0]][neighbour[1]]  then
            dist[neighbour[0]][neighbour[1]] = prio + neighbour_value + heuristic_add
            prev[neighbour[0]][neighbour[1]] = node
            --console.log("Added " .. neighbour[0] .. ":" .. neighbour[1])
            queue:put(neighbour, dist[neighbour[0]][neighbour[1]])
          end
        end
      end
      --logArray(queue)
      cnt = cnt + 1
      if cnt > 1250 then
        console.log("TIMEOUT, got to (" .. cur_y .. "," .. cur_x .. ")")
        break
      end
    end
	end
	return false
end

function metropolitanDistance(src, dst)
  return math.abs(src[0] - dst[0]) + math.abs(src[1] - dst[1])
end

function getDir(src, dst)
  if src == nil or dst == nil or src[0] == nil or src[1] == nil or dst[0] == nil or dst[1] == nil then
    return false
  end
  
  if (src[1] < dst[1]) then
    return RIGHT
  elseif (src[1] > dst[1]) then
    return LEFT
  else 
    if (src[0] < dst[0]) then
      return DOWN
    elseif (src[0] > dst[0]) then
      return UP
    end
  end
  return false
end

function buildPath(src, dst, prev)
	local path = {dst}
	--console.log("Building path")
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
	local my_y, my_x, src = getMyPos()
  for i,v in ipairs(path) do
			
		local dir = getDir(src, v)
    if dir then
      turnAndTakeSteps(dir)
    end
    
  	my_y , my_x, src = getMyPos()
    local cnt = 0
    while (my_x ~= v[1] or my_y ~= v[0]) do
      advanceFrame(1)
      cnt = cnt + 1
      if (cnt > 20) then
        console.log("-----")
        console.log("Path interrupted when:")
        printSrcDst(src, v)
        console.log("-----")
        return false
      end
    end
	end
  return true
end

function getMyPos()
  local src = {
		[0] = memory.readbyte(MY_Y_MEM),
		[1] = memory.readbyte(MY_X_MEM),
	}
  return src[0], src[1], src
end

function printSrcDst(src, dst)
  console.log("Going from (" .. src[1] .. "," .. src[0] .. ")")
  console.log("Going to (" .. dst[1] .. "," .. dst[0] .. ")")
end

function healAndExit()
  enterCenterAndHeal()
  exitCenterAfterHeal()
end


function battleGymLeader()
  pressAndAdvance(A)
  mashTillBattle(B)
  battleTrainer()
  mashTillTurned(DOWN)
end

function printStatus()
	local badges = getBadges()
	console.log("Badges obtained: ")
	console.log(badges)
	
	local pos, mapnum = getLocation()
	
	console.log("Location: ")
	console.log(pos)
	console.log(mapnum_to_location[mapnum])
end

function getLocation()
	local _, _, pos = getMyPos()
	local mapnum =  memory.readbyte(MAP_NUM_MEM)
	return pos, mapnum
end

function getBadges()
	local badgesMem = memory.readbyte(BADGES_MEM)
	local badges = {}
	local p = 128
	local cnt = 8
	while badgesMem > 0 do
		if badgesMem >= p then
			badgesMem = badgesMem - p
			badges[cnt] = 1
		else
			badges[cnt] = 0
		end
		cnt = cnt - 1
		p = p / 2
	end
	return badges
end