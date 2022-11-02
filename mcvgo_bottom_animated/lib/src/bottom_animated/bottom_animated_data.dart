part of 'custom_bottom_animated_widget.dart';

class BottomAnimatedData<T> {
  final T parent;
  final List<T> children;

  const BottomAnimatedData({required this.parent, required this.children});
}

class BottomAnimatedListData<D, T> {
  final List<BottomAnimatedData<D>> data;
  final T type;
  final int childCount;

  const BottomAnimatedListData(
      {required this.data, required this.type, this.childCount = 3});
}
