import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mcvgo_bottom_animated/src/cache_network_image/cache_network_image.dart';
import 'package:mcvgo_bottom_animated/src/utils/extensions.dart';
import 'package:mcvgo_bottom_animated/src/utils/logger.dart';
import 'package:shimmer/shimmer.dart';
import 'emoij_delegate.dart';
import 'type.dart';
import 'package:mcvgo_bottom_animated/src/shared.dart';

class EMOIJItemBuilder extends StatefulWidget {
  final String path;
  final EMOIJDelegate delegate;
  final bool keepAlive;

  const EMOIJItemBuilder(
      {this.keepAlive = false,
      required this.path,
      required this.delegate,
      Key? key})
      : super(key: key);

  @override
  State<EMOIJItemBuilder> createState() => _EMOIJItemBuilderState();
}

class _EMOIJItemBuilderState extends State<EMOIJItemBuilder>
    with AutomaticKeepAliveClientMixin, ImageMixinLoader {
  late EMOIJDelegate delegate;

  @override
  void initState() {
    super.initState();
    delegate = widget.delegate;
  }

  @override
  void didUpdateWidget(covariant EMOIJItemBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.delegate != widget.delegate) {
      delegate = widget.delegate;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    switch (delegate.type()) {
      case EMOIJType.assets:
        return Image(
          image: AssetImage(widget.path,package: delegate.package()),
          errorBuilder: (_, url, stackTrace) {
            Logger.errorLog(
                'build cache image error with url $url', stackTrace);
            return errorBuilder(context);
          },
          loadingBuilder: (_, url, loading) {
            if(loading == null) return url;

            return Shimmer.fromColors(
              baseColor: const Color(0xffE9E7F1),
              highlightColor: const Color(0xffF2F0F2),
              child: errorBuilder(context),
            );
          },
          fit: BoxFit.cover,
          width: delegate.width(),
          height: delegate.height(),
        );
      case EMOIJType.file:
        Logger.errorLog(
          'not support emoij type',
        );
        return const SizedBox();
      case EMOIJType.network:
        return CacheNetworkImageExtends(
          imageUrl: widget.path,
          width: delegate.width(),
          height: delegate.height(),
          targetWidth: delegate.width(),
          targetHeight: delegate.height(),
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
          fit: BoxFit.cover,
        );
    }
  }

  @override
  bool get wantKeepAlive => widget.keepAlive;

  @override
  Widget errorBuilder(BuildContext context) {
    String errorType = delegate.errorType;
    if (errorType.defaultImage) {
      return Image(
        image: AssetImage(
          delegate.errorEMOIJ(),
        ),
        height: delegate.height(),
        width: delegate.width(),
        fit: BoxFit.cover,
      );
    }

    if (errorType.svgImage) {
      SvgPicture.asset(
        delegate.errorEMOIJ(),
        height: delegate.height(),
        width: delegate.width(),
        package: delegate.package(),
        fit: BoxFit.cover,
      );
    }
    Logger.errorLog('Not support error emoij type');
    return const SizedBox();
  }
}
