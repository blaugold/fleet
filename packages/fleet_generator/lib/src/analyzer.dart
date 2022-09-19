import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
// ignore: implementation_imports
import 'package:fleet/src/annotation.dart';
import 'package:source_gen/source_gen.dart';

import 'model.dart';

const _stateTypeChecker = TypeChecker.fromRuntime(StateGen);

/// Analyzes Dart code to validate it for code generation with Fleet and builds
/// models to be used for code generation.
class FleetAnalyzer {
  /// Analyzes the given [element] for code generation for a Fleet view and
  /// returns a [ViewModel] that describes the view.
  ViewModel analyzeViewElement(Element element) {
    final viewClass = _validateViewElement(element);

    // Remove the leading underscore of the view class.
    final viewName = viewClass.name.substring(1);

    return ViewModel(
      name: viewName,
      docComment: viewClass.documentationComment,
      fields: _analyzeViewFields(viewClass),
    );
  }

  ClassElement _validateViewElement(Element element) {
    if (element is! ClassElement) {
      _errorFor(element, 'view must be applied to a class.');
    }

    if (!element.isAbstract) {
      _errorFor(element, 'A view class must be abstract.');
    }

    if (!element.name.startsWith('_')) {
      _errorFor(
        element,
        "The name of a view class must start with '_'.",
      );
    }

    if (!element.extendsViewDeclarationBase) {
      _errorFor(
        element,
        'The view class must extend ${element.viewDeclarationBaseName}.',
      );
    }

    if (element.interfaces.isNotEmpty) {
      _errorFor(element, 'A view class must not implement interfaces.');
    }

    if (element.mixins.isNotEmpty) {
      _errorFor(element, 'A view class must not mix in mixins.');
    }

    if (element.constructors.length > 1 ||
        !element.constructors.first.isSynthetic) {
      _errorFor(
        element,
        'A view class must have not have any constructors.',
      );
    }

    return element;
  }

  List<ViewField> _analyzeViewFields(ClassElement viewClass) {
    final fields = viewClass.fields;
    final viewFields = <ViewField>[];

    for (final field in fields) {
      if (field.isPrivate) {
        if (_stateTypeChecker.hasAnnotationOfExact(field)) {
          viewFields.add(_analyzeViewStateField(field));
        } else {
          _errorFor(
            field,
            'A private view field must be annotated with @state.',
          );
        }
      } else {
        // All public fields are view parameters.
        viewFields.add(_analyzeViewParameter(field));
      }
    }

    return viewFields;
  }

  ViewParameter _analyzeViewParameter(FieldElement field) {
    if (!field.isAbstract) {
      _errorFor(
        field,
        'A view class parameter must be an abstract field.',
      );
    }

    if (!field.isFinal) {
      _errorFor(
        field,
        'A view class parameter must be a final field.',
      );
    }

    if (field.isSynthetic) {
      _errorFor(
        field,
        'A view class parameter must not be a synthetic field.',
      );
    }

    return ViewParameter(
      name: field.name,
      type: field.type.toTypeName(),
      docComment: field.documentationComment,
    );
  }

  ViewField _analyzeViewStateField(FieldElement field) {
    if (!field.isLate) {
      _errorFor(
        field,
        'A view state field must be a late field.',
      );
    }

    if (!field.hasInitializer) {
      _errorFor(
        field,
        'A view state field must have an initializer.',
      );
    }

    if (field.isFinal) {
      _errorFor(
        field,
        'A view state field must not be a final field.',
      );
    }

    if (field.isSynthetic) {
      _errorFor(
        field,
        'A view state field must not be a synthetic field.',
      );
    }

    return ViewStateField(
      name: field.name,
      type: field.type.toTypeName(),
    );
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
  String get viewDeclarationBaseName {
    return '_\$${name.substring(1)}';
  }

  bool get extendsViewDeclarationBase {
    final supertype = this.supertype;
    if (supertype == null) {
      return false;
    }

    return ((session!.getParsedLibraryByElement(library) as ParsedLibraryResult)
                .getElementDeclaration(this)!
                .node as ClassDeclaration)
            .extendsClause
            ?.superclass
            .name
            .name ==
        viewDeclarationBaseName;
  }
}
