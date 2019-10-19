package.loaded["mart"] = nil
require "mart"

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
	while memory.readbyte(MY_DIR_MEM) ~= dir_map[dir] do
		pressButton(dir)	
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

function goDir(dir, num)
	num = num or 1
	for i=1,num do
		pressAndAdvance(dir,3)
	end
end