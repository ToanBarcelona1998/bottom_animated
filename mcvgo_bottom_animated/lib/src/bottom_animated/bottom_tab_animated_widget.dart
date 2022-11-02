part of 'custom_bottom_animated_widget.dart';

class _BottomTabAnimatedWidget<T> extends StatefulWidget
    with PreferredSizeWidget {
  final List<T> data;
  final BottomTabBuilder<T> builder;
  final BottomTabSelectedBuilder<T> selectedBuilder;
  final Curve curve;
  final Duration? duration;
  final EdgeInsets? padding;
  final int index;
  final double? width;
  final double? height;

  final OnTabChange? onChange;

  const _BottomTabAnimatedWidget(
      {required this.data,
      required this.builder,
      required this.selectedBuilder,
      this.index = 0,
      this.curve = _curves,
      this.duration,
      this.padding,
      this.onChange,
      GlobalKey<_BottomTabAnimatedWidgetState<T>>? tabKey,
      this.width,
      this.height})
      : super(key: tabKey);

  @override
  State<_BottomTabAnimatedWidget> createState() =>
      _BottomTabAnimatedWidgetState<T>();

  @override
  Size get preferredSize {
    return const Size.fromHeight(_kTabHeight);
  }
}

class _BottomTabAnimatedWidgetState<T>
    extends State<_BottomTabAnimatedWidget<T>>
    with SingleTickerProviderStateMixin {
  late int indexSelected;
  late AnimationController _animationController;
  Animation<double>? _animation;
  late Map<int, GlobalKey> _listKey;

  @override
  void initState() {
    super.initState();
    indexSelected = widget.index;
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(milliseconds: 200),
    );
    _listKey = {};
    _mapKeyWithState();
  }

  void _mapKeyWithState() {
    for (int i = 0; i < widget.data.length; i++) {
      _listKey[i] = GlobalKey();
    }
  }

  @override
  void didUpdateWidget(covariant _BottomTabAnimatedWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _mapKeyWithState();
  }

  @override
  void dispose() {
    _animation = null;
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? context.w,
      height: widget.height ?? _tabHeight,
      child: Center(
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: List.generate(
            widget.data.length,
            (index) => buildItemTab(
              widget.data[index],
              _listKey[index] ?? GlobalKey(),
              index,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItemTab(T data, GlobalKey key, int index) {
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(_animation?.value ?? 0.0, 0),
                child: child ?? const SizedBox(),
              );
            },
            child: index == indexSelected
                ? widget.selectedBuilder.call(
                    data,
                    Visibility(
                      visible: false,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: widget.builder.call(data),
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
        ),
        InkWell(
          key: key,
          onTap: () async => await _changeSelected(index),
          child: Ink(
            padding: const EdgeInsets.all(8),
            child: widget.builder.call(data),
          ),
        ),
      ],
    );
  }

  Future<void> _changeSelected(int index) async {
    RenderBox currentBox = _listKey[indexSelected]
        ?.currentContext
        ?.findRenderObject() as RenderBox;
    Offset currentOffset = currentBox.localToGlobal(Offset.zero);
    RenderBox selectedBox =
        _listKey[index]?.currentContext?.findRenderObject() as RenderBox;
    Offset selectedOffset = selectedBox.localToGlobal(Offset.zero);
    _animation =
        Tween<double>(begin: 0.0, end: selectedOffset.dx - currentOffset.dx)
            .animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.curve,
    ));

    await _animationController.forward();

    indexSelected = index;

    _animationController.reset();

    _animation = null;

    widget.onChange?.call(index);

    setState(() {});
  }
}
