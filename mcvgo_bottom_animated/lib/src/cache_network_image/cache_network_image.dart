import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:mcvgo_bottom_animated/src/utils/cache_image_manager.dart';
import 'package:mcvgo_bottom_animated/src/utils/logger.dart';

part 'types.dart';

part 'cache_network_image_bloc.dart';

part 'prepare_cache_network_image.dart';

class CacheNetworkImageExtends extends StatefulWidget {
  final String imageUrl;
  final BoxFit fit;
  final double width;
  final double targetWidth;
  final double height;
  final double targetHeight;
  final LoadingBuilder loadingBuilder;
  final ErrorBuilder errorBuilder;
  final CacheNetWorkImageBlocBase? bloc;

  const CacheNetworkImageExtends(
      {required this.imageUrl,
      required this.fit,
      required this.width,
      required this.targetWidth,
      required this.height,
      required this.targetHeight,
      required this.loadingBuilder,
      required this.errorBuilder,
      this.bloc,
      Key? key})
      : super(key: key);

  @override
  State<CacheNetworkImageExtends> createState() =>
      _CacheNetworkImageExtendsState();
}

class _CacheNetworkImageExtendsState extends State<CacheNetworkImageExtends> {
  late CacheNetWorkImageBlocBase _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = (widget.bloc ??
        CacheNetworkImageBloc(
          url: widget.imageUrl,
          height: widget.targetHeight,
          width: widget.targetWidth,
        ))
      ..getImage();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  void didUpdateWidget(CacheNetworkImageExtends oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _bloc = (widget.bloc ??
          CacheNetworkImageBloc(
            url: widget.imageUrl,
            height: widget.targetHeight,
            width: widget.targetWidth,
          ));

      _bloc.getImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CacheImageState>(
      builder: (_, snapShot) {
        if (snapShot.hasData) {
          CacheImageState state = snapShot.data!;
          if (snapShot.data!.isLoading) {
            return widget.loadingBuilder
                .call(context, _bloc.url, state.isLoading);
          }
          if (state.isError || state.image == null) {
            return widget.errorBuilder
                .call(context, _bloc.url, state.stackTrace);
          }

          return Image.memory(
            state.image!,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
          );
        }
        return const SizedBox();
      },
      stream: _bloc.streamCache,
    );
  }
}
