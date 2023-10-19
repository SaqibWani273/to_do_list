import 'package:flutter/material.dart';

import '../../constants/theme/custom_theme.dart';

class CustomIconButton extends StatelessWidget {
  CustomIconButton({
    Key? key,
    this.alignment,
    this.margin,
    thiseight,
    this.width,
    this.padding,
    this.decoration,
    this.child,
    this.onTap,
    this.height,
  }) : super(
          key: key,
        );

  final Alignment? alignment;

  final EdgeInsetsGeometry? margin;

  final double? height;

  final double? width;

  final EdgeInsetsGeometry? padding;

  final BoxDecoration? decoration;

  final Widget? child;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: iconButtonWidget,
          )
        : iconButtonWidget;
  }

  Widget get iconButtonWidget => Padding(
        padding: margin ?? EdgeInsets.zero,
        child: SizedBox(
          height: height ?? 0,
          width: width ?? 0,
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: Container(
              padding: padding ?? EdgeInsets.zero,
              decoration: decoration ??
                  BoxDecoration(
                    color: appTheme.indigo30001,
                    borderRadius: BorderRadius.circular(32),
                  ),
              child: child,
            ),
            onPressed: onTap,
          ),
        ),
      );
}

/// Extension on [CustomIconButton] to facilitate inclusion of all types of border style etc
extension IconButtonStyleHelper on CustomIconButton {
  static BoxDecoration get fillLightGreenA => BoxDecoration(
        color: appTheme.lightGreenA100,
        borderRadius: BorderRadius.circular(4),
      );
  static BoxDecoration get fillDeepOrangeA => BoxDecoration(
        color: appTheme.deepOrangeA100,
        borderRadius: BorderRadius.circular(4),
      );
  static BoxDecoration get fillCyanA => BoxDecoration(
        color: appTheme.cyanA100,
        borderRadius: BorderRadius.circular(4),
      );
  static BoxDecoration get fillTealA => BoxDecoration(
        color: appTheme.tealA200,
        borderRadius: BorderRadius.circular(4),
      );
  static BoxDecoration get fillIndigoA => BoxDecoration(
        color: appTheme.indigoA100,
        borderRadius: BorderRadius.circular(4),
      );
  static BoxDecoration get fillPurpleA => BoxDecoration(
        color: appTheme.purpleA10001,
        borderRadius: BorderRadius.circular(4),
      );
  static BoxDecoration get fillPurpleATL4 => BoxDecoration(
        color: appTheme.purpleA100,
        borderRadius: BorderRadius.circular(4),
      );
  static BoxDecoration get fillGreenA => BoxDecoration(
        color: appTheme.greenA200,
        borderRadius: BorderRadius.circular(4),
      );
  static BoxDecoration get fillLightBlue => BoxDecoration(
        color: appTheme.lightBlue200,
        borderRadius: BorderRadius.circular(4),
      );
  static BoxDecoration get fillOrange => BoxDecoration(
        color: appTheme.orange200,
        borderRadius: BorderRadius.circular(4),
      );
  static BoxDecoration get fillTealATL4 => BoxDecoration(
        color: appTheme.tealA20001,
        borderRadius: BorderRadius.circular(4),
      );
  static BoxDecoration get fillWhiteA => BoxDecoration(
        color: appTheme.whiteA700.withOpacity(0.21),
        borderRadius: BorderRadius.circular(6),
      );
  static BoxDecoration get fillLime => BoxDecoration(
        color: appTheme.lime600,
        borderRadius: BorderRadius.circular(18),
      );
  static BoxDecoration get fillGray => BoxDecoration(
        color: appTheme.gray90003,
        borderRadius: BorderRadius.circular(4),
      );
  static BoxDecoration get fillRedA => BoxDecoration(
        color: appTheme.redA100,
        borderRadius: BorderRadius.circular(4),
      );
}
