import 'dart:io';

import 'package:code_builder/code_builder.dart';

const flutterWidgets = [
  'Align',
  'Center',
  'ColoredBox',
  'Column',
  'Container',
  'DecoratedBox',
  'Flex',
  'Opacity',
  'Padding',
  'Positioned',
  'PositionedDirectional',
  'Row',
  'SizedBox',
  'SliverOpacity',
  'SliverPadding',
  'Transform',
];

const fleetWidgetPrefix = 'Fleet';

void main() {
  generateFlutterLibrary(name: 'widgets');
  generateFlutterLibrary(name: 'material');
  generateFlutterLibrary(name: 'cupertino');
}

Library buildFlutterLibrary({
  required String name,
}) {
  final libraryBuilder = LibraryBuilder();

  final flutterExport = DirectiveBuilder()
    ..type = DirectiveType.export
    ..url = 'package:flutter/$name.dart'
    ..hide = flutterWidgets;

  libraryBuilder.directives.add(flutterExport.build());

  final fleetImport = DirectiveBuilder()
    ..type = DirectiveType.import
    ..url = 'package:fleet/fleet.dart';

  libraryBuilder.directives.add(fleetImport.build());

  for (final widgetName in flutterWidgets) {
    final typeDefBuilder = TypeDefBuilder()
      ..name = widgetName
      ..definition =
          refer('$fleetWidgetPrefix$widgetName', 'package:fleet/fleet.dart')
      ..docs.add('/// Fleet drop-in replacement for [$widgetName].');

    libraryBuilder.body.add(typeDefBuilder.build());
  }

  return libraryBuilder.build();
}

void generateFlutterLibrary({required String name}) {
  final library = buildFlutterLibrary(name: name);
  final file = File('lib/flutter/$name.dart');
  final emitter = DartEmitter(orderDirectives: true, useNullSafetySyntax: true);
  file.createSync(recursive: true);
  file.writeAsStringSync(library.accept(emitter).toString());
  Process.runSync(
    'daco',
    ['format', file.path],
    runInShell: Platform.isWindows,
  );
}
