# Protocol-Oriented Programming (POP)        
 Shifts the architectural focus from what an object is (inheritance) to what an object can do (behavior). While Object-Oriented Programming (OOP) structures systems around base classes and hierarchical inheritance, POP structures systems around decoupled, composable behaviors using traits or interfaces (protocols).

1. Protocol Extensions and Default Implementations
Protocols define blueprints for methods, properties, and requirements. By utilizing protocol extensions, you provide default implementations for these requirements.

2. Composition Over Inheritance
OOP hierarchies introduce the "Fragile Base Class" problem, where modifications to a superclass risk breaking invariants across deeply nested subclasses. POP solves this by composing independent, highly specialized protocols.

3. Static vs. Dynamic Dispatch
- Protocol Requirements: Properties and methods explicitly declared in the protocol definition use dynamic dispatch (via witness tables). The runtime looks up the specific implementation of the conforming type.
- Extension-Only Members: Methods defined inside a protocol extension but not declared in the main protocol body use static dispatch. The compiler determines the implementation at compile-time based on the existential or concrete type known to the compiler, which optimizes execution speed but prevents runtime polymorphism for those specific members.