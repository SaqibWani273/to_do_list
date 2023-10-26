import 'package:flutter/material.dart';
import 'package:to_do_list/view/screens/profile_screen.dart';
import 'dart:ui' as ui;

import '../../../constants/image_constants.dart';
import '../../../constants/theme/custom_theme.dart';
import '../custom_image_view.dart';

// ignore: must_be_immutable
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  //when using implements we assure that we'll implement all the methods of parent class
  CustomAppBar({
    Key? key,
    this.height,
    this.leadingWidth,
    this.title,
    this.centerTitle,
  }) : super(
          key: key,
        );

  final double? height;

  final double? leadingWidth;

  final Widget? title;

  final bool? centerTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      toolbarHeight: height ?? 50,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      leadingWidth: leadingWidth ?? 0,
      leading: Padding(
        padding: EdgeInsets.only(
          left: 33,
          top: 16,
          bottom: 16,
        ),
        child: CustomImageView(
          svgPath: ImageConstant.imgMenu,
          height: 24,
          width: 24,
          fit: BoxFit.contain,
        ),
      ),
      title: GestureDetector(
        onTap: () {},
        child: Padding(
          padding: EdgeInsets.zero,
          child: Text(
            'title',
            style: theme.textTheme.titleLarge!.copyWith(
              color: appTheme.whiteA700.withOpacity(0.87),
            ),
          ),
        ),
      ),
      titleSpacing: 0,
      centerTitle: centerTitle ?? false,
      actions: [
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(),
                ));
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 7,
            ),
            child: CustomImageView(
              imagePath: ImageConstant.imgProfile,
              height: 24,
              width: 24,
              fit: BoxFit.contain,
            ),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size(
        MediaQueryData.fromView(ui.window).size.width,
        height ?? 50,
      );
}
