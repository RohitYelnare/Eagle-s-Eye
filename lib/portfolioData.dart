import 'package:flutter/material.dart';

class portData {
  int id;
  String name;
  int age;
  portData.storeAll(this.id, this.name, this.age);
  portData(this.name, this.age);

  Map<String, dynamic> toMap() {
    return {'name': name, 'age': age};
  }
}
