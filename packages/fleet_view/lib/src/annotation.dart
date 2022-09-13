import 'package:meta/meta_meta.dart';

/// Annotation that marks a class as the declaration of a Fleet view.
///
/// See also:
///
/// - `ViewWidget` for a more detailed description of Fleet views.
@Target({TargetKind.classType})
class ViewGen {
  /// Creates a new [ViewGen] annotation.
  const ViewGen();
}

/// Convenience constant for a [ViewGen] annotation without options.
const viewGen = ViewGen();
