/// The reason why a state change is being applied.
enum SetStateReason {
  /// The state was changed by the user.
  change,

  /// The state is being restored to a previous value.
  revert,

  /// The state is being applied to rebuild dependent state.
  rebuild,
}

/// Function that set state to a provided value.
typedef StateSetter<T> = void Function(T, SetStateReason reason);

/// Function that needs to be used to update state that is managed by Fleet.
///
/// Callers do not need to update the state directly. Instead, this function
/// calls uses [stateSetter] to update the state before it returns.
void updateState<T>(
  T oldValue,
  T newValue,
  StateSetter<T> stateSetter,
) {
  if (oldValue == newValue) {
    return;
  }

  stateSetter(newValue, SetStateReason.change);

  // TODO: buffer state changes and apply them in a single transaction
  // to reduce the number of rebuilds.
  stateSetter(newValue, SetStateReason.rebuild);
}
