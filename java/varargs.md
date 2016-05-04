# Varargs in Java

```java
// https://www.hackerrank.com/challenges/simple-addition-varargs
public class Add {
    public void add(int... vals) {
        int sum = 0;
        for(int i = 0; i < vals.length; i++) {
            if(i > 0) System.out.print("+");
            System.out.print(vals[i]);
            sum += vals[i];
        }
        System.out.println("=" + sum);
    }
    public static void main(String[] args) {
        Add ob=new Add();
        ob.add(1, 2);
        ob.add(1, 2, 3);
        ob.add(1, 2, 3, 4, 5);
        ob.add(1, 2, 3, 4, 5, 6);

        // just passing an array
        ob.add(new int[]{1, 2, 3, 4, 5, 6, 7});
    }
}
```

[disscussion](http://stackoverflow.com/questions/2925153/can-i-pass-an-array-as-arguments-to-a-method-with-variable-arguments-in-java)

`T...` is only a syntactic sugar for a `T[]`.
