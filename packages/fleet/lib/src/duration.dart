/// Extension for creating [Duration]s from [int]s.
extension DurationFromIntExtension on int {
  /// A [Duration] that is as many **days** long as this value.
  Duration get d => Duration(days: this);

  /// A [Duration] that is as many **hours** long as this value.
  Duration get h => Duration(hours: this);

  /// A [Duration] that is as many **minutes** long as this value.
  Duration get m => Duration(minutes: this);

  /// A [Duration] that is as many **seconds** long as this value.
  Duration get s => Duration(seconds: this);

  /// A [Duration] that is as many **milliseconds** long as this value.
  Duration get ms => Duration(milliseconds: this);

  /// A [Duration] that is as many **microseconds** long as this value.
  Duration get us => Duration(microseconds: this);
}
