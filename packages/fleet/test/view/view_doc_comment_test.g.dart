// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'view_doc_comment_test.dart';

// **************************************************************************
// ViewGenerator
// **************************************************************************

abstract class _$DocCommentView extends FleetView {}

class _DocCommentViewImpl extends _DocCommentView {
  _DocCommentViewImpl(
    this._widget,
  );

  // ignore: unused_field
  DocCommentView _widget;

  @override
  String get a {
    return _widget.a;
  }
}

/// A view doc comment.
class DocCommentView extends FleetViewWidget {
  const DocCommentView({
    super.key,
    required this.a,
  });

  /// The parameter doc comment.
  final String a;

  @override
  FleetView createView(
    ViewElement element,
  ) {
    return _DocCommentViewImpl(this);
  }

  @override
  void updateWidget(
    FleetView view,
    DocCommentView newWidget,
  ) {
    (view as _DocCommentViewImpl)._widget = newWidget;
  }
}
