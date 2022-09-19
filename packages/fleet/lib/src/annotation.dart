import 'package:meta/meta_meta.dart';

/// Annotation that marks a class as the declaration of a Fleet view.
@Target({TargetKind.classType})
class ViewGen {
  /// Creates a new [ViewGen] annotation.
  const ViewGen();
}

/// Annotation that marks a class as the declaration of a Fleet view.
const view = ViewGen();

/// Annotation that marks a field of a view as state that is owned by the view.
@Target({TargetKind.field})
class StateGen {
  /// Creates a new [StateGen] annotation.
  const StateGen();
}

/// Annotation that marks a field of a view as state that is owned by the view.
const state = StateGen();
