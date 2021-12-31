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
	savestate.loadslot(7)
	set_loglevel(L_DEBUG)
	client.unpause()
	client.speedmode(3500)
--	while true do
	teachTM(196,1,0)
	walkTo(vermillion_cutbush)
	turn(DOWN)
	useCut()
	walkTo(vermillion_gym)
	turnAndTakeSteps(UP)
	transition()
		--savestate.saveslot(3)
		--break
	--end
  client.pause()
end

main()
