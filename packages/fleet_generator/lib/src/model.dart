/// The full name of a type, including type parameters.
class TypeName {
  /// Creates a new [TypeName].
  TypeName(this.name, [this.typeArguments = const []]);

  /// The name of the type, without type parameters.
  final String name;

  /// The type parameters of the concrete type instantiation represented by this
  /// [TypeName].
  final List<TypeName> typeArguments;

  @override
  String toString() {
    if (typeArguments.isEmpty) {
      return name;
    }
    return '$name<${typeArguments.join(', ')}>';
  }
}

/// A parameter in a [ParameterList].
class Parameter {
  /// Creates a new [Parameter].
  Parameter(
    this.name, {
    this.defaultValue,
    this.type,
    this.isInitializingFormal = false,
    this.isSuperFormal = false,
  }) : assert(
          [type != null, isInitializingFormal, isSuperFormal]
                  .where((element) => element)
                  .length ==
              1,
        );

  /// The name of the parameter.
  final String name;

  /// The type of the parameter, or null if the parameter [isInitializingFormal]
  /// or [isSuperFormal].
  final TypeName? type;

  /// The code for the expression fo default value of the parameter, or null if
  /// the parameter has no default.
  final String? defaultValue;

  /// Whether the parameter is an initializing parameter.
  final bool isInitializingFormal;

  /// Whether the parameter is a super parameter.
  final bool isSuperFormal;

  @override
  String toString() {
    final buffer = StringBuffer();
    if (isInitializingFormal) {
      buffer.write('this.');
    } else if (isSuperFormal) {
      buffer.write('super.');
    } else if (type != null) {
      buffer.write('$type ');
    }
    buffer.write(name);
    if (defaultValue != null) {
      buffer.write(' = $defaultValue');
    }
    return buffer.toString();
  }
}

/// A named parameter in a [ParameterList].
class NamedParameter extends Parameter {
  /// Creates a new [NamedParameter].
  NamedParameter(
    super.name, {
    super.type,
    super.defaultValue,
    super.isInitializingFormal,
    super.isSuperFormal,
    this.isRequired = false,
  });

  /// Whether the parameter is required.
  final bool isRequired;

  @override
  String toString() {
    var result = super.toString();
    if (isRequired) {
      result = 'required $result';
    }
    return result;
  }
}

/// A list of parameters.
class ParameterList {
  /// Creates a new [ParameterList].
  ParameterList({
    this.positional = const [],
    this.positionalOptional = const [],
    this.named = const [],
  })  : assert(positional.every((element) => element.defaultValue == null)),
        assert(positionalOptional.isEmpty || named.isEmpty);

  /// The positional parameters.
  final List<Parameter> positional;

  /// The optional positional parameters.
  final List<Parameter> positionalOptional;

  /// The named parameters.
  final List<NamedParameter> named;

  @override
  String toString() {
    final result = StringBuffer();
    result.write('(');
    result.writeAll(positional, ', ');
    if (positionalOptional.isNotEmpty) {
      if (positional.isNotEmpty) {
        result.write(', ');
      }
      result.write('[');
      result.writeAll(positionalOptional, ', ');
      result.write(']');
    }
    if (named.isNotEmpty) {
      if (positional.isNotEmpty) {
        result.write(', ');
      }
      result.write('{');
      result.writeAll(named, ', ');
      result.write('}');
    }
    result.write(')');
    return result.toString();
  }
}

/// Information about a Fleet view that are required for code generation.
class ViewModel {
  /// Creates a new [ViewModel].
  ViewModel({required this.name});

  /// The name of the view.
  final String name;

  /// The type name of the class the is generated to implement the view.
  TypeName get implementationClassName => TypeName(name);

  /// The type name of the class that was written by a user to declare the view.
  TypeName get declarationClassName => TypeName('_$name');
}
