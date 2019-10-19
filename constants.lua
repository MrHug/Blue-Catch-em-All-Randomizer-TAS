package.loaded["items"] = nil
require "items"
package.loaded["pokemons"] = nil
require "pokemons"
package.loaded["types"] = nil
require "types"


RIGHT = 'Right'
LEFT = 'Left'
UP = 'Up'
DOWN = 'Down'
A = 'A'
B = 'B'
START = 'Start'

POKEBALL_ID = 4

MY_DIR_MEM = 0xC109
MY_ANIM_CNT_MEM = 0xC108

SPRITE_X_POS_MEM = 0xC106
SPRITE_Y_POS_MEM = 0xC104

DIR_DOWN = 0x0
DIR_UP = 0x4
DIR_LEFT = 0x8
DIR_RIGHT = 0xC

dir_map = {
	[LEFT] = DIR_LEFT,
	[UP] = DIR_UP,
	[DOWN] = DIR_DOWN,
	[RIGHT] = DIR_RIGHT
}

X_COORD_MENU_MEM = 0xCC24

IN_BATTLE_MEM = 0xD057

MY_POKE_MOVE_1_MEM = 0xD01C
MY_SELECTED_MOVE_POWER = 0xCFD4
MY_SELECTED_MOVE_TYPE = 0xCFD5
MY_SELECTED_MOVE_ACC = 0xCFD6

ENEMY_POKE_MEM = 0xCFE5 
ENEMY_TYPE_1_MEM = 0xCFEA
ENEMY_TYPE_2_MEM = 0xCFEB
ENEMY_HP_MEM = 0xCFE6


MY_NUM_OF_POKES = 0xD163 
MY_POKE_MEM = 0xD014
MY_HP_MEM = 0xD015

TOTAL_ITEMS_MEM=0xD31D
ITEM_1_MEM=0xD31E
ITEM_1_QUANTITY_MEM=0xD31F