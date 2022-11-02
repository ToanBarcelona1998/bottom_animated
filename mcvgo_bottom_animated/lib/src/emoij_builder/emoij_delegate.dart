import 'type.dart';

abstract class EMOIJDelegate {
  String errorEMOIJ();

  String package();

  double width();

  double height();

  String imageType(String emoij) {
    return emoij.substring(emoij.lastIndexOf('.') + 1);
  }

  String get errorType => imageType(errorEMOIJ());

  EMOIJType type();
}
