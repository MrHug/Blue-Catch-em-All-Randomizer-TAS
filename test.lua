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
	--savestate.loadslot(1)
	client.unpause()
	while true do
    savestate.loadslot(0)
    walkTo(cerulean_center)
    healAndExit()
    walkTo(cerulean_route_24)
    turnAndTakeSteps(UP)
    walkTo(route_24_route_25)
    savestate.saveslot(9)
    break
	end
  client.pause()
end

main()