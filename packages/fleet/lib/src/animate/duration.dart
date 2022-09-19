/// Extension for creating [Duration]s from [int]s.
///
/// # Examples
///
/// ```dart
/// final week = 7.d;
/// final day = 24.h;
/// final hour = 60.m;
/// final minute = 60.s;
/// final second = 1000.ms;
/// final millisecond = 1000.us;
/// ```
///
/// {@category Animate}
extension DurationFromIntExtension on int {
  /// A [Duration] that is as many **days** long as this value.
  ///
  /// # Examples
  ///
  /// ```dart
  /// final week = 7.d;
  /// ```
  Duration get d => Duration(days: this);

  /// A [Duration] that is as many **hours** long as this value.
  ///
  /// # Examples
  ///
  /// ```dart
  /// final day = 24.h;
  /// ```
  Duration get h => Duration(hours: this);

  /// A [Duration] that is as many **minutes** long as this value.
  ///
  /// # Examples
  ///
  /// ```dart
  /// final hour = 60.m;
  /// ```
  Duration get m => Duration(minutes: this);

  /// A [Duration] that is as many **seconds** long as this value.
  ///
  /// # Examples
  ///
  /// ```dart
  /// final minute = 60.s;
  /// ```
  Duration get s => Duration(seconds: this);

  /// A [Duration] that is as many **milliseconds** long as this value.
  ///
  /// # Examples
  ///
  /// ```dart
  /// final second = 1000.ms;
  /// ```
  Duration get ms => Duration(milliseconds: this);

  /// A [Duration] that is as many **microseconds** long as this value.
  ///
  /// # Examples
  ///
  /// ```dart
  /// final millisecond = 1000.us;
  /// ```
  Duration get us => Duration(microseconds: this);
}
