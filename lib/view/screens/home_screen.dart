import 'package:flutter/material.dart';

import '../../constants/bottom_app_bar_constants.dart';
import '../../constants/image_constants.dart';
import '../../model/bottom_menu_model.dart';
import '../widgets/app_bar/appbar_image.dart';
import '../widgets/app_bar/appbar_image_1.dart';
import '../widgets/app_bar/appbar_title.dart';
import '../widgets/app_bar/custom_app_bar.dart';
import '../widgets/custom_bottom_app_bar.dart';
import '../widgets/custom_image_view.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key})
      : super(
          key: key,
        );

  // GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          height: 62,
          leadingWidth: 57,
          centerTitle: true,
        ),
        body: Container(
          width: double.maxFinite,
          padding: const EdgeInsets.only(
            left: 52,
            top: 68,
            right: 52,
          ),
          child: Column(
            children: [
              CustomImageView(
                svgPath: ImageConstant.imgChecklistrafiki,
                height: MediaQuery.of(context).size.height * 0.2,
                width: 227,
              ),
              const SizedBox(height: 14),
              Text(
                "What do you want to do today?",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 13),
              Text(
                "Tap  + to add your tasks",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 13),
            ],
          ),
        ),
        bottomNavigationBar: CustomBottomAppBar(
          onChanged: (BottomBarEnum type) {},
        ),
      ),
    );
  }
}
