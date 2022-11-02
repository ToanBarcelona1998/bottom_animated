import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:mcvgo_bottom_animated/src/utils/extensions.dart';

part 'bottom_animated_data.dart';
part 'tab_bar_animated_widget.dart';
part 'constant.dart';
part 'types.dart';
part 'bottom_tab_animated_widget.dart';

class CustomBottomAnimatedWidget<D, T> extends StatefulWidget {
  final BottomAnimatedBuilder<D, T> builder;
  final List<BottomAnimatedListData<D, T>> data;
  final OnBottomDrag<double>? onBottomDragUpdate;
  final OnBottomDrag<double>? onBottomDragEnd;
  final TabBuilder<D, T> tabBuilder;
  final TabSelectedBuilder<D, T> selectedTabBuilder;
  final int indexSelected;
  final Curve? curve;
  final double? tabHeight;
  final CustomBottomChildBuilder<D, T>? child;
  final BottomAnimatedType type;
  final double? bottomHeight;
  final BottomTabBuilder<T>? bottomTabBuilder;
  final BottomTabSelectedBuilder<T>? bottomTabSelectedBuilder;
  final OnKeyBoardEnable? onKeyBoardEnable;
  final OnBottomChange ?onBottomChange;

  const CustomBottomAnimatedWidget({
    required this.builder,
    required this.data,
    this.onBottomDragUpdate,
    this.onBottomDragEnd,
    required this.selectedTabBuilder,
    required this.tabBuilder,
    this.indexSelected = 0,
    this.curve,
    this.tabHeight,
    this.child,
    this.bottomHeight,
    this.bottomTabBuilder,
    this.bottomTabSelectedBuilder,
    this.type = BottomAnimatedType.multiChild,
    GlobalKey<CustomBottomAnimatedWidgetState<D, T>>? bottomKey,
    this.onKeyBoardEnable,
    this.onBottomChange,
  }) : super(key: bottomKey);

  @override
  State<CustomBottomAnimatedWidget> createState() =>
      CustomBottomAnimatedWidgetState<D, T>();
}

class CustomBottomAnimatedWidgetState<D, T>
    extends State<CustomBottomAnimatedWidget<D, T>>
    with SingleTickerProviderStateMixin {
  ///init

  final List<GlobalKey<_TabBarAnimatedWidgetState<D, T>>> _tabBarKeys =
      List.empty(growable: true);
  final GlobalKey<_BottomTabAnimatedWidgetState<T>> _bottomTabKey = GlobalKey();

  void _initKeys() {
    _tabBarKeys.clear();
    for (final data in widget.data) {
      _tabControllers.add(PageController());
      _tabBarKeys.add(GlobalKey());
    }
  }

  final List<PageController> _tabControllers = List.empty(growable: true);

  final PageController _bottomTabController = PageController();

  final KeyboardVisibilityController _keyboardVisibilityController =
      KeyboardVisibilityController();

  ///
  late int _currentIndex;
  late int _currentGlobalIndex;
  late AnimationController _childController;
  late Animation _animation;

  late bool _showBottom;


  ///
  StreamSubscription ? _listenKeyBoardChange;

  @override
  void initState() {
    super.initState();
    _initKeys();
    _currentGlobalIndex = widget.indexSelected;
    _currentIndex = 0;
    _childController = AnimationController(
      vsync: this,
      duration: _duration,
    );
    _showBottom = false;
    _animation = Tween<double>(begin: _defaultHeight, end: 0).animate(
      CurvedAnimation(parent: _childController, curve: widget.curve ?? _curves),
    );

    _listenKeyBoardChange = _keyboardVisibilityController.onChange.listen((event) {
      _showBottom = false;
      widget.onBottomChange?.call(_showBottom);
      widget.onKeyBoardEnable?.call(event);
    });
  }

  @override
  void didUpdateWidget(covariant CustomBottomAnimatedWidget<D, T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.data.length != widget.data.length) {
      _initKeys();
    }
  }

  @override
  void dispose() {
    for (final tab in _tabControllers) {
      tab.dispose();
    }
    _listenKeyBoardChange?.cancel();
    _listenKeyBoardChange = null;
    _bottomTabController.dispose();
    _childController.dispose();
    super.dispose();
  }

  ///handle drag animated widget
  double _dragStart = 0.0;
  double _dragUpdate = 0.0;

  bool get _isDragDown => _dragStart < _dragUpdate;

  _TabBarAnimatedWidgetState _currentTabState(int index) =>
      _tabBarKeys[index].currentState!;

  ///

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
        controller: _keyboardVisibilityController,
        builder: (_, isKeyboardVisible) {
          if (_showBottom) {
            return Visibility(
              visible: !isKeyboardVisible,
              child: GestureDetector(
                onVerticalDragEnd: _onDragEnd,
                onVerticalDragUpdate: _onDragUpdate,
                onVerticalDragStart: _onDragStart,
                behavior: HitTestBehavior.opaque,
                child: AnimatedBuilder(
                  animation: _childController,
                  builder: (_, child) {
                    return Transform.translate(
                      offset: Offset(0, _animation.value),
                      child: child,
                    );
                  },
                  child: SizedBox(
                    height: widget.bottomHeight ?? _defaultHeight,
                    child:
                        widget.child?.call(widget.data) ?? _bottomChildBuilder,
                  ),
                ),
              ),
            );
          }
          return const SizedBox();
        });
  }

  Widget get _bottomChildBuilder {
    return Column(
      children: [
        Expanded(
          child: PageView.custom(
            childrenDelegate: SliverChildBuilderDelegate(
              (context, globalIndex) {
                return Column(
                  children: [
                    _TabBarAnimatedWidget<D, T>(
                      data: widget.data[globalIndex].data
                          .map((e) => e.parent)
                          .toList(),
                      type: widget.data[globalIndex].type,
                      builder: widget.tabBuilder,
                      onChange: (index) async {
                        if (index == _currentIndex) return;
                        _currentIndex = index;
                        await _tabControllers[globalIndex].animateToPage(
                          _currentIndex,
                          duration: _duration,
                          curve: widget.curve ?? _curves,
                        );
                      },
                      height: widget.tabHeight,
                      index: _currentIndex,
                      selectedBuilder: widget.selectedTabBuilder,
                      curve: widget.curve ?? _curves,
                      tabKey: _tabBarKeys[globalIndex],
                      duration: _duration,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Expanded(
                      child: PageView.custom(
                        childrenDelegate: SliverChildBuilderDelegate(
                          (context, index) => _BottomAnimatedBodyBuilder<D, T>(
                            builder: widget.builder,
                            data: widget.data[globalIndex].data,
                            index: index,
                            type: widget.data[globalIndex].type,
                            childCount: widget.data[globalIndex].childCount,
                          ),
                          addAutomaticKeepAlives: true,
                          childCount: widget.data[globalIndex].data.length,
                        ),
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        controller: _tabControllers[globalIndex],
                        key: GlobalKey(),
                        onPageChanged: (tabIndex) =>
                            _onPageViewChange(tabIndex, globalIndex),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                  ],
                );
              },
              childCount: widget.data.length,
            ),
            scrollDirection: Axis.horizontal,
            controller: _bottomTabController,
            physics: const NeverScrollableScrollPhysics(),
          ),
        ),
        if (widget.type == BottomAnimatedType.multiChild)
          _BottomTabAnimatedWidget<T>(
            data: widget.data.map((e) => e.type).toList(),
            builder: widget.bottomTabBuilder!,
            onChange: (index) async {
              if (index == _currentGlobalIndex) return;
              _currentGlobalIndex = index;
              await _bottomTabController.animateToPage(
                _currentGlobalIndex,
                duration: _duration,
                curve: widget.curve ?? _curves,
              );
            },
            height: widget.tabHeight,
            index: _currentGlobalIndex,
            selectedBuilder: widget.bottomTabSelectedBuilder!,
            curve: widget.curve ?? _curves,
            tabKey: _bottomTabKey,
            duration: _duration,
          ),
      ],
    );
  }

  ///handle bottom
  void animatedBottom() async {
    _currentIndex = 0;
    _currentGlobalIndex = 0;
    if (!_showBottom) {
      _showBottom = true;
      widget.onBottomChange?.call(_showBottom);
      setState(() {});
      await _childController.forward();
    } else {
      await _childController.reverse();
      _currentIndex = 0;
      _showBottom = false;
      widget.onBottomChange?.call(_showBottom);
      setState(() {});
    }
  }

  bool get hasState => _showBottom;

  ///

  void _onPageViewChange(int index, int global) async {
    await _currentTabState(global)._changeSelected(index);
  }

  void _onDragUpdate(DragUpdateDetails dragUpdateDetails) {
    _dragUpdate = dragUpdateDetails.globalPosition.dy;

    if (_isDragDown) {
      final delta = dragUpdateDetails.delta.dy;
      widget.onBottomDragUpdate?.call(delta);
    }
  }

  void _onDragEnd(DragEndDetails dragEndDetails) {
    if (_isDragDown) {
      double delta = _dragUpdate - _dragStart;
      widget.onBottomDragEnd?.call(delta);
      // _currentState._onDragEnd(delta);
    }
  }

  void _onDragStart(DragStartDetails dragStartDetails) {
    _dragStart = dragStartDetails.globalPosition.dy;
  }
}

class _BottomAnimatedBodyBuilder<D, T> extends StatefulWidget {
  final BottomAnimatedBuilder<D, T> builder;
  final List<BottomAnimatedData<D>> data;
  final int index;
  final int childCount;
  final T type;

  const _BottomAnimatedBodyBuilder(
      {required this.builder,
      required this.data,
      required this.index,
      this.childCount = 3,
      required this.type,
      Key? key})
      : super(key: key);

  @override
  State<_BottomAnimatedBodyBuilder> createState() =>
      _BottomAnimatedBodyBuilderState<D, T>();
}

class _BottomAnimatedBodyBuilderState<D, T>
    extends State<_BottomAnimatedBodyBuilder<D, T>>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GridView.custom(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.childCount,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
      padding: EdgeInsets.zero,
      physics: const BouncingScrollPhysics(),
      childrenDelegate: SliverChildBuilderDelegate(
          (context, index) => widget.builder(
                context,
                widget.data[widget.index].children[index],
                widget.type,
              ),
          addAutomaticKeepAlives: true,
          childCount: widget.data[widget.index].children.length,
          findChildIndexCallback: (Key key) {
        final ValueKey<BottomAnimatedData<D>?> contactKey =
            key as ValueKey<BottomAnimatedData<D>>;

        final data = contactKey.value;

        if (data != null && widget.data.contains(data) == true) {
          final index = widget.data.indexOf(data);

          if (index > 0) return index;

          return null;
        }

        return null;
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
