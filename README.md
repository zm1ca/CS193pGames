# CS193pGames
Combined Set and Concentration games for Stanford CS193p (Fall 2017) [course](https://www.youtube.com/playlist?list=PLPA-ayBrweUzGFmkT_W65z64MoGnKRZMq).
![gif](https://github.com/zm1ca/CS193pGames/blob/showcase/showcareV1-lowres.gif)

[High resolution showcase](https://github.com/zm1ca/CS193pGames/blob/showcase/showcaseV1.gif)

***
## Concentration
[Concentration](https://en.wikipedia.org/wiki/Concentration_(card_game)), also known as Match Match, Match Up, Memory, Pelmanism, Shinkei-suijaku, Pexeso or simply Pairs, is a card game in which all of the cards are laid face down on a surface and two cards are flipped face up over each turn. 
The object of the game is to turn over pairs of matching cards.

This particular implementation of COncentration has those major features (mostly as in [Programming Assignment One](https://github.com/zm1ca/CS193pGames/blob/showcase/Programming%20Project%201_%20Concentration.pdf), including extra credit):
* Concentration game itself
* Themes set (consisting of emoji-set and colors), to increase game's replayability
* Theme is shown in the navigation bar
* Changing themes on-fly, not violating current gameplay
* Speed-dependent scoring system, to make the gameplay as fair as it's needed to have fun c:
* Penalties for not recognizing an emoji, which had already been presented to a player
* Automated restart if there are no more cards left to concentrate on
* UI is adapting to both landscape and portrait modes look fine and use space effectively on any device supporting iOS14 in all circumstances
* Customized glyph for tab bar, which perfectly depicts Concentration grid

***
## Set
[Set](https://en.wikipedia.org/wiki/Set_(card_game)) is a real-time card game designed by Marsha Falco in 1974. The deck consists of 81 unique cards that vary in four features across three possibilities for each kind of feature: number of shapes, shape, shading, and color.

This particular implementation of Set has those major features (mostly as in Programming Assignments [two](https://github.com/zm1ca/CS193pGames/blob/showcase/Programming%20Project%202%20Set.pdf), [three](https://github.com/zm1ca/CS193pGames/blob/showcase/Programming%20Project%203_%20Graphical%20Set.pdf) and [four](https://github.com/zm1ca/CS193pGames/blob/showcase/Programming%20Project%204_%20Animated%20Set.pdf), including extra credits):
* Game of Set itself
* Two-player mode (with a screen congratulating winner c:)
* Hint mechanics (beware, since using this causes a penalty)
* If a user is stuck looking for a set, he or she may use a rotation gesture to shuffle the deck and rearrange cards on a table, on swipe down to draw more cards
* Animations:
  * Cards are flying into a screen spinning 
  * Each set disclosure causes involved cards to fly across the screen chaotically, colliding with each other
  * Cards are flying away smoothly into the phantom discard pile, where they flip and get transparent
* Support of any amount of UIBezuerPath-drawn cards on-screen simultaneously
* Dark-mode support, including double specification of each UI color
* There will always be a set on a table since it's absence triggers drawing more cards (if it's possible) or endgame scenario
* UI is adapting to both landscape and portrait modes look fine and use space effectively on any device supporting iOS14 in all circumstances 
