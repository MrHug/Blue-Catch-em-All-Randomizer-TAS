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
		pressButton(A) -- Hit A
		advanceFrame(5) -- Wait for next textbox
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
	steps = steps or 2
	for i=1,steps do
		while memory.readbyte(MY_ANIM_CNT_MEM) == 0 do
			walkInDir(dir)
			advanceFrame(1)
		end
		while memory.readbyte(MY_ANIM_CNT_MEM) ~= 0 do
			advanceFrame(1)
		end
		
		checkInBattle()
	end
end

function takeHop(dir)
	walkInDir(dir)
	advanceFrame(1)
	walkInDir(dir)
	advanceFrame(42)
	checkInBattle()
end

function checkInBattle()
	if memory.readbyte(IN_BATTLE_MEM) > 0 then
		console.log("Battle detected")
		battleWild()
	end
end