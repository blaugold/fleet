Alternative imports for Flutter libraries (`widgets`, `material` and
`cupertino`), that substitute widgets for which Fleet provides drop-in
replacements.

By using these imports, you can use Fleet's widgets without having to change
your code.

## Usage

Add a dependency on `fleet_imports` by running `dart pub add fleet_imports` in
your project's root directory.

Then, in your Dart code, replace the imports of `package:flutter` libraries with
the corresponding library from `package:fleet_imports`:

```diff
-import 'package:flutter/material.dart';
+import 'package:fleet_imports/flutter/material.dart';
```

If you are importing a combination of the `widgets`, `material` and `cupertino`
libraries in a file, you have to switch all of them to the corresponding
`fleet_imports` library.
