package.loaded["constants"] = nil
require "constants"
package.loaded["util_functions"] = nil
require "util_functions"
package.loaded["routes"] = nil
require "routes"
package.loaded["battle"] = nil
require "battle"
package.loaded["start_game"] = nil
require "start_game"
package.loaded["new_game"] = nil
require "new_game"

function main()
	memory.usememorydomain("System Bus")
	console.clear()
	savestate.loadslot(3)
	client.unpause()
	while true do
		console.log(own(152))
		--turnAndTakeSteps(DOWN,12)
		while 1 > 0 do
			turnAndTakeSteps(RIGHT)
			turnAndTakeSteps(LEFT)
		end
		client.pause()
		break;
	end
end

main()