

import 'dart:isolate';

void main(List<String> arguments) {


  print('Hello world!');

  // VARIABLES

  var name = 'Dart';
  print('Hello, $name!');

  // Type-safe, these variables types are determined by their initial values
  // name = 10; Error: A value of type 'int' can't be assigned to a variable of type 'String'.
  // print('Hello, $name!');

  int year = 2026; // Explicitly typed variable
  print('Year: $year');

  var subjects = ['Math', 'Science', 'History', 'Music'];
  print('Subjects: $subjects');

  var person = {
    'name': 'Alice',
    'age': 30,
    'isStudent': false,
  };
  print('Person: $person');
  print(person.runtimeType); // Output: _Map<String, Object>

  print('Age: ${(person['age'] as int?)}'); // The 'as int?' is used to cast the value to an integer,
                                            // and the '?' allows for null safety in case the key doesn't exist or is null.

  
  // late, final, const, Object, dynamic
  
  //  type checks and casts,  collection if, spread operators

  // Wildcard variables
  
  print('\n');
  
  // CONTROL FLOW STATEMENTS

  if ((person['age'] as int?)! > 18) {
    print('${person['name']} is an adult.');
  } else {
    print('${person['name']} is a minor.');
  }

  for (final subject in subjects) {
    print('Subject: $subject');
  }

  for (int i = 1; i <= 3; i++) {
    print('Count: $i');
  }

  while (year < 2028) {
    print('Year: $year');
    year++;
  }


  // FUNCTIONS

  int fibonacci ( int n ) {
    if  ( n <= 1) {
      return n;
    } else {
      return fibonacci(n - 1) + fibonacci(n - 2);
    }
  }

  print('Fibonacci of 6: ${fibonacci(6)}'); // Output: Fibonacci of 6: 8

  // Anonymous function
  subjects.where( (subject) => subject.startsWith('M') ).forEach( print);


  // IMPORTS
  /*
  // Import only foo.
  import 'package:lib1/lib1.dart' show foo;

  // Import all names EXCEPT foo.
  import 'package:lib2/lib2.dart' hide foo;

  // Deferred loading (lazy loading) - allows you to load a library only when it's needed.
  import 'package:greetings/hello.dart' deferred as hello;
   */

  print('\n');

  // CLASSES

  var alice = Person('Alice', 30);
  alice.greet();
  alice.information();

  Person bob = Person.unknown();
  bob.greet();

  Person charlie = Person('Charlie', 25, email: 'charlie@example.com');
  charlie.information();

  // Inheritance and Getters/Setters
  var student = Student('Dave', 20, 'University of Dart');
  student.greet();
  print('School: ${student.school}');
  student.school = 'Dart State University';
  print('Updated School: ${student.school}');
  student.greet();

  print('\n');


  // ENUMS
  
  ColorType favoriteColor = ColorType.red;
  print('Favorite Color: ${favoriteColor.name}'); // Output: Favorite Color: red
  Color color = Color.purple;
  print(color.description);

  print('\n');


  // MIXINS

  var user = User('123', 'Eve');
  print(user); // Output: ID: 123, Name: Eve
  var anotherUser = User('123', 'Eve');
  print(user == anotherUser); // Output: true, because they have the same ID


  // ASYNC

  const oneSecond = Duration(seconds: 1);
  Future<void> printWithDelay(String message) async {
    await Future.delayed(oneSecond);
    print(message);
  }
  printWithDelay('This message is printed after a delay of 1 second.');
  print('This message is printed immediately.');

  

}

// CLASSES

class Person {

  String name;
  int age;
  String? email; // Nullable type

  // Dart don't allow multiple constructors, but you can use named constructors to achieve similar functionality.
  Person (this.name, this.age, {this.email}); // Constructor, the curly braces around email indicate that it's an optional named parameter.
  Person.unknown() : name = 'Unknown', age = 0; // Named constructor

  void greet() {
    print('Hello, my name is $name and I am $age years old.');
  }

  void information() {
    print('Name: $name, Age: $age, Email: ${email ?? 'N/A'}'); // The '??' operator is used to provide a default value ('N/A') if email is null.
  }

}

// Inheritance
class Student extends Person {

  String _school; // Private variable (indicated by the underscore)

  Student(super.name, super.age, this._school); // Constructor that calls the superclass constructor

  @override
  void greet() {
    print('Hello, I am a student named $name and I study at $_school.');
  }

  // Getters and Setters
  String get school => _school; // Getter for the private variable _school
  set school(String value){  // Setter for the private variable _school
    if (value.isNotEmpty) {
      _school = value;
    } else {
      print('School name cannot be empty.');
    }
  } 

}


// ENUMS

enum ColorType { red, yellow, blue }

// Enhanced Enums
enum Color {

  purple( primaryColor: ColorType.red, secondaryColor: ColorType.blue, hex: '#800080' ),
  green( primaryColor: ColorType.yellow, secondaryColor: ColorType.blue, hex: '#008000' ),
  orange( primaryColor: ColorType.red, secondaryColor: ColorType.yellow, hex: '#FFA500' );


  // All variables must be final
  final ColorType primaryColor;
  final ColorType secondaryColor;
  final String hex;

  // Constructor must be const and all fields must be initialized
  const Color( { required this.primaryColor, required this.secondaryColor, required this.hex } );

  String get description => 
    'Color: $name, Primary: ${primaryColor.name}, Secondary: ${secondaryColor.name}, Hex: $hex';

}


// MIXINS
// Mixins are a way of defining code that can be reused in multiple class hierarchies.

mixin Identifiable {

  String get id;
  String get name;

  @override
  String toString() => 'ID: $id, Name: $name';

  @override
  bool operator ==(other) => other is Identifiable && other.id == id;

}

class User with Identifiable {

  final String id;
  final String name;

  User(this.id, this.name);

}