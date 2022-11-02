// import 'package:flutter/material.dart';
// import 'package:mcvgo_bottom_animated/mcvgo_bottom_animated.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: HomePage(),
//     );
//   }
// }
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   final GlobalKey<CustomBottomAnimatedWidgetState<String>> _bottomKey =
//       GlobalKey();
//
//   ///default data
//   List<BottomAnimatedData<String>> list = List.empty(growable: true)
//     ..addAll(
//       [
//         BottomAnimatedData(
//             parent: 'one', children: List.generate(2, (index) => '$index'))
//       ],
//     );
//
//   ///if you have other data. convert your data to [BottomAnimatedData] to use.
//   ///example
// //
// //   enum Status {
// //   @JsonValue('NEW')
// //   newS,
// //   @JsonValue('ACTIVE')
// //   active,
// //   @JsonValue('INACTIVE')
// //   deActive,
// //   @JsonValue('DELETED')
// //   delete
// // }
// //
// // enum StickerType {
// //   @JsonValue('IMAGE')
// //   image,
// //   @JsonValue('JSON')
// //   json,
// // }
// //
// // extension StickerTypeEX on StickerType{
// //   String get type => name.toUpperCase();
// // }
// //
// // class StickerBase {
// //   @JsonKey(name: 'id')
// //   final int? id;
// //   @JsonKey(name: 'displayPosition')
// //   final int? displayPosition;
// //   @JsonKey(name: 'status')
// //   final Status? status;
// //   @JsonKey(name: 'createAt')
// //   final String? createAt;
// //   @JsonKey(name: 'updateAt')
// //   final String? updateAt;
// //
// //   const StickerBase(
// //       {this.id,
// //         this.status,
// //         this.createAt,
// //         this.displayPosition,
// //         this.updateAt});
// // }
// //
// // @JsonSerializable()
// // class GroupSticker extends StickerBase {
// //   @JsonKey(name: 'icon')
// //   final String? icon;
// //   @JsonKey(name: 'name')
// //   final String? name;
// //   @JsonKey(name: 'items')
// //   final List<Sticker>? stickers;
// //
// //   const GroupSticker(
// //       {this.icon,
// //         this.name,
// //         this.stickers,
// //         int? id,
// //         Status? status,
// //         String? createAt,
// //         String? updateAt,
// //         int? displayPosition})
// //       : super(
// //     id: id,
// //     status: status,
// //     createAt: createAt,
// //     displayPosition: displayPosition,
// //     updateAt: updateAt,
// //   );
// //
// //   factory GroupSticker.fromJson(Map<String, dynamic> json) =>
// //       _$GroupStickerFromJson(json);
// //
// //   Map<String, dynamic> toJson() {
// //     final map = _$GroupStickerToJson(this);
// //     map['items'] = stickers
// //         ?.map(
// //           (e) => e.toJson(),
// //     )
// //         .toList();
// //     return map;
// //   }
// // }
// //
// // @JsonSerializable()
// // class Sticker extends StickerBase {
// //   @JsonKey(name: 'sticker')
// //   final String? sticker;
// //   @JsonKey(name: 'charCode')
// //   final String? charCode;
// //   @JsonKey(name: 'type')
// //   final StickerType ?type;
// //
// //   const Sticker(
// //       {this.sticker,
// //         this.charCode,
// //         this.type,
// //         int? id,
// //         Status? status,
// //         String? createAt,
// //         String? updateAt,
// //         int? displayPosition})
// //       : super(
// //     id: id,
// //     status: status,
// //     createAt: createAt,
// //     displayPosition: displayPosition,
// //     updateAt: updateAt,
// //   );
// //
// //   factory Sticker.fromJson(Map<String, dynamic> json) =>
// //       _$StickerFromJson(json);
// //
// //   Map<String, dynamic> toJson() => _$StickerToJson(this);
// // }
// //   extension GroupStickerX on List<StickerBase> {
// //        List<BottomAnimatedData<StickerBase>> get merge => List.generate(
// //        length,
// //          (index) => BottomAnimatedData(
// //          parent: this[index],
// //        children: (this[index] as GroupSticker).stickers ?? [],
// //   ),
// //   );
// //   }
//   ///
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: ListView(
//         children: [
//           GestureDetector(
//             onTap: () => _bottomKey.currentState!.animatedBottom(),
//             child: const Text('show'),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           CustomBottomAnimatedWidget<String>(
//             builder: (_, data) => Text(data),
//             data: list,
//             selectedTabBuilder: (data, child) => child,
//             tabBuilder: (data) => Text(data),
//             bottomKey: _bottomKey,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class SCStickerDelegate extends StickerDelegate {
//   @override
//   String errorSticker() {
//     return 'assets/icons/svgs/chat/sc_ic_sticker_error.svg';
//   }
//
//   @override
//   String package() {
//     return 'speed_couple';
//   }
//
//   @override
//   double height() {
//     // TODO: implement height
//     throw UnimplementedError();
//   }
//
//   @override
//   double width() {
//     // TODO: implement width
//     throw UnimplementedError();
//   }
// }
