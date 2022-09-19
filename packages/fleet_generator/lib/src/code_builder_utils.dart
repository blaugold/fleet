import 'model.dart';

/// Util for building Dart code.
extension StringBufferCodeBuilderUtils on StringBuffer {
  /// Writes a class declaration.
  ///
  /// The members of the class have to be written by the [writeMembers]
  /// callback.
  void writeClass(
    void Function() writeMembers, {
    required String name,
    TypeName? extendsType,
    bool isAbstract = false,
  }) {
    if (isAbstract) {
      write('abstract ');
    }
    write('class $name ');
    if (extendsType != null) {
      write('extends $extendsType ');
    }
    write('{');
    writeMembers();
    writeln('}');
    writeln();
  }

  /// Writes a constructor declaration.
  ///
  /// The body of the constructor has to be written by the [writeBody] callback.
  /// If the constructor has no body, the [writeBody] callback can be omitted.
  void writeConstructor(
    void Function()? writeBody, {
    bool isConst = false,
    required String className,
    String? name,
    ParameterList? parameters,
  }) {
    parameters ??= ParameterList();

    if (isConst) {
      write('const ');
    }

    write(className);
    if (name != null) {
      write('.');
      write(name);
    }
    write(parameters);

    if (writeBody != null) {
      write(' ');
      write('{');
      writeBody();
      writeln('}');
    } else {
      writeln(';');
    }
    writeln();
  }

  /// Writes a field declaration.
  void writeField({
    required String name,
    TypeName? type,
    bool isFinal = false,
    bool isOverride = false,
  }) {
    if (isOverride) {
      writeln('@override');
    }
    if (isFinal) {
      write('final ');
    }
    if (type != null) {
      write(type);
    } else if (!isFinal) {
      write('var');
    }
    write(' ');
    write(name);
    writeln(';');
    writeln();
  }

  /// Writes a getter declaration.
  ///
  /// The body of the getter has to be written by the [writeBody] callback.
  void writeGetter(
    void Function() writeBody, {
    required String name,
    required TypeName type,
    bool isOverride = false,
  }) {
    if (isOverride) {
      writeln('@override');
    }
    write(type);
    write(' get ');
    write(name);
    write(' ');
    write('{');
    writeBody();
    writeln('}');
    writeln();
  }

  /// Writes a setter declaration.
  ///
  /// The body of the setter has to be written by the [writeBody] callback.
  void writeSetter(
    void Function() writeBody, {
    required String name,
    required TypeName type,
    bool isOverride = false,
  }) {
    if (isOverride) {
      writeln('@override');
    }
    write('set ');
    write(name);
    write('(');
    write(type);
    write(' value) {');
    writeBody();
    writeln('}');
    writeln();
  }

  /// Writes a function declaration.
  ///
  /// The body of the function has to be written by the [writeBody] callback.
  void writeFunction(
    void Function() writeBody, {
    required String name,
    bool isOverride = false,
    TypeName? returnType,
    ParameterList? parameters,
  }) {
    returnType ??= TypeName('void');
    parameters ??= ParameterList();

    if (isOverride) {
      writeln('@override');
    }
    write('$returnType ');
    write(name);
    write('$parameters');
    write(' ');
    write('{');
    writeBody();
    writeln('}');
    writeln();
  }
}
