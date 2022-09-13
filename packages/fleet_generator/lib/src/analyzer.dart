import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_gen/source_gen.dart';

import 'model.dart';

/// Analyzes Dart code to validate it for code generation with Fleet and builds
/// models to be used for code generation.
class FleetAnalyzer {
  /// Analyzes the given [element] for code generation for a Fleet view and
  /// returns a [ViewModel] that describes the view.
  ViewModel analyzeViewElement(Element element) {
    _validateViewElement(element);

    // Remove the leading underscore.
    final viewName = element.name!.substring(1);

    return ViewModel(
      name: viewName,
    );
  }

  void _validateViewElement(Element element) {
    if (element is! ClassElement) {
      _errorFor(element, 'ViewGen must be applied to a class.');
    }

    if (!element.extendsViewWidget) {
      _errorFor(element, 'A view must extend ViewWidget.');
    }

    if (element.interfaces.isNotEmpty) {
      _errorFor(element, 'A view must not implement interfaces.');
    }

    if (element.mixins.isNotEmpty) {
      _errorFor(element, 'A view must not mix in mixins.');
    }

    if (!element.name.startsWith('_')) {
      _errorFor(
        element,
        'The name of a class that is annotated with ViewGen must start with '
        "'_'.",
      );
    }

    if (!element.hasViewDeclarationConstructor) {
      _errorFor(
        element,
        'A class that is annotated with ViewGen must have only the default '
        'constructor with the signature ({super.key}).',
      );
    }

    if (element.accessors.isNotEmpty) {
      _errorFor(
        element,
        'A view must not have any accessors.',
      );
    }
  }

  Never _errorFor(Element element, String message, {String todo = ''}) {
    throw InvalidGenerationSourceError(
      message,
      todo: todo,
      element: element,
    );
  }
}

extension on ClassElement {
  bool get extendsViewWidget {
    return supertype?.isViewWidget ?? false;
  }

  bool get isViewWidget {
    // We cannot use TypeChecker because importing Flutter libraries crashes
    // compiling the build_runner build script.
    // ViewWidget extends Widget.
    return name == 'ViewWidget' &&
        librarySource.uri.toString() == 'package:fleet_view/src/view.dart';
  }

  bool get hasViewDeclarationConstructor {
    if (constructors.length != 1) {
      return false;
    }

    final constructor = constructors.first;
    if (!constructor.isDefaultConstructor) {
      return false;
    }

    if (constructor.parameters.length != 1) {
      return false;
    }

    final parameter = constructor.parameters.first;
    if (parameter.name != 'key' || !parameter.isSuperFormal) {
      return false;
    }

    return true;
  }
}

extension on InterfaceType {
  bool get isViewWidget {
    final element = element2;
    return element is ClassElement && element.isViewWidget;
  }
}
