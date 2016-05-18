# Nim Game
[wiki](https://en.wikipedia.org/wiki/Nim)
[nim wiki](https://brilliant.org/wiki/nim/)
The normal game is between two players and played with heaps of any number of objects. The two players alternate taking any number of objects from any single one of the heaps. The goal is to be the last to take an object.

## Nim Sum
The key to the theory of the game is the binary digital sum of the heap sizes, that is, the sum (in binary) neglecting all carries from one digit to another. This operation is also known as "exclusive or" (xor) or "vector addition over GF(2)". Within combinatorial game theory it is usually called the nim-sum, as it will be called here.

```
Binary  Decimal

  011      3    Heap A
  100      4    Heap B
  101      5    Heap C
  ---
  010      2    The nim-sum of heaps A, B, and C, 3 ⊕ 4 ⊕ 5 = 2
```

## Winning formula
**Theorem.** In a normal Nim game, the player making the first move has a winning strategy if and only if the nim-sum of the sizes of the heaps is nonzero. Otherwise, the second player has a winning strategy.

Let x1, ..., xn be the sizes of the heaps before a move, and y1, ..., yn the corresponding sizes after a move. Let s = x1 ⊕ ... ⊕ xn and t = y1 ⊕ ... ⊕ yn. If the move was in heap k, we have xi = yi for all i ≠ k, and xk > yk. By the properties of ⊕ mentioned above, we have
```
t = 0 ⊕ t
  = s ⊕ s ⊕ t
  = s ⊕ (x1 ⊕ ... ⊕ xn) ⊕ (y1 ⊕ ... ⊕ yn)
  = s ⊕ (x1 ⊕ y1) ⊕ ... ⊕ (xn ⊕ yn)
  = s ⊕ 0 ⊕ ... ⊕ 0 ⊕ (xk ⊕ yk) ⊕ 0 ⊕ ... ⊕ 0
  = s ⊕ xk ⊕ yk

(*) t = s ⊕ xk ⊕ yk.
```
**Lemma 1.** If s = 0, then t ≠ 0 no matter what move is made.

**Lemma 2.** If s ≠ 0, it is possible to make a move so that t = 0.

**FatMinMin Note:** No matter what move your opponent make, make the nim-sum back to 0 and you will win the game eventually.

```java
// https://www.hackerrank.com/contests/5-days-of-game-theory/challenges/day-2-nim-game
Scanner sc = new Scanner(System.in);
int t = sc.nextInt();
while((t--) > 0) {
    int n = sc.nextInt();
    int nimSum = 0;
    for(int i = 0; i < n; i++) {
        nimSum ^= sc.nextInt();
    }
    System.out.println(nimSum > 0 ? "First" : "Second");
}
```

# Misère Nim
The player who removes the last stone loses the game. In misère play, the goal is instead to ensure that the opponent is forced to take the last remaining object.

```java
// https://www.hackerrank.com/contests/5-days-of-game-theory/challenges/misere-nim/
Scanner sc = new Scanner(System.in);
int t = sc.nextInt();
while((t--) > 0) {
    int n = sc.nextInt();
    int nimSum = 0;
    int maxHeap = 0;
    for(int i = 0; i < n; i++) {
        int tmp = sc.nextInt();
        nimSum ^= tmp;
        maxHeap = Math.max(maxHeap, tmp);
    }
    boolean first = true;
    if(maxHeap == 1) {
        first = (n & 1) == 0;
    } else {
        first = (nimSum > 0);
    }
    System.out.println(first ? "First" : "Second");
}
```

# Nimble Game
Nimble is played on a game board consisting of a line of squares labeled: 0,
1, 2, 3, . . . . A finite number of coins is placed on the squares with possibly
more than one coin on a single square. A move consists of taking one of the
coins and moving it to any square to the left, possibly moving over some of

## Solution to Nimble
A coin on square n is the same as a nim-heap of size n.

```java
Scanner sc = new Scanner(System.in);
int t = sc.nextInt();
while((t--) > 0) {
    int n = sc.nextInt();
    int nimSum = 0;
    for(int i = 0; i < n; i++) {
        int tmp = sc.nextInt();
        if(tmp % 2 == 1) nimSum ^= i;
    }

    System.out.println(nimSum > 0 ? "First" : "Second");    
}
```
# Poker Nim
This game is played the same as regular Nim, but a player can now have the
option on his turn of either adding more chips to a heap or subtracting chips
from a heap. We call the heaps in such a game bogus nim heaps. What is
the winning strategy in this game?
A closer look reveals that this is just the same game as regular Nim. Any
time a player adds chips to a pile, the next player can exactly reverse the
move and return the game to its original position. In this way, adding chips is a reversible move. So just play regular Nim, but any time your opponent
adds chips, just remove the same amount on your turn.

# Nim related Game
[Topcoder Algorithm Games](https://www.topcoder.com/community/data-science/data-science-tutorials/algorithm-games/)
[Nim](http://web.mit.edu/sp.268/www/nim.pdf)
[Nim Example](http://www.suhendry.net/blog/?p=1612)
[Nimble Game](http://mathoverflow.net/questions/37303/the-game-of-nimble-with-no-stacking)

# Sprague–Grundy theorem
[Sprague–Grundy wiki](https://en.wikipedia.org/wiki/Sprague%E2%80%93Grundy_theorem)
[Nimber wiki](https://en.wikipedia.org/wiki/Nimber)

The Sprague–Grundy theorem states that every impartial game under the normal play convention is equivalent to a nimber. The Grundy value or nim-value of an impartial game is then defined as the unique nimber that the game is equivalent to.
