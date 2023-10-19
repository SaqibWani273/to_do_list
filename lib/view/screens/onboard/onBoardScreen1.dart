import 'package:flutter/material.dart';
import 'package:to_do_list/constants/image_constants.dart';
import 'package:to_do_list/view/screens/onboard/on_board_screen2.dart';
import 'package:to_do_list/view/widgets/custom_text_button.dart';

import '../../../constants/theme/custom_theme.dart';
import '../../widgets/custom_image_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class onBoardScreen1 extends StatelessWidget {
  const onBoardScreen1({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: mediaQueryData.size.height,
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 10,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: CustomTextButton(text: "Skip", onPressed: () {}),
              ),
              SizedBox(height: 3),
              CustomImageView(
                svgPath: ImageConstant.onBoardImg1,
                height: mediaQueryData.size.height * 0.3,
                width: mediaQueryData.size.width * 0.8,
              ),
              SizedBox(height: 51),
              SizedBox(
                height: 4,
                child: AnimatedSmoothIndicator(
                  activeIndex: 0,
                  count: 3,
                  effect: ScrollingDotsEffect(
                    spacing: 8,
                    activeDotColor: appTheme.whiteA700.withOpacity(0.87),
                    dotColor: appTheme.gray400,
                    dotHeight: 4,
                    dotWidth: 26,
                  ),
                ),
              ),
              SizedBox(height: 52),
              Text(
                "Manage Your Tasks",
                style: theme.textTheme.headlineLarge,
              ),
              Container(
                width: 265,
                margin: EdgeInsets.only(
                  left: 30,
                  top: 40,
                  right: 30,
                ),
                child: Text(
                  "You can easily manage all of your tasks in SaQib's ToDo for free",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    height: 1.50,
                  ),
                ),
              ),
              Spacer(),
              SizedBox(height: 45),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                        top: 14,
                        bottom: 13,
                      ),
                      child: CustomTextButton(text: 'Back', onPressed: () {})),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OnBoardScreen2(),
                      ));
                    },
                    child: Text('Next'),
                  ),
                  // CustomElevatedButton(
                  //   width: 90,
                  //   text: "lbl_next".toUpperCase(),
                  //   buttonStyle: CustomButtonStyles.fillPrimary,
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
