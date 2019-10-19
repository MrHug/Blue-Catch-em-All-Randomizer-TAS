function new_game()
	client.reboot_core()
	memory.usememorydomain("System Bus")
	console.log("Let's do this!")
	get_to_menu()
	options()
	set_name()
	mashText(2)
	advanceFrame(50)
	mashText(6)
	advanceFrame(160)
end

function get_to_menu()
	advanceFrame(600)
	pressButton(A)
	advanceFrame(20)
	pressButton(A)
	advanceFrame(250)
	pressButton(A)
	advanceFrame(100)
end

function options()
	pressButton(DOWN)
	advanceFrame(4)
	pressButton(A)
	advanceFrame(23)
	pressButton(DOWN)
	advanceFrame(4)
	pressButton(DOWN)
	advanceFrame(4)
	pressButton(RIGHT)
	advanceFrame(4)
	pressButton(DOWN)
	advanceFrame(4)
	pressButton(RIGHT)
	advanceFrame(4)
	pressButton(B)
	advanceFrame(40)
end

function set_name()
	pressButton(A)
	advanceFrame(105)
	mashText(5)
	advanceFrame(50)
	mashText(4)
	advanceFrame(100)
	mashText(8)
	advanceFrame(80)
	mashText(1)
	advanceFrame(15)
	mashText(1)
	advanceFrame(10)
	savestate.saveslot(1)
	input_mrhug()
	mashText(3)
	advanceFrame(100)
	mashText(4)
	advanceFrame(15)
	mashText(1)
	advanceFrame(10)
	input_aurei()
end



function input_mrhug()
	goDir(DOWN)
	goDir(RIGHT,3)
	pressAndAdvance(A,10) -- M
	goDir(RIGHT,5)
	pressAndAdvance(A,10) -- R
	goDir(UP)
	goDir(LEFT)
	pressAndAdvance(A,10) -- H
	goDir(DOWN,2)
	goDir(RIGHT,4)
	pressAndAdvance(A,10) -- U
	goDir(LEFT,5)
	goDir(UP,2)
	pressAndAdvance(A,10) -- G
	pressAndAdvance(START,30)
end

function input_aurei()
	pressAndAdvance(A,10) -- A
	goDir(DOWN,2)
	goDir(RIGHT,2)
	pressAndAdvance(A,10) -- U
	
	goDir(LEFT,3)
	goDir(UP)
	pressAndAdvance(A,10) -- R
	
	goDir(UP)
	goDir(LEFT,4)
	pressAndAdvance(A,10) -- E
	
	goDir(RIGHT,4)
	pressAndAdvance(A,10) -- E

	pressAndAdvance(START,30)
end