import random

CARDS = "A23456789TJQK"

WELCOME_MSG = "WELCOME TO BLACKJACK! (A = 1 or 11, T,J,Q,K = 10)"
YOU_MSG = "You're dealt a "
DEALER_MSG = "The dealer drew a "
PLAYER_TOTAL_MSG = "Your Total: "
DEALER_TOTAL_MSG = "Dealer Total: "
CARD_PROMPT = "Would you like another card? (Enter 1 for yes): "
BUST_MSG = "Sorry, that's a bust! You lose!"
BJ_MSG = "That's Blackjack! You Win!"
ACE_VALUE_CHANGE_MSG = "Ace value changed from 11 to 1"
DEALER_BUST_MSG = "The dealer has busted! You win!"
PLAYER_BEAT_DEALER_MSG = "You beat the dealer! Congratulations! You win!"
DEALER_BEAT_PLAYER_MSG = "Uh-oh! Looks like the dealer wins!"
TIE_MSG = "This game ends in a tie. No money lost or gained."
BET_PROMPT = "Enter bet (no more than current money amount): $"
DISPLAY_MONEY_MSG = "Total Cash: $"
PLAY_AGAIN_MSG = "Would you like to play another hand? (Enter 1 for yes): "
NO_MONEY_MSG = "You're out of money! Would you like to play again? (Enter 1 for yes): "
MONEY_EARNED_MSG = "You walked away with: $"

def obtain_random_card_index():
    # Your asm did rdrand % 14 and retried on 0 → effectively 1..13
    return random.randint(1, 13)

def is_ten(value):
    # T, J, Q, K (10–13) are all worth 10
    return 10 if value > 10 else value

def draw_card(total, ace_count, who_msg):
    idx = obtain_random_card_index()  # 1..13
    raw_value = idx
    card_char = CARDS[idx - 1]
    print(f"{who_msg}{card_char}")
    # Map to blackjack value
    value = is_ten(raw_value)
    if raw_value == 1:  # Ace
        ace_count += 1
        value = 11
    total += value
    # Adjust ace if total > 21
    if ace_count > 0 and total > 21:
        total -= 10
        ace_count -= 1
        print(ACE_VALUE_CHANGE_MSG)
    return total, ace_count

def print_total(label, total):
    print(f"{label}{total}")
    print()

def get_int(prompt):
    while True:
        try:
            s = input(prompt)
            return int(s.strip())
        except ValueError:
            print("Please enter a valid number.")

def play_game():
    print(WELCOME_MSG)
    print()
    money = 20  # matches r15 = 20

    while True:  # new hand loop (same money unless reset)
        # New hand state
        player_total = 0
        dealer_total = 0
        player_aces = 0
        dealer_aces = 0

        # (0) Bet prompt
        while True:
            print(f"{DISPLAY_MONEY_MSG}{money}")
            bet = get_int(BET_PROMPT)
            if bet <= 0:
                print("Bet must be greater than 0.")
                continue
            if bet > money:
                print("Bet cannot exceed your total cash.")
                continue
            break

        # (1) Player first card
        player_total, player_aces = draw_card(player_total, player_aces, YOU_MSG)

        # (2) Dealer draw
        dealer_total, dealer_aces = draw_card(dealer_total, dealer_aces, DEALER_MSG)

        # (3) Player second card
        player_total, player_aces = draw_card(player_total, player_aces, YOU_MSG)

        # (4) Display Total
        print_total(PLAYER_TOTAL_MSG, player_total)

        # (4.5) Immediate blackjack check
        if player_total == 21:
            print(BJ_MSG)
            money += bet
        else:
            # (5) Player turn loop
            while True:
                print()
                choice = get_int(CARD_PROMPT)
                print()
                if choice != 1:
                    break
                player_total, player_aces = draw_card(player_total, player_aces, YOU_MSG)
                print_total(PLAYER_TOTAL_MSG, player_total)
                if player_total < 21:
                    continue
                if player_total == 21:
                    print(BJ_MSG)
                    money += bet
                    break
                if player_total > 21:
                    print()
                    print(BUST_MSG)
                    money -= bet
                    break

            # If player busted or hit exactly 21, skip dealer
            if player_total < 21:
                # (6) Dealer turn
                print_total(DEALER_TOTAL_MSG, dealer_total)
                while dealer_total < 17:
                    dealer_total, dealer_aces = draw_card(dealer_total, dealer_aces, DEALER_MSG)
                    print_total(DEALER_TOTAL_MSG, dealer_total)

                if dealer_total > 21:
                    print(DEALER_BUST_MSG)
                    money += bet
                else:
                    # Compare totals
                    if player_total > dealer_total:
                        print_total(PLAYER_TOTAL_MSG, player_total)
                        print()
                        print(PLAYER_BEAT_DEALER_MSG)
                        money += bet
                    elif player_total == dealer_total:
                        print_total(PLAYER_TOTAL_MSG, player_total)
                        print()
                        print(TIE_MSG)
                    else:
                        print_total(PLAYER_TOTAL_MSG, player_total)
                        print()
                        print(DEALER_BEAT_PLAYER_MSG)
                        money -= bet

        # (8) Finish / money check
        if money <= 0:
            print()
            choice = get_int(NO_MONEY_MSG)
            print()
            print()
            if choice == 1:
                money = 20
                print(WELCOME_MSG)
                print()
                continue
            else:
                print(f"{MONEY_EARNED_MSG}{money}")
                print()
                break
        else:
            print()
            choice = get_int(PLAY_AGAIN_MSG)
            print()
            if choice == 1:
                continue
            else:
                print(f"{MONEY_EARNED_MSG}{money}")
                print()
                break

if __name__ == "__main__":
    play_game()
