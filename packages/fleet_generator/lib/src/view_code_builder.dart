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
    return _buffer.toString();
  }

  void _buildImplementationClass() {
    if (viewModel.docComment != null) {
      _buffer.writeln(viewModel.docComment);
    }
    _buffer.writeClass(
      name: viewModel.implementationClassName.toString(),
      extendsType: viewModel.declarationClassName,
      () {
        _buildConstructor();
        _buildParameterFields();
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
}
