import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';

/// The full name of a type, including type parameters.
class TypeName {
  /// Creates a new [TypeName].
  TypeName(
    this.name, {
    this.typeArguments = const [],
    this.isOptional = false,
  });

  /// The name of the type, without type parameters.
  final String name;

  /// The type parameters of the concrete type instantiation represented by this
  /// [TypeName].
  final List<TypeName> typeArguments;

  /// Whether the type is optional.
  final bool isOptional;

  @override
  String toString() {
    String result;
    if (typeArguments.isEmpty) {
      result = name;
    } else {
      result = '$name<${typeArguments.join(', ')}>';
    }
    if (isOptional) {
      result = '$result?';
    }
    return result;
  }
}

/// Extension for converting a [DartType] to a [TypeName].
extension DartTypeTypeName on DartType {
  /// Converts this [DartType] to a [TypeName].
  TypeName toTypeName() {
    final typeArguments = <TypeName>[];

    final alias = this.alias;
    if (alias != null) {
      for (final typeArgument in alias.typeArguments) {
        typeArguments.add(typeArgument.toTypeName());
      }
    } else {
      final self = this;
      if (self is ParameterizedType) {
        for (final typeArgument in self.typeArguments) {
          typeArguments.add(typeArgument.toTypeName());
        }
      }
    }

    return TypeName(
      typeNameOf(this),
      typeArguments: typeArguments,
      isOptional: nullabilitySuffix == NullabilitySuffix.question,
    );
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
      result.write(',]');
    } else if (named.isNotEmpty) {
      if (positional.isNotEmpty) {
        result.write(', ');
      }
      result.write('{');
      result.writeAll(named, ', ');
      result.write(',}');
    } else if (positional.isNotEmpty) {
      result.write(',');
    }
    result.write(')');
    return result.toString();
  }
}

/// Information about a Fleet view that are required for code generation.
class ViewModel {
  /// Creates a new [ViewModel].
  ViewModel({
    required this.name,
    this.docComment,
    required this.fields,
  });

  /// The name of the view.
  final String name;

  /// The doc comment of the view class, including comment syntax.
  final String? docComment;

  /// Whether the view is stateful.
  ///
  /// A stateful view requires rebuilding not just when it's parameters change,
  /// but also when the state of the view changes. The state can be owned by the
  /// view itself, or be provided to the view.
  bool get isStateful => fields.any((element) => element is ViewStateField);

  /// All the fields of the view.
  final List<ViewField> fields;

  /// The parameters of the view.
  late final List<ViewParameter> parameters =
      fields.whereType<ViewParameter>().toList();

  /// The state fields of the view.
  late final List<ViewStateField> stateFields =
      fields.whereType<ViewStateField>().toList();

  /// The type name of the widget class that hosts the view.
  TypeName get widgetClassName => TypeName(name);

  /// The type name of the class the is generated and that the view declaration
  /// class must extend.
  TypeName get declarationBaseClassName => TypeName('_\$$name');

  /// The type name of the class that was written by a user to declare the view.
  TypeName get declarationClassName => TypeName('_$name');

  /// The type name of the class that is generated to fully implement the view.
  TypeName get implementationClassName => TypeName('_${name}Impl');
}

/// A field in a view.
abstract class ViewField {
  /// Creates a new [ViewField].
  ViewField({
    required this.name,
    required this.type,
  });

  /// The name of the field.
  final String name;

  /// The type of the field.
  final TypeName type;
}

/// A public parameter of a view.
class ViewParameter extends ViewField {
  /// Creates a new [ViewParameter].
  ViewParameter({
    required super.name,
    required super.type,
    this.docComment,
  });

  /// The doc comment of the parameter, including comment syntax.
  final String? docComment;
}

/// A field of a view that holds and owns some state.
class ViewStateField extends ViewField {
  /// Creates a new [ViewStateField].
  ViewStateField({
    required super.name,
    required super.type,
  });
}
