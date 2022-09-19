import 'package:fleet/fleet.dart';
import 'package:flutter/widgets.dart';

part 'view_doc_comment_test.g.dart';

void main() {}

/// A view doc comment.
@view
abstract class _DocCommentView extends _$DocCommentView {
  /// The parameter doc comment.
  abstract final String a;

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
