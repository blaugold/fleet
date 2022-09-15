import 'package:fleet/fleet.dart';

import 'state.dart';

/// Applies an [animation] to the state changes caused by calling [block].
T withAnimation<T>(AnimationSpec? animation, T Function() block) {
  return withTransaction(animation, block);
}
