import 'package:flutter/material.dart';

class ColorARGB {
  int a;
  int r;
  int g;
  int b;
  ColorARGB({
    this.a = 255,
    this.r = 255,
    this.g = 255,
    this.b = 255
  });
  factory ColorARGB.fromJson(Map<String,dynamic> json) {
    return ColorARGB(
      a: json['a'],
      r: json['r'],
      g: json['g'],
      b: json['b'],
    );
  }

  Color toColorClass () {
    Color color = Color.fromARGB(
      a = this.a,
      r = this.r,
      g = this.g,
      b = this.b
    );
    return color;
  }
}
