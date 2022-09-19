import 'package:source_gen/source_gen.dart';

import 'view_generator.dart';

/// Builder that does all the code generation supported by Fleet.
class FleetBuilder extends SharedPartBuilder {
  /// Creates a new [FleetBuilder].
  FleetBuilder() : super([ViewGenerator()], 'fleet');
}
