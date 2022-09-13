import 'package:fleet_view/fleet_view.dart';
import 'package:flutter/widgets.dart';

part 'view_doc_comment_test.g.dart';

void main() {}

/// A view doc comment.
@viewGen
abstract class _DocCommentView extends ViewWidget {
  _DocCommentView({super.key});

  /// The parameter doc comment.
  abstract final String a;

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
