import 'package:flutter/material.dart';

mixin ImageMixinLoader<T extends StatefulWidget> on State<T>{
  Widget errorBuilder(BuildContext context);
}