# Makefile for Minecraft crafting recipes
# simulate crafting with make and linux commands

KEEP_FILES = Makefile README.md .gitignore LICENSE

RED	   := $(shell printf '\033[0;31m')
GREEN  := $(shell printf '\033[0;32m')
YELLOW := $(shell printf '\033[0;33m')
BLUE   := $(shell printf '\033[0;34m')
CYAN   := $(shell printf '\033[0;36m')
MAGENTA:= $(shell printf '\033[0;35m')
BOLD   := $(shell printf '\033[1m')
RESET  := $(shell printf '\033[0m')

.PHONY: all clean

# --- DEFINICE SEZNAMŮ ---
PICKAXES = diamond_pickaxe iron_pickaxe stone_pickaxe wooden_pickaxe
SHOVELS  = diamond_shovel iron_shovel stone_shovel wooden_shovel
AXES     = diamond_axe iron_axe stone_axe wooden_axe
SWORDS   = diamond_sword iron_sword stone_sword wooden_sword
HOES     = diamond_hoe iron_hoe stone_hoe wooden_hoe

ARMOR = diamond_helmet iron_helmet leather_helmet \
        diamond_chestplate iron_chestplate leather_chestplate \
        diamond_leggings iron_leggings leather_leggings \
        diamond_boots iron_boots leather_boots

IRON_SET = iron_helmet iron_chestplate iron_leggings iron_boots
DIAMOND_SET = diamond_helmet diamond_chestplate diamond_leggings diamond_boots
LEATHER_SET = leather_helmet leather_chestplate leather_leggings leather_boots

# Logika pro "jakýkoliv" dostupný nástroj
PICKAXE = $(firstword $(wildcard diamond_pickaxe iron_pickaxe stone_pickaxe wooden_pickaxe))
SHOVEL = $(firstword $(wildcard diamond_shovel iron_shovel stone_shovel wooden_shovel))
AXE = $(firstword $(wildcard diamond_axe iron_axe stone_axe wooden_axe))
SWORD = $(firstword $(wildcard diamond_sword iron_sword stone_sword wooden_sword))
HOE = $(firstword $(wildcard diamond_hoe iron_hoe stone_hoe wooden_hoe))

# Armor
HELMET = $(firstword $(wildcard diamond_helmet iron_helmet leather_helmet))
CHESTPLATE = $(firstword $(wildcard diamond_chestplate iron_chestplate leather_chestplate))
LEGGINGS = $(firstword $(wildcard diamond_leggings iron_leggings leather_leggings))
BOOTS = $(firstword $(wildcard diamond_boots iron_boots leather_boots))

all: neather_portal

# --- AKCE ---

visit_nether: neather_portal $(DIAMOND_SET) baked_potato enchanted_book
	@echo "Equipping full $(BLUE)diamond armor$(RESET) for maximum safety..."
	@echo "$(MAGENTA)Visiting$(RESET) the Nether..."
	@touch $@

visit_cave: $(LEATHER_SET)
	@echo "Equipping full $(BLUE)armor$(RESET) for safety..."
	@echo "$(MAGENTA)Visiting$(RESET) the cave to mine resources..."
	@touch $@

visit_forest: 
	@echo "$(MAGENTA)Visiting$(RESET) the forest..."
	@touch $@

visit_meadow:
	@echo "$(MAGENTA)Visiting$(RESET) the meadow..."
	@touch $@

visit_river:
	@echo "$(MAGENTA)Visiting$(RESET) the river..."
	@touch $@

go_out_in_the_night: iron_sword $(IRON_SET) bread bed
	@echo "Equipping full $(BLUE)iron armor$(RESET) and an $(BLUE)iron sword$(RESET) for safety..."
	@echo "Waiting for night"
	@echo "Going out at night to find mobs..."
	@touch $@


# --- BUILDING ---

base: house farm
	@echo "$(GREEN)Building$(RESET) a base with a house and a farm..."
	@touch $@

neather_portal: obsidian flint_and_steel castle iron_pickaxe bread
	@echo "$(GREEN)Building$(RESET) Nether Portal with obsidian and flint and steel..."
	@touch $@

house: oak_planks cobblestone crafting_table furnace item_frame bed glass oak_door chest
	@echo "$(GREEN)Building$(RESET) a house and placing a crafting table and furnace..."
	@touch $@

castle: stone_bricks oak_planks crafting_table furnace item_frame painting bed glass iron_door chest | base
	@echo "$(GREEN)Building$(RESET) a castle with stone bricks and oak planks..."
	@touch $@

farm: seeds wooden_hoe bucket_of_water oak_fence oak_fence_gate
	@echo "$(GREEN)Setting up$(RESET) a farm with seeds using $(HOE)..."
	@touch $@

# --- COOKING ---

bread: wheat
	@echo "$(YELLOW)Crafting$(RESET) bread from wheat..."
	@touch $@

baked_potato: potato coal | furnace 
	@echo "Baking potato in the furnace..."
	@touch $@

cooked_beef: beef coal | furnace
	@echo "Cooking beef in the furnace..."
	@touch $@

cooked_cod: cod coal | furnace
	@echo "Cooking cod in the furnace..."
	@touch $@

# --- FARMING ---

cod: oak_boat fishing_rod | visit_river
	@echo "Fishing for cod in the river..."
	@touch $@

potato: visit_meadow
	@echo "Harvesting potatoes from the meadow..."
	@touch $@

wheat: seeds wooden_hoe farm
	@echo "Farming wheat with $(HOE) on the farm..."
	@touch $@

seeds: wooden_hoe | visit_meadow
	@echo "Farming seeds with $(HOE) in the meadow..."
	@touch $@

bucket_of_water: bucket | visit_river
	@echo "Filling bucket with water from the river..."
	@touch $@

# --- TĚŽBA ---

sand: wooden_shovel | visit_river
	@echo "$(CYAN)Mining$(RESET) sand with $(SHOVEL)..."
	@touch $@

obsidian: diamond_pickaxe | visit_cave
	@echo "$(CYAN)Mining$(RESET) obsidian with $(PICKAXE)..."
	@touch $@

coal: stone_pickaxe | visit_cave
	@echo "$(CYAN)Mining$(RESET) coal with $(PICKAXE)..."
	@touch $@

cobblestone: wooden_pickaxe | visit_cave
	@echo "$(CYAN)Mining$(RESET) cobblestone with $(PICKAXE)..."
	@touch $@

diamond: iron_pickaxe $(IRON_SET) | visit_cave
	@echo "Equipping full $(BLUE)iron armor$(RESET) for safety..."
	@echo "$(CYAN)Mining$(RESET) diamond with $(BLUE)$(PICKAXE)$(RESET)..."
	@touch $@

gravel: wooden_shovel
	@echo "$(CYAN)Mining$(RESET) gravel with $(SHOVEL)..."
	@touch $@

flint: gravel stone_shovel
	@echo "Mining flint from gravel..."
	@touch $@

# Dynamicky vytvoříme rudy, aby bylo co tavit
iron_ore gold_ore copper_ore: stone_pickaxe
	@echo "$(CYAN)Mining$(RESET) $@ with $(PICKAXE)..."
	@touch $@

# --- GENERICKÉ PRAVIDLO (Pattern Rule) ---
# % funguje jako wildcard. Pokud make hledá "iron_ingot", dosadí za % "iron".
# Vyžaduje k tomu soubor "%_ore" (např. iron_ore) a pec (furnace) a uhlí (coal).

%_ingot: %_ore furnace coal
	@echo "Smelting $(notdir $<) in the furnace to create $@..."
	@touch $@

# --- NÁSTROJE ---

oak_boat: oak_planks | crafting_table
	@echo "$(YELLOW)Crafting$(RESET) oak boat from oak planks..."
	@touch $@

fishing_rod: stick string | crafting_table
	@echo "$(YELLOW)Crafting$(RESET) fishing rod from stick and string..."
	@touch $@

# --- SPECIFICKÉ PATTERN PRAVIDLA PRO NÁSTROJE ---

# Nástroje vyžadují: materiál + tyčky + stůl
%_pickaxe: %_material stick crafting_table
	@echo "$(YELLOW)Crafting$(RESET) tool $@ from $<..."
	@touch $@

%_shovel: %_material stick crafting_table
	@echo "$(YELLOW)Crafting$(RESET) tool $@ from $<..."
	@touch $@

%_axe: %_material stick crafting_table
	@echo "$(YELLOW)Crafting$(RESET) tool $@ from $<..."
	@touch $@

%_sword: %_material stick crafting_table
	@echo "$(YELLOW)Crafting$(RESET) sword $@ from $<..."
	@touch $@

%_hoe: %_material stick crafting_table
	@echo "$(YELLOW)Crafting$(RESET) hoe $@ from $<..."
	@touch $@

# --- PATTERN PRAVIDLA PRO ZBROJ ---

# Zbroj vyžaduje: materiál + stůl (bez tyček)
%_helmet: %_material crafting_table
	@echo "$(YELLOW)Crafting$(RESET) armor $@ from $<..."
	@touch $@

%_chestplate: %_material crafting_table
	@echo "$(YELLOW)Crafting$(RESET) armor $@ from $<..."
	@touch $@

%_leggings: %_material crafting_table
	@echo "$(YELLOW)Crafting$(RESET) armor $@ from $<..."
	@touch $@

%_boots: %_material crafting_table
	@echo "$(YELLOW)Crafting$(RESET) armor $@ from $<..."
	@touch $@

# Definice, co je materialem pro dany typ (alias pro pattern rule)
diamond_material: diamond
	@ln -sf $< $@
gold_material: gold_ore
	@ln -sf $< $@
iron_material: iron_ingot
	@ln -sf $< $@
stone_material: cobblestone
	@ln -sf $< $@
wooden_material: oak_planks
	@ln -sf $< $@
leather_material: leather
	@ln -sf $< $@

# --- KONKRÉTNÍ RECEPTY ---

stone_bricks: stone | crafting_table
	@echo "$(YELLOW)Crafting$(RESET) stone bricks from stone..."
	@touch $@

stone: cobblestone coal | furnace 
	@echo "Smelting cobblestone in the furnace to create stone..."
	@touch $@

iron_door: iron_ingot | crafting_table
	@echo "$(YELLOW)Crafting$(RESET) iron door from iron ingots..."
	@touch $@

string: go_out_in_the_night | visit_forest
	@echo "Collecting string from spiders in the forest..."
	@touch $@

glass: sand furnace coal
	@echo "Smelting sand in the furnace to create glass..."
	@touch $@

bucket: iron_ingot
	@echo "$(YELLOW)Crafting$(RESET) bucket from iron ingots..."
	@touch $@

flint_and_steel: iron_ingot flint
	@echo "$(YELLOW)Crafting$(RESET) flint and steel"
	@touch $@

chest: oak_planks
	@echo "$(YELLOW)Crafting$(RESET) chest from oak planks..."
	@touch $@

oak_fence: oak_planks stick | crafting_table
	@echo "$(YELLOW)Crafting$(RESET) oak fence from oak planks and sticks..."
	@touch $@

oak_fence_gate: oak_planks stick | crafting_table
	@echo "$(YELLOW)Crafting$(RESET) oak fence gate from oak planks and sticks..."
	@touch $@

oak_door: oak_planks | crafting_table
	@echo "$(YELLOW)Crafting$(RESET) oak door from oak planks..."
	@touch $@

enchanted_book: book enchanting_table
	@echo "$(YELLOW)Crafting$(RESET) enchanted book from book and enchanting table..."
	@touch $@

enchanting_table: obsidian diamond book
	@echo "$(YELLOW)Crafting$(RESET) enchanting table from obsidian, diamond, and book..."
	@touch $@

bed: wool oak_planks
	@echo "$(YELLOW)Crafting$(RESET) bed from wool and oak planks..."
	@touch $@

book: paper leather
	@echo "$(YELLOW)Crafting$(RESET) book from paper and leather..."
	@touch $@

kill_cow: wooden_sword
	@touch beef
	@touch leather
	@touch $@

beef: kill_cow | visit_forest
	@echo "Obtaining beef from cows..."
	@touch $@

leather: kill_cow | visit_forest
	@echo "Obtaining leather from cows..."
	@touch $@

wool: shears | visit_forest
	@echo "Shearing sheep to get wool..."
	@touch $@

shears: iron_ingot
	@echo "$(YELLOW)Crafting$(RESET) shears from iron ingot..."
	@touch $@

paper: sugar_cane 
	@echo "$(YELLOW)Crafting$(RESET) paper from sugar cane..."
	@touch $@

sugar_cane: | visit_river
	@echo "Harvesting sugar cane..."
	@touch $@

item_frame: leather stick
	@echo "$(YELLOW)Crafting$(RESET) item frame..."
	@touch $@

painting: wool stick | crafting_table
	@echo "$(YELLOW)Crafting$(RESET) painting..."
	@touch $@

furnace: cobblestone | crafting_table
	@echo "$(YELLOW)Crafting$(RESET) furnace..."
	@touch $@

crafting_table: oak_planks
	@echo "$(YELLOW)Crafting$(RESET) crafting table from oak planks..."
	@touch $@

stick: oak_planks
	@echo "$(YELLOW)Crafting$(RESET) stick from oak planks..."
	@touch $@

oak_planks: oak_log
	@echo "$(YELLOW)Crafting$(RESET) oak planks from oak log..."
	@touch $@

oak_log: visit_forest
	@echo "$(YELLOW)Cutting$(RESET) a oak tree to get an oak log..."
	@touch $@

help:
	@echo "$(BOLD)Available actions:$(RESET)"
	@echo "  make visit_nether  - Prepare everything and go to the Nether"
	@echo "  make visit_cave    - Go to caves (requires leather armor)"
	@echo "  make clean         - Reset the world"

# --- ÚKLID ---

clean:
	@echo "Cleaning up resources..."
	ls | grep -v $(foreach file,$(KEEP_FILES),-e $(file)) | xargs rm -f