function goToMartCounter()
	turnAndTakeSteps(UP,2)
	turnAndTakeSteps(LEFT,1)
end

function exitMart()
	turnAndTakeSteps(RIGHT,1)
	turnAndTakeSteps(DOWN,3)
	transition()
end

function talkToMart()
	pressAndAdvance(A,8)
end

function stopTalkingToMart()
	pressAndAdvance(B,5)
end

function buyItems()
	goToMenuItem(0)
	pressAndAdvance(A,8)
end

function buyItem(item, amount) 
	buyItems()
	n = memory.readbyte(MART_TOTAL_MEM)
	index = -1
	for i=0,(n-1) do
		console.log(items_lookup[memory.readbyte(MART_ITEM_OFFSET_MEM + i)])
		if memory.readbyte(MART_ITEM_OFFSET_MEM + i) == item then
			index = i
			break
		end
	end
	if index == -1 then
		console.log("Item not for sale :(")
	end
	goDir(DOWN,index)
	pressAndAdvance(A,15) -- Confirm Item
	goDir(UP,amount-1) -- Select Amount
	pressAndAdvance(A,10) -- Confirm Amount
	mashText(1)
	pressAndAdvance(A,40) -- Confirm payment
	pressAndAdvance(A,5) 
	pressAndAdvance(B,5) -- Back to Main mart menu
end