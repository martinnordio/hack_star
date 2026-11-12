# Game: Hack star
Name: HAck star

The goal of the project is to develop a game based on Brawl starts, at most an identical copy with the following modifications:
* Hack codes: adding some hack code (e.g. QR codes), the players can get unlimited credits to unlock fighters, levels and instead of doing 11 levels we can do 22. 

# Spec 0
Investigate the Brawl starts games. For example, a kid told me:
* If I win a match, the fighter gets 10 trophys, when we have 1000 trophys  it gets a dimond with a number

In this spec, we need to define what the basic game is. so the basic part. The game should be a minimum viable product (a basic game). We need to finish the first version by the  end of one day, but take to account that we use Claude and you will go super fast. But we need to restrict and simplify the game so that we can play the game at the end of our trip. 

For the first features, we need to find a way to get very good graphics and how we can take the graphics very quickly. We need to have basic animations.

Create a list of features number from 1 to N. For feature 0, I introduce below some initial points for the architecture and the technology. For feature 1, we should have a basic UI with the visuals and basic impression of the game. 

The second feature is the hack feature. Then the real game features. 

All the spec must be created using my spec-kit which is in this repository.

# Spec 0
The technology is Python as server and Svelte as UI. The visual parts are very important and therefore find the libraries that make the game look good. The game is ony a browser based game but we need to support deskops, ipad screens (from the browser) and phones. 


# Spec1
Designs and basic UI is part of the spec1. We need a basic UI which shows the basic first screen of the game and make a woww effect for kds. 

What kids say is fun and why to play and what to replicate:
* Kids likes prestage which is when you put one of the figherts to get 1'000 trophies, the game gets a bagde with numbers. 
* Kids like there are different skins for example a legendary skins (find the correct name of skin) something like a custome.

As part of the spec, add a basic vocabulary used in the game so that we can understand kids when they talk. We add this into an information page.

# Spec 2
For the spec 2, make good graphics and don't complicate the game itselft and the complexity of the game. We you need to introduce it from spec 3 on. Make sure the graphics and the basic demo works well and it is graphically impressive and looks really like "Brawl starts"

# Spec future

# Questions to Mattia:

How long should a match be?
How many bots should the player face?

Until Mattia answers, the game uses the default in brackets; each one is a single setting.


* When you lose, should the fighter lose trophies? (no)
* How strong should the bots be: weaker than you, the same, or stronger? (power 5)
* Which game mode after this one: Gem Grab, Brawl Ball, or something else?
* Any names for new fighters or new hack codes?

# Feedback from Mattia

* How long should a match be? (2 minutes)
yes, 2 minutes. 

* How many bots should the player face? (3)
3 bots 
* more 
Add more figures

* Should the bots be easy, medium or hard? (easy)
we should be able to select it in the configuration

* more advance
and the payers should have up to 2 frinds to play

* When time runs out and bots are still alive: is it a draw, or do you lose? (draw)
the match continues for another minute but without walls.  Then, tt is a draw but 

* Do the bots also fight each other, or only you? (each other too, like Showdown)
Ok.

* QR code
Hiper charge QR code

## What the feedback became (specs)

| Feedback | Spec |
|----------|------|
| 2 minutes, 3 bots, bots fight each other | Already so; confirmed, no change |
| Bot level chosen in a configuration | F8 [overtime and match options](features/done/2026_11_12_overtime_and_match_options_spec.md) ✅ done |
| One more minute without walls when time runs out | F8 [overtime and match options](features/done/2026_11_12_overtime_and_match_options_spec.md) ✅ done |
| Add more figures | F9 [more fighters](features/done/2026_11_12_more_fighters_spec.md) ✅ done |
| Hypercharge QR code | F10 [super and hypercharge](features/done/2026_11_12_super_and_hypercharge_spec.md) ✅ done |
| Up to 2 friends to play | F11 [play with friends](features/done/2026_11_12_play_with_friends_spec.md) ✅ done (same team, same Wi-Fi) |

## New questions to Mattia

Until he answers, the game uses the default in brackets.

Answered:
* After the extra minute, what happens? **It is a draw** (a normal draw: 0 trophies, 20 credits).

Open:
* Should harder bots give more trophies? (no)
* Names or ideas for the new fighters? (the game invents them)
* What should the Hypercharge QR code do? (every Super becomes a Hypercharge)
* Friends: on your team against the bots, or everyone against everyone? (same team)
* Friends: only in the same house / Wi-Fi, or also from different houses? (same Wi-Fi)
* Still open from before: lose trophies when you lose? (no) · How strong are bots? (power 5) · Which second mode? (not started)
