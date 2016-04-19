## Boyer–Moore majority vote algorithm

[wiki](https://en.wikipedia.org/wiki/Boyer%E2%80%93Moore_majority_vote_algorithm)

```java
import java.util.*;
public class MajorityVote {
    public int majorityElement(int[] num) {
        int n = num.length;
        int candidate = num[0], counter = 0;
        for (int i : num) {
            if (counter == 0) {
                candidate = i;
                counter = 1;
            } else if (candidate == i) {
                counter++;
            } else {
                counter--;
            }
        }

        counter = 0;
        for (int i : num) {
            if (i == candidate) counter++;
        }
        if (counter < (n + 1) / 2) return -1;
        return candidate;

    }
    public static void main(String[] args) {
        MajorityVote s = new MajorityVote();
        System.out.format("%d\n", s.majorityElement(new int[] {1, 2, 3}));
        System.out.format("%d\n", s.majorityElement(new int[] {2, 2, 3}));
    }
}
```
