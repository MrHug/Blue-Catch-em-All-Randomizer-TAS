package.loaded["constants"] = nil
require "constants"
package.loaded["util_functions"] = nil
require "util_functions"
package.loaded["battle"] = nil
require "battle"
package.loaded["routes"] = nil
require "routes"
package.loaded["new_game"] = nil
require "new_game"
package.loaded["start_game"] = nil
require "start_game"



function main()
	memory.usememorydomain("System Bus")
	console.clear()
	set_loglevel(L_INFO)
	client.speedmode(3000)
	client.unpause()
	new_game()
	client.speedmode(2000)
	start_game()
	console.log("That's all we've got so far :)")
	client.pause()
end

main()