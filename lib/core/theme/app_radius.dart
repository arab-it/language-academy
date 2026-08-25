import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  static const small = 10.0;
  static const medium = 14.0;
  static const large = 18.0;
  static const extraLarge = 24.0;
  static const huge = 32.0;

  static const smallRadius = BorderRadius.all(
    Radius.circular(small),
  );

  static const mediumRadius = BorderRadius.all(
    Radius.circular(medium),
  );

  static const largeRadius = BorderRadius.all(
    Radius.circular(large),
  );

  static const extraLargeRadius = BorderRadius.all(
    Radius.circular(extraLarge),
  );

  static const hugeRadius = BorderRadius.all(
    Radius.circular(huge),
  );
}

