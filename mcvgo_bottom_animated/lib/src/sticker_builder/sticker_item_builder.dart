import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:mcvgo_bottom_animated/src/cache_network_image/cache_network_image.dart';
import 'package:mcvgo_bottom_animated/src/shared.dart';
import 'package:mcvgo_bottom_animated/src/utils/extensions.dart';
import 'package:mcvgo_bottom_animated/src/utils/logger.dart';
import 'package:shimmer/shimmer.dart';
import 'constant.dart';
import 'sticker_delegate.dart';

class StickerItemBuilder extends StatefulWidget {
  final String icon;
  final String type;
  final StickerDelegate delegate;

  const StickerItemBuilder(
      {this.icon = '', this.type = image, required this.delegate, Key? key})
      : super(key: key);

  @override
  State<StickerItemBuilder> createState() => _StickerItemBuilderState();
}

class _StickerItemBuilderState extends State<StickerItemBuilder>
    with ImageMixinLoader,AutomaticKeepAliveClientMixin {
  late StickerDelegate delegate;

  @override
  void initState() {
    super.initState();
    delegate = widget.delegate;
  }

  @override
  void didUpdateWidget(covariant StickerItemBuilder oldWidget) {
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
          widget.icon,
          repeat: false,
          height: defaultHeight,
          fit: BoxFit.cover,
          errorBuilder: (_, url, s) {
            return errorBuilder(context);
          },
        );
      case image:
      default:
        if (delegate.imageType(widget.icon).defaultImage) {
          return CacheNetworkImageExtends(
            imageUrl: widget.icon,
            width: defaultWidth,
            height: defaultHeight,
            targetWidth: delegate.width(),
            targetHeight: delegate.height(),
            errorBuilder: (_, url, stackTrace) {
              Logger.errorLog('build cache image error with url $url',stackTrace);
              return errorBuilder(context);
            },
            loadingBuilder: (_, url, loading) => Shimmer.fromColors(
              baseColor: const Color(0xffE9E7F1),
              highlightColor: const Color(0xffF2F0F2),
              child: errorBuilder(context),
            ),
            fit: BoxFit.cover,
          );
        }
        if (delegate.imageType(widget.icon).svgImage) {
          return SvgPicture.network(
            widget.icon,
            height: defaultHeight,
            fit: BoxFit.cover,
            placeholderBuilder: (_) => Shimmer.fromColors(
              baseColor: const Color(0xffE9E7F1),
              highlightColor: const Color(0xffF2F0F2),
              child: errorBuilder(context),
            ),
          );
        }
        Logger.errorLog('Not support sticker type ${widget.icon}');
        return errorBuilder(context);
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget errorBuilder(BuildContext context) {
    return SvgPicture.asset(
      delegate.errorSticker(),
      height: defaultHeight,
      width: defaultWidth,
      package: delegate.package(),
      fit: BoxFit.cover,
    );
  }
}
