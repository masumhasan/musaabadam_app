import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}

class Animal {

}

class Dog extends Animal with Walkable {

}

class Car with Walkable {

}

mixin Walkable {
  void walk() {

  }
}