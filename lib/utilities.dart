import 'package:flutter/material.dart';

int createUniqueId() {
  print('createUniqueId');
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}
