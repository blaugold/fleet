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
    _buffer.writeClass(
      name: viewModel.implementationClassName.toString(),
      extendsType: viewModel.declarationClassName,
      // ignore: unnecessary_lambdas
      () {
        _buildConstructor();
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
        ],
      ),
    );
  }
}
