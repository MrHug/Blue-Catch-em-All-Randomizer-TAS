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
package.loaded["log"] = nil
require "log"



function main()
	memory.usememorydomain("System Bus")
	console.clear()
	-- savestate.loadslot(1)
	-- savestate.loadslot(2)
	savestate.loadslot(4)
	set_loglevel(L_VERBOSE)
	client.unpause()
	client.speedmode(200)
	while true do
		walkTo(moon_route_4_f3_fossil)
		--savestate.saveslot(3)
		break
	end
  client.pause()
end

main()
