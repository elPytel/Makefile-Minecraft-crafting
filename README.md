# Makefile

Simulace závislostí a procesů v Minecraftu pomocí Makefile. 

Help target: `make help` poskytuje přehled dostupných akcí:
```bash
Available actions:
  make visit_nether  - Prepare everything and go to the Nether
  make visit_cave    - Go to caves (requires leather armor)
  make clean         - Reset the world
```

## Zobecnění `_ingot` pravidla

```makefile
# --- GENERICKÉ PRAVIDLO (Pattern Rule) ---
# % funguje jako wildcard. Pokud make hledá "iron_ingot", dosadí za % "iron".
# Vyžaduje k tomu soubor "%_ore" (např. iron_ore) a pec (furnace) a uhlí (coal).

%_ingot: %_ore furnace coal
	@echo "Smelting $(notdir $<) in the furnace to create $@..."
	@touch $@
```

Automatické proměnné:
- $@: Cíl (např. iron_ingot).
- $<: První závislost (např. iron_ore). To je užitečné, protože v peci tavíš rudu, ne uhlí nebo pec samotnou.

## Co jsou Order-only prerekvizity?
Standardní prerekvizita (nalevo od |) dělá dvě věci:

Vynucuje pořadí: Prerekvizita se musí sestavit dříve než cíl.

Vynucuje obnovu: Pokud je prerekvizita novější než cíl, cíl se musí přebudovat.

Order-only prerekvizita (napravo od |) dělá jen tu první věc:

Vynucuje pořadí: Musí se sestavit/existovat dříve než cíl.

IGNORUJE obnovu: I když je tato prerekvizita novější než cíl, make kvůli tomu cíl znovu nepouští.


## Clean

```makefile
clean:
	@echo "Cleaning up resources..."
	find . -maxdepth 1 -type f ! -name "Makefile" ! -name "README.md" -delete
```

Vysvětlení:
- -maxdepth 1: Operuje pouze v aktuálním adresáři.
- -type f: Hledá pouze soubory.
- ! -name: Operátor negace (vynechej vše, co se jmenuje takto).
- -delete: Přímo smaže nalezené soubory (efektivnější než xargs).

## Zdroje:
- [Minecraft Craftings](https://minecraft-craftings.com/)