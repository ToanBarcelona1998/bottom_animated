part of 'cache_network_image.dart';
typedef LoadingBuilder = Widget Function(
    BuildContext context, String url, bool onProcess);
typedef ErrorBuilder = Widget Function(
    BuildContext context, String url, StackTrace? error);