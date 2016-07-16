# Concurrency in JavaFX

[so: Platform.runLater and Task in JavaFX](http://stackoverflow.com/questions/13784333/platform-runlater-and-task-in-javafx)
[Concurrency in JavaFX](https://docs.oracle.com/javase/8/javafx/interoperability-tutorial/concurrency.htm)

The JavaFX scene graph, which represents the graphical user interface of a JavaFX application, is not thread-safe and can only be accessed and modified from the UI thread also known as the JavaFX Application thread. Implementing long-running tasks on the JavaFX Application thread inevitably makes an application UI unresponsive. A best practice is to do these tasks on one or more background threads and let the JavaFX Application thread process user events.

### Overview of the javafx.concurrent Package

The javafx.concurrent package consists of the Worker interface and two concrete implementations, Task and Service classes. The Worker interface provides APIs that are useful for a background worker to communicate with the UI. The Task class is a fully observable implementation of the java.util.concurrent.FutureTask class. The Task class enables developers to implement asynchronous tasks in JavaFX applications. The Service class executes tasks.

### The Worker Interface

The Worker interface defines an object that performs some work on one or more background threads. The state of the Worker object is observable and usable from the JavaFX Application thread.

The lifecycle of the Worker object is defined as follows. When created, the Worker object is in the READY state. Upon being scheduled for work, the Worker object transitions to the SCHEDULED state. After that, when the Worker object is performing the work, its state becomes RUNNING.

The progress of the work being done by the Worker object can be obtained through three different properties such as totalWork, workDone, and progress.

### The Task Class

The call method is invoked on the background thread, therefore this method can only manipulate states that are safe to read and write from a background thread. On the other hand, the Task class is designed to be used with JavaFX GUI applications, and it ensures that any changes to public properties, change notifications for errors or cancellation, event handlers, and states occur on the JavaFX Application thread. Inside the call method, you can use the updateProgress, updateMessage, updateTitle methods, which update the values of the corresponding properties on the JavaFX Application thread.

Note that the Task class fits into the Java concurrency libraries because it inherits from the java.utils.concurrent.FutureTask class, which implements the Runnable interface. For this reason, a Task object can be used within the Java concurrency Executor API and also can be passed to a thread as a parameter.

The Task class defines a one-time object that cannot be reused. If you need a reusable Worker object, use the Service class.

A task can be started in one of the following ways:

```java
Thread th = new Thread(task);
th.setDaemon(true);
th.start();

// or

ExecutorService.submit(task);
```

> FatMinMin modified example:

```java
Task<Integer> task = new Task<Integer>() {
   @Override protected Integer call() throws Exception {
       int iterations;
       for (iterations = 0; iterations < 1000; iterations++) {
           if (isCancelled()) {
               break;
           }
           System.out.println("Iteration " + iterations);
       }
       return iterations;
   }
};
new Thread(task).start();

for(int i = 0; i < 1000; i++) {
   System.out.println("test");
}

try {
   Integer result = task.get();
   System.out.println(result);
} catch (InterruptedException e) {
   e.printStackTrace();
} catch (ExecutionException e) {
   e.printStackTrace();
}
```

#### Binding with JavaFX controls

[so JavaFx: Update UI label asynchronously with messages while application different methods execution] (http://stackoverflow.com/questions/19968012/javafx-update-ui-label-asynchronously-with-messages-while-application-different)
```java
Task <Void> task = new Task<Void>() {
    @Override public Void call() throws InterruptedException {
        // "message2" time consuming method (this message will be seen).
        updateMessage("message2");

        // some actions
        Thread.sleep(3000);

        // "message3" time consuming method (this message will be seen).
        updateMessage("message3");

        //more  time consuming actions
        Thread.sleep(7000);

        // this will never be actually be seen because we also set a message
        // in the task::setOnSucceeded handler.
        updateMessage("time consuming method is done with success");

        return null;
    }
};

label.textProperty().bind(task.messageProperty());

task.setOnSucceeded(e -> {
    label.textProperty().unbind();
    // this message will be seen.
    label.setText("operation completed successfully");
});
```
