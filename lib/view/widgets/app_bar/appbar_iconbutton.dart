import 'package:flutter/material.dart';

import '../custom_icon_button.dart';
import '../custom_image_view.dart';

// ignore: must_be_immutable
class AppbarIconbutton extends StatelessWidget {
  AppbarIconbutton({
    Key? key,
    this.imagePath,
    this.svgPath,
    this.margin,
    this.onTap,
  }) : super(
          key: key,
        );

  String? imagePath;

  String? svgPath;

  EdgeInsetsGeometry? margin;

  Function? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: CustomIconButton(
          height: 32,
          width: 32,
          padding: EdgeInsets.all(4),
          decoration: IconButtonStyleHelper.fillGray,
          child: CustomImageView(
            svgPath: svgPath,
            imagePath: imagePath,
          ),
        ),
      ),
    );
  }
}
