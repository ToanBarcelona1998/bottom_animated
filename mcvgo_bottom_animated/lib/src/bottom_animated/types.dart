part of 'custom_bottom_animated_widget.dart';
typedef BottomAnimatedBuilder<D,T> = Widget Function(
    BuildContext context, D data,T type);
typedef OnBottomDrag<T> = void Function([T? data]);
typedef OnTabChange<T> = void Function(T data);
typedef TabBuilder<D,T> = Widget Function(D data,T type);
typedef TabSelectedBuilder<D,T> = Widget Function(D data,T type ,Widget child);
typedef CustomBottomChildBuilder<D,T> = Widget Function(List<BottomAnimatedListData<D,T>> data);

typedef BottomTabBuilder<T> = Widget Function(T data);
typedef BottomTabSelectedBuilder<T> = Widget Function(T data, Widget child);

typedef OnKeyBoardEnable = void Function(bool isEnable);
typedef OnBottomChange = void Function(bool isEnable);

enum BottomAnimatedType{
  singleChild,
  multiChild,
}

