import 'code_builder_utils.dart';
import 'model.dart';

/// Builder that builds the generated code for a Fleet view.
///
/// It uses the information from a [ViewModel] to build the code.
class ViewCodeBuilder {
  /// Creates a new [ViewCodeBuilder].
  ViewCodeBuilder(this.viewModel);

  /// The view model that describes the view to generated code for.
  final ViewModel viewModel;

  final _buffer = StringBuffer();

  /// Builds and returns the generated code.
  String build() {
    _buildImplementationClass();
    if (viewModel.isStateful) {
      _buildStateClass();
    }
    return _buffer.toString();
  }

  void _buildImplementationClass() {
    if (viewModel.isStateful) {
      _buffer.writeln('// ignore: must_be_immutable');
    }
    if (viewModel.docComment != null) {
      _buffer.writeln(viewModel.docComment);
    }
    _buffer.writeClass(
      name: viewModel.implementationClassName.toString(),
      extendsType: viewModel.declarationClassName,
      () {
        _buildConstructor();
        _buildParameterFields();
        if (viewModel.isStateful) {
          _buildCreateStateMethod();
        }
      },
    );
  }

  void _buildConstructor() {
    _buffer.writeConstructor(
      null,
      className: viewModel.implementationClassName.name,
      parameters: ParameterList(
        named: [
          NamedParameter('key', isSuperFormal: true),
          for (final parameter in viewModel.parameters)
            NamedParameter(
              parameter.name,
              isInitializingFormal: true,
              isRequired: !parameter.type.isOptional,
            ),
        ],
      ),
    );
  }

  void _buildParameterFields() {
    for (final parameter in viewModel.parameters) {
      if (viewModel.docComment != null) {
        _buffer.writeln(parameter.docComment);
      }
      _buffer.writeField(
        name: parameter.name,
        type: parameter.type,
        isFinal: true,
        isOverride: true,
      );
    }
  }

  void _buildCreateStateMethod() {
    _buffer.writeFunction(
      isOverride: true,
      name: 'createState',
      returnType: TypeName('ViewWidget'),
      parameters: ParameterList(
        positional: [
          Parameter('element', type: TypeName('ViewElement')),
        ],
      ),
      () {
        _buffer.write('return ');
        _buffer.write(viewModel.stateClassName.name);
        _buffer.writeln('(element, this);');
      },
    );
  }

  void _buildStateClass() {
    _buffer.writeln('// ignore: must_be_immutable');
    _buffer.writeClass(
      name: viewModel.stateClassName.name,
      extendsType: viewModel.declarationClassName,
      () {
        _buildStateClassConstructor();
        _buildStateClassFields();
        _buildUpdateWidgetMethod();
        _buildParameterGetters();
        _buildStateFieldSetters();
      },
    );
  }

  void _buildStateClassConstructor() {
    _buffer.writeConstructor(
      className: viewModel.stateClassName.name,
      parameters: ParameterList(
        positional: [
          Parameter('_element', isInitializingFormal: true),
          Parameter('_widget', isInitializingFormal: true),
        ],
      ),
      null,
    );
  }

  void _buildStateClassFields() {
    _buffer.writeField(
      name: '_element',
      type: TypeName('ViewElement'),
      isFinal: true,
    );

    _buffer.writeField(
      name: '_widget',
      type: viewModel.implementationClassName,
    );
  }

  void _buildUpdateWidgetMethod() {
    _buffer.writeFunction(
      isOverride: true,
      name: 'updateWidget',
      parameters: ParameterList(
        positional: [
          Parameter('newWidget', type: viewModel.implementationClassName)
        ],
      ),
      () {
        _buffer.writeln('_widget = newWidget;');
      },
    );
  }

  void _buildParameterGetters() {
    for (final parameter in viewModel.parameters) {
      _buffer.writeGetter(
        isOverride: true,
        name: parameter.name,
        type: parameter.type,
        () {
          _buffer.write('return _widget.');
          _buffer.write(parameter.name);
          _buffer.writeln(';');
        },
      );
    }
  }

  void _buildStateFieldSetters() {
    for (final field in viewModel.stateFields) {
      _buffer.writeSetter(
        isOverride: true,
        name: field.name,
        type: field.type,
        () {
          _buffer.write('super.');
          _buffer.write(field.name);
          _buffer.write(' = value;');
          _buffer.write('_element.markNeedsBuild();');
        },
      );
    }
  }
}
