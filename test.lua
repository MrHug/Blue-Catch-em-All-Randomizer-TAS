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


function main()
	memory.usememorydomain("System Bus")
	console.clear()
	savestate.loadslot(6)
	while true do
		client.unpause()
	viridian_entrace_to_mart()
	getOaksParcel()
	viridian_mart_to_entrance()
	route1_viridian_to_pallet_encounterless()
	pallet_entrance_to_lab()
	oaks_lab_behind_oak()
	handoverParcel()
	behind_oak_exit_lab()
		client.pause()
		break;
	end
end

main()