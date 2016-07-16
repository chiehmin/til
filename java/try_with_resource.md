# Try-with-resource

[Try-with-resource](https://docs.oracle.com/javase/tutorial/essential/exceptions/tryResourceClose.html)

```java
try (
        Socket echoSocket = new Socket("localhost", 5566);
        PrintWriter out = new PrintWriter(echoSocket.getOutputStream(), true);
        BufferedReader in = new BufferedReader(
                        new InputStreamReader(echoSocket.getInputStream()));
        BufferedReader stdIn = new BufferedReader(
                        new InputStreamReader(System.in))
) {
    String userInput;
    while ((userInput = stdIn.readLine()) != null) {
        out.println(userInput);
        System.out.println("echo: " + in.readLine());
    }
} catch (IOException e) {
    e.printStackTrace();
}
```

## Closable vs AutoClosable
[Java - What's the difference between Closeable and AutoCloseable?](http://davisfiore.co.uk/?q=node/259)

Closeable was introduced with JDK5 and AutoCloseable was introduced with JDK7.
```java
public interface Closeable extends AutoCloseable {
    public void close() throws IOException;
}
public interface AutoCloseable {
    void close() throws Exception;
}
```

Closeable has some limitations, as it can only throw IOException, and it couldn't be changed without breaking legacy code. So AutoCloseable was introduced, which can throw Exception. If you use JDK7+, you are supposed to use AutoCloseable. As JDK7+ libraries use AutoCloseable and legacy code that implements Closeable still need to work with JDK7+, the solution was having Closeable extend AutoCloseable.