import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
// ignore: implementation_imports
import 'package:fleet_view/src/annotation.dart';
import 'package:source_gen/source_gen.dart';

import 'analyzer.dart';
import 'view_code_builder.dart';

/// Generator that generates code for Fleet views.
class ViewGenerator extends GeneratorForAnnotation<ViewGen> {
  final _analyzer = FleetAnalyzer();

  @override
  String? generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final viewModel = _analyzer.analyzeViewElement(element);
    return ViewCodeBuilder(viewModel).build();
  }
}
