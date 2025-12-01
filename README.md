📘 Blackjack in x86-64 Assembly (2020 Final Project)

This repository contains a fully playable Blackjack game written entirely in x86-64 assembly, originally created as my final project for a machine-level programming course in 2020.

It implements the complete game loop:

Player and dealer card drawing

Real Blackjack ace logic (11 → 1 adjustment when needed)

Betting system and bankroll tracking

Dealer AI (hits until 17 or more)

Blackjack detection

Bust and tie logic

Replay and session-ending flow

This was the most complex and detailed low-level project I wrote during that time, and I’m preserving it here as an artifact of my early coding journey.

🎮 Features

Full game logic including player decisions, dealer behavior, and win/loss evaluation

Ace handling identical to real Blackjack (Aces start as 11, convert to 1 if the hand would bust)

Card values from A23456789TJQK with face cards counting as 10

Random card generation

Bet prompts and money management

Replay loop and game-over conditions

🛠️ Technical Notes

This project was originally built in a classroom environment using a custom instructional library (CS12-Lib) that provided routines such as:

printByteArray

printEndl

getQuad

exitNormal

Those library files are not included here, so the original assembly file is preserved as-is for historical and educational value.

The logic itself is complete and reflects how the program functioned in the course environment.

📁 Why this project is here

This file represents:

My earliest systems-level programming work

My first fully structured assembly program

A complete game engine built from the ground up

The moment I first realized I enjoyed building full systems, not just small scripts

Although I now use more modern tools and languages, this project reflects the foundation of how I think about architecture, structure, and logic.

🔧 Running the Program (Optional)

Because the original class library is not included, this exact file will not assemble and run out of the box.

However, there is a compatible Python recreation of the same logic in the repository for anyone who wants to actually play the game today.

📜 File Structure

blackjack.asm — The original 2020 assembly source, preserved unchanged

python_recreation/blackjack.py (optional) — A runnable version that mirrors the original logic

📄 License

This project is provided as an educational and historical artifact.
Feel free to read, study, or reference the code.
