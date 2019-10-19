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
	savestate.loadslot(4)
	while true do
		client.unpause()
	battleRival()
		client.pause()
		break;
	end
end

main()