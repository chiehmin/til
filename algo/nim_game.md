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
