# Object-Oriented Programming (OOP)

Object-Oriented Programming (OOP) is a programming paradigm based on the concept of "objects," which can contain data (in the form of fields, often known as attributes or properties) and code (in the form of procedures, often known as methods). It models real-world entities and computational structures to manage complexity, promote reusability, and enhance maintainability.

---

## 1. Core Terminology and Definitions

### Class
A blueprint, template, or data type that defines the structure and behavior of a specific type of object. It specifies the fields (state) and methods (behavior) that its instances will possess. A class does not occupy memory for data fields until instantiated.

### Object
An instance of a class. It is a runtime entity that occupies memory, possesses a concrete state (values assigned to its attributes), and can execute behaviors defined by its class.

### Attribute / Field / Property
A variable declared within a class that represents the state or data of an object. These can be primitive data types or references to other objects.

### Method / Function
A subroutine or procedure associated with a class that defines the behavior of its objects. Methods manipulate object attributes or perform operations related to the object's role.

### Constructor
A specialized block of code executed automatically when a new object instance is created. Its primary purpose is to initialize the object's state and allocate required resources. Constructors can be parameterized or default (no-argument).

### Interface
A reference type that enforces a contract. It declares a set of method signatures without providing implementations. Classes that implement the interface must provide concrete implementations for these methods, decoupling specification from execution.

### Abstract Class
A class that cannot be instantiated directly and may contain both abstract methods (signatures without bodies) and concrete methods (with bodies). It serves as a partial blueprint for subclasses.

---

## 2. The Four Pillars of OOP

### 2.1 Encapsulation
Encapsulation is the bundling of data (attributes) and the methods that operate on that data into a single unit (a class), while restricting direct access to some of the object's components.

* **Mechanism:** Achieved using access modifiers to hide internal state and exposing functionality strictly through public methods (getters and setters, or public API methods).
* **Access Modifiers:**
    * `private`: Restricts visibility strictly to the defining class.
    * `protected`: Allows visibility within the defining class, its subclasses, and sometimes package-level peers.
    * `public`: Grants unrestricted visibility across all packages and modules.
    * `default / package-private`: Limits visibility to the current package (language-dependent).
* **Objective:** Prevents external code from modifying internal state unexpectedly, enforcing data integrity and reducing tight coupling.

### 2.2 Abstraction
Abstraction is the process of hiding complex implementation details and showing only the essential features of an object. It simplifies interaction with software components by separating *what* an object does from *how* it does it.

* **Mechanism:** Realized via abstract classes and interfaces. Users interact with high-level interfaces without needing to understand underlying algorithmic complexities.
* **Objective:** Reduces cognitive load on the programmer, isolates changes in internal logic from external clients, and establishes clear boundaries within a system architecture.

### 2.3 Inheritance
Inheritance is the mechanism by which one class (subclass/child) acquires the properties and behaviors of another class (superclass/parent). It establishes an "IS-A" relationship between classes.

* **Types of Inheritance:**
    * **Single Inheritance:** A subclass inherits from exactly one superclass.
    * **Multilevel Inheritance:** A subclass inherits from a derived class, forming a chain (e.g., Class C inherits from Class B, which inherits from Class A).
    * **Hierarchical Inheritance:** Multiple subclasses inherit from a single superclass.
    * **Multiple Inheritance:** A class inherits from more than one superclass. (Supported directly in C++; simulated via interfaces in Java and C# due to the Diamond Problem).
* **The Diamond Problem:** An ambiguity that arises when a class inherits from two superclasses that both define a method with the same signature inherited from a common ancestor.
* **Objective:** Eliminates code redundancy by allowing reuse of existing definitions and structural hierarchies.

### 2.4 Polymorphism
Polymorphism ("many forms") is the capability of a single interface, method, or object to behave differently based on the underlying context or execution state.

* **Compile-Time Polymorphism (Static Binding / Method Overloading):**
    * Occurs when multiple methods within the same class share the same name but possess different parameter lists (different number, type, or order of arguments).
    * Resolved by the compiler during compilation based on the method signature.
* **Runtime Polymorphism (Dynamic Binding / Method Overriding):**
    * Occurs when a subclass provides a specific implementation for a method that is already defined in its superclass.
    * Resolved at runtime by the execution environment via a virtual method table (VMT), executing the method corresponding to the actual object type, not the reference type.
* **Objective:** Allows systems to scale linearly by permitting uniform treatment of divergent implementations.

---

## 3. Supplementary Concepts

### Composition vs. Inheritance
* **Inheritance ("IS-A"):** Models structural dependencies where a subclass is a specialized version of the superclass. Leads to tight coupling.
* **Composition ("HAS-A"):** Models design where an object contains references to other objects as part of its state. Provides loose coupling and allows dynamic runtime behavioral changes.
* *Design Principle:* Favor composition over inheritance to maintain architectural flexibility.

### Association, Aggregation, and Composition
These represent variations of structural relationships between objects:
1.  **Association:** A weak relationship where objects have independent lifecycles and know about each other (e.g., a Driver and a Car).
2.  **Aggregation:** A specialized, unidirectional association representing a "part-of" or "HAS-A" relationship where the child can exist independently of the parent (e.g., a Department and a Professor).
3.  **Composition:** A strict form of aggregation where the child object's lifecycle is bound entirely to the parent object's lifecycle; if the parent is destroyed, the child is destroyed (e.g., a House and a Room).

---

## 4. Summary of SOLID Principles (OOP Architecture)
* **S - Single Responsibility Principle (SRP):** A class should have one, and only one, reason to change.
* **O - Open/Closed Principle (OCP):** Software entities should be open for extension, but closed for modification.
* **L - Liskov Substitution Principle (LSP):** Objects of a superclass must be replaceable with objects of its subclasses without breaking the application.
* **I - Interface Segregation Principle (ISP):** Clients should not be forced to depend on interfaces they do not use.
* **D - Dependency Inversion Principle (DIP):** Depend on abstractions, not on concretions.