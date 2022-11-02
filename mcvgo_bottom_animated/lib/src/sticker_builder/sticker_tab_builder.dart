import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mcvgo_bottom_animated/src/cache_network_image/cache_network_image.dart';
import 'package:mcvgo_bottom_animated/src/shared.dart';
import 'package:mcvgo_bottom_animated/src/utils/extensions.dart';
import 'package:mcvgo_bottom_animated/src/utils/logger.dart';
import 'sticker_delegate.dart';
import 'package:shimmer/shimmer.dart';
import 'constant.dart';

class StickerTabSelectedBuilder extends StatelessWidget {
  final Widget child;

  const StickerTabSelectedBuilder({required this.child, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffEEEEEE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}

class StickerTabBuilder extends StatefulWidget {
  final String sticker;
  final String type;
  final StickerDelegate delegate;

  const StickerTabBuilder(
      {this.sticker = '', this.type = image, required this.delegate, Key? key})
      : super(key: key);

  @override
  State<StickerTabBuilder> createState() => _StickerTabBuilderState();
}

class _StickerTabBuilderState extends State<StickerTabBuilder>
    with ImageMixinLoader, AutomaticKeepAliveClientMixin {
  late StickerDelegate delegate;

  @override
  void initState() {
    super.initState();
    delegate = widget.delegate;
  }

  @override
  void didUpdateWidget(covariant StickerTabBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.delegate != widget.delegate){
      delegate = widget.delegate;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    switch (widget.type) {
      case json:
        return LottieBuilder.network(
          widget.sticker,
          repeat: false,
          fit: BoxFit.cover,
          errorBuilder: (_, url, s) {
            return errorBuilder(context);
          },
        );
      case image:
      default:
        if (delegate.imageType(widget.sticker).defaultImage) {
          return CacheNetworkImageExtends(
            imageUrl: widget.sticker,
            fit: BoxFit.cover,
            width: defaultTabWidth,
            height: defaultTabHeight,
            targetWidth: delegate.width(),
            targetHeight: delegate.height(),
            key: ValueKey(widget.sticker),
            errorBuilder: (_, url, stackTrace) {
              Logger.errorLog(
                  'build cache image error with url $url', stackTrace);
              return errorBuilder(context);
            },
            loadingBuilder: (_, url, loading) => Shimmer.fromColors(
              baseColor: const Color(0xffE9E7F1),
              highlightColor: const Color(0xffF2F0F2),
              child: errorBuilder(context),
            ),
          );
        }

        if (delegate.imageType(widget.sticker).svgImage) {
          return SvgPicture.network(
            widget.sticker,
            height: defaultTabHeight,
            fit: BoxFit.cover,
            placeholderBuilder: (_) => Shimmer.fromColors(
              baseColor: const Color(0xffE9E7F1),
              highlightColor: const Color(0xffF2F0F2),
              child: errorBuilder(context),
            ),
          );
        }
        Logger.errorLog('Not support sticker type ${widget.sticker}');
        return errorBuilder(context);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget errorBuilder(BuildContext context) {
    String errorType = delegate.errorType;
    if (errorType.defaultImage) {
      return Image(
        image: AssetImage(
          delegate.errorSticker(),
        ),
        height: defaultTabHeight,
        width: defaultTabWidth,
        fit: BoxFit.cover,
      );
    }

    if (errorType.svgImage) {
      SvgPicture.asset(
        delegate.errorSticker(),
        height: defaultTabHeight,
        width: defaultTabWidth,
        package: delegate.package(),
        fit: BoxFit.cover,
      );
    }
    Logger.errorLog('Not support error image type');
    return const SizedBox();
  }
}
