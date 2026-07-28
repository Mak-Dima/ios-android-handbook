In Kotlin (especially on the JVM), synchronization is about ensuring that multiple threads can safely access shared data.           
Kotlin itself doesn't introduce a completely new concurrency model for threads—it builds on the Java Memory Model (JMM), so most synchronization primitives come from Java while adding Kotlin-friendly syntax.         
Here's a breakdown of the most important concurrency primitives.
### 1. @Volatile
A volatile variable ensures that:
Every read gets the latest value written by any thread.
Writes are immediately visible to other threads.
Reads/writes are atomic for primitive types and references.

```kotlin
class Counter {
    @Volatile
    var running = true
}

fun main() {
    val counter = Counter()

    Thread {
        while (counter.running) {
            // work
        }
        println("Stopped")
    }.start()

    Thread.sleep(1000)
    counter.running = false
}
```

Without @Volatile, the first thread may cache running and never observe the update.         
What volatile does NOT do           
**This is not thread-safe:**
```kotlin
@Volatile
var count = 0

fun increment() {
    count++
}
```
Because         
```
count++
```
actually means          
```
1. read count
2. add one
3. write count
```


### 2.synchronized          
Use a monitor lock so only one thread executes a critical section.          
```kotlin
class Counter {
    private var count = 0

    @Synchronized
    fun increment() {
        count++
    }

    @Synchronized
    fun get(): Int = count
}
```

Or using Kotlin synchronized function:          
```kotlin
private val lock = Any()

fun increment() {
    synchronized(lock) {
        count++
    }
}
```

### 3. ReentrantLock            
More flexible than synchronized.            
```kotlin
val lock = ReentrantLock()

fun update() {
    lock.lock()
    try {
        // critical section
    } finally {
        lock.unlock()
    }
}

// Or with Kotlin extensions
lock.withLock {
    // critical section
}
```

### 4. Atomic Variables         
Usually the preferred solution for simple counters.
```kotlin
val counter = AtomicInteger(0)

counter.incrementAndGet()
counter.decrementAndGet()
counter.compareAndSet(5, 6)
```

No explicit locks.          
Available types include:            
AtomicInteger           
AtomicLong          
AtomicBoolean           
AtomicReference         

Example:        
```kotlin
val total = AtomicInteger()

repeat(1000) {
    Thread {
        total.incrementAndGet()
    }.start()
}
```

### 5. ReadWriteLock            
Allows:     
* many readers simultaneously
* only one writer
```kotlin
// Useful when reads greatly outnumber writes.
val lock = ReentrantReadWriteLock()

fun read() {
    lock.readLock().lock()
    try {
        println(data)
    } finally {
        lock.readLock().unlock()
    }
}

fun write(value: Int) {
    lock.writeLock().lock()
    try {
        data = value
    } finally {
        lock.writeLock().unlock()
    }
}
```

### 6. Semaphore        
Limits concurrent access.       
Example:        
```kotlin
val semaphore = Semaphore(3)

fun worker() {
    semaphore.acquire()
    try {
        // only 3 threads allowed here
    } finally {
        semaphore.release()
    }
}
```

### 7. CountDownLatch           
One or more threads wait until work finishes.       
```kotlin
val latch = CountDownLatch(3)

repeat(3) {
    Thread {
        // work
        latch.countDown()
    }.start()
}

latch.await()
println("Finished")
```

### 8. CyclicBarrier            
Wait until all threads reach a point.       
```kotlin
val barrier = CyclicBarrier(5)

Thread {
    // work
    barrier.await()
}
```
Unlike CountDownLatch, it can be reused.

### 9. Concurrent Collections           
Instead of
```kotlin
val map = mutableMapOf<Int, String>()
```
use
```kotlin
val map = ConcurrentHashMap<Int, String>()
```
or
```kotlin
CopyOnWriteArrayList<String>()
ConcurrentLinkedQueue<Int>()
ConcurrentSkipListMap<Int, String>()
```

These provide thread-safe access with varying performance characteristics.          

### 10. ThreadLocal          
Each thread has its own copy.
```kotlin
/* Useful for:
database connections
request context
formatting objects */

val local = ThreadLocal<String>()

local.set("Hello")

println(local.get())
```

### 11. Coroutines Synchronization          
When using Kotlin coroutines, avoid thread locks where possible.            
Mutex       
```kotlin
val mutex = Mutex()

suspend fun update() {
    mutex.withLock {
        counter++
    }
}
```
Unlike synchronized, a coroutine waiting for a Mutex suspends instead of blocking the underlying thread.            

Channel         
Safe communication between coroutines.          
```kotlin
val channel = Channel<Int>()

launch {
    channel.send(5)
}

launch {
    println(channel.receive())
}
```
StateFlow       
Observable state.       
```kotlin
// Often replaces manually synchronized shared state in coroutine-based applications.
private val state = MutableStateFlow(0)

state.value++

state.collect {
    println(it)
}
```