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
    _buildViewDeclarationBaseClass();
    _buildViewImplementationClass();
    _buildWidgetClass();
    return _buffer.toString();
  }

  void _buildViewDeclarationBaseClass() {
    _buffer.writeClass(
      isAbstract: true,
      name: viewModel.declarationBaseClassName.name,
      extendsType: TypeName('FleetView'),
      () {},
    );
  }

  void _buildViewImplementationClass() {
    _buffer.writeClass(
      name: viewModel.implementationClassName.name,
      extendsType: viewModel.declarationClassName,
      () {
        _buildViewImplementationClassConstructor();
        _buildViewImplementationClassFields();
        _buildParameterGetters();
        _buildStateFieldSetters();
      },
    );
  }

  void _buildViewImplementationClassConstructor() {
    _buffer.writeConstructor(
      className: viewModel.implementationClassName.name,
      parameters: ParameterList(
        positional: [
          if (viewModel.isStateful)
            Parameter('_element', isInitializingFormal: true),
          Parameter('_widget', isInitializingFormal: true),
        ],
      ),
      viewModel.isStateful ? _buildStateFieldInitializersCalls : null,
    );
  }

  void _buildViewImplementationClassFields() {
    if (viewModel.isStateful) {
      _buffer.writeField(
        name: '_element',
        type: TypeName('ViewElement'),
        isFinal: true,
      );
    }

    _buffer.writeln('  // ignore: unused_field');
    _buffer.writeField(
      name: '_widget',
      type: viewModel.widgetClassName,
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

  void _buildStateFieldInitializersCalls() {
    for (final field in viewModel.stateFields) {
      _buffer.writeln('// ignore: unnecessary_statements');
      _buffer.write(field.name);
      _buffer.writeln(';');
    }
  }

  void _buildStateFieldSetters() {
    for (final field in viewModel.stateFields) {
      _buffer.writeSetter(
        isOverride: true,
        name: field.name,
        type: field.type,
        () {
          _buffer.write('updateState<');
          _buffer.write(field.type);
          _buffer.write('>(super.');
          _buffer.write(field.name);
          _buffer.writeln(', value, (value, reason) {');
          _buffer.write('super.');
          _buffer.write(field.name);
          _buffer.writeln(' = value;');
          _buffer.writeln('if (reason == SetStateReason.rebuild) {');
          _buffer.writeln('   _element.markNeedsBuild();');
          _buffer.writeln('}');
          _buffer.writeln('});');
        },
      );
    }
  }

  void _buildWidgetClass() {
    if (viewModel.docComment != null) {
      _buffer.writeln(viewModel.docComment);
    }
    _buffer.writeClass(
      name: viewModel.widgetClassName.name,
      extendsType: TypeName('FleetViewWidget'),
      () {
        _buildConstructor();
        _buildParameterFields();
        _buildCreateViewMethod();
        _buildUpdateWidgetMethod();
      },
    );
  }

  void _buildConstructor() {
    _buffer.writeConstructor(
      null,
      isConst: true,
      className: viewModel.widgetClassName.name,
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
      );
    }
  }

  void _buildCreateViewMethod() {
    _buffer.writeFunction(
      isOverride: true,
      name: 'createView',
      returnType: TypeName('FleetView'),
      parameters: ParameterList(
        positional: [
          Parameter('element', type: TypeName('ViewElement')),
        ],
      ),
      () {
        _buffer.write('return ');
        _buffer.write(viewModel.implementationClassName.name);
        _buffer.writeln('(');
        if (viewModel.isStateful) {
          _buffer.writeln('element, ');
        }
        _buffer.writeln('this);');
      },
    );
  }

  void _buildUpdateWidgetMethod() {
    _buffer.writeFunction(
      isOverride: true,
      name: 'updateWidget',
      parameters: ParameterList(
        positional: [
          Parameter('view', type: TypeName('FleetView')),
          Parameter('newWidget', type: viewModel.widgetClassName),
        ],
      ),
      () {
        _buffer.write('(view as ');
        _buffer.write(viewModel.implementationClassName);
        _buffer.writeln(')._widget = newWidget;');
      },
    );
  }
}
