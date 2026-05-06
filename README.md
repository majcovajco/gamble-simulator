# Gamble Simulator 🎰 

*(Work in Progress)*
## Gameplay
![Gameplay](gameplay.gif)
## Slot machine
![Slot Machine](screenshot_automat.png)

## About The Project
Gamble Simulator is a 2D management and casino simulation game developed in **Godot 4**. The core loop revolves around gathering finances, interacting with a slot machine(optional), and upgrading/purchasing items.

Besides being a passion project, I am building this game to deepen my understanding of object-oriented programming, software architecture, and event-driven systems. I also wanted to try creating UI and UI components.

## Technicals

* **Separation of Concerns:** The codebase is modulated to separate logic from visuals. For example, `game_manager.gd` manages the global game state and finances, while `shop_logic.gd` handles transactions.
* **Event-Driven UI:** Uses Godot's Signal system to communicate between the user interface and the game logic, keeping components cleanly decoupled.
* **Probability & Algorithms:** Implemented logic for the slot machine's mechanics, win rates, and random generation.
* **State Management:** Tracking the player's balance, inventory, and environment changes.

## Tech Stack
* **Game Engine:** Godot 4.x
* **Language:** GDScript
* **Version Control:** GitHub

## Future Roadmap
* Expand the shop with more unlockable items
* Implement save/load system
* Export to HTML5 for browser play
* Add job opportunities and actual work mechanics
* Add events manipulating the market prices
