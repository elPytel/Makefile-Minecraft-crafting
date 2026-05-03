# Makefile for Minecraft crafting recipes
# simulate crafting with make and linux commands

KEEP_FILES = Makefile README.md .gitignore

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

# Armor
HELMET = $(firstword $(wildcard diamond_helmet iron_helmet leather_helmet))
CHESTPLATE = $(firstword $(wildcard diamond_chestplate iron_chestplate leather_chestplate))
LEGGINGS = $(firstword $(wildcard diamond_leggings iron_leggings leather_leggings))
BOOTS = $(firstword $(wildcard diamond_boots iron_boots leather_boots))

all: neather_portal

# --- AKCE ---

visit_nether: neather_portal $(DIAMOND_SET)
	@echo "Equipping full $(BLUE)diamond armor$(RESET) for maximum safety..."
	@echo "$(MAGENTA)Visiting$(RESET) the Nether..."
	@touch $@

visit_cave: $(LEATHER_SET)
	@echo "Equipping full $(BLUE)armor$(RESET) for safety..."
	@echo "$(MAGENTA)Visiting$(RESET) the cave to mine resources..."
	@touch $@

visit_forest: 
	@echo "$(MAGENTA)Visiting$(RESET) the forest to gather wood and food..."
	@touch $@

# --- BUILDING ---

house: oak_planks cobblestone crafting_table furnace item_frame painting bed
	@echo "Building a house and placing a crafting table and furnace..."
	@touch $@

neather_portal: obsidian flint_and_steel house
	@echo "Building Nether Portal with obsidian and flint and steel..."
	@touch $@

# --- TĚŽBA ---

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

flint_and_steel: iron_ingot flint
	@echo "$(YELLOW)Crafting$(RESET) flint and steel"
	@touch $@

flint: gravel stone_shovel
	@echo "Mining flint from gravel..."
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
	@touch $@"

leather: wooden_sword | visit_forest
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

sugar_cane:
	@echo "Harvesting sugar cane..."
	@touch $@

item_frame: leather stick
	@echo "$(YELLOW)Crafting$(RESET) item frame..."
	@touch $@

painting: wool stick
	@echo "$(YELLOW)Crafting$(RESET) painting..."
	@touch $@

furnace: cobblestone crafting_table
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