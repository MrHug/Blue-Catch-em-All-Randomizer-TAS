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
	savestate.loadslot(6)
	while true do
		client.unpause()
		viridian_entrace_to_mart()
	getOaksParcel()
		client.pause()
		break;
	end
end

main()