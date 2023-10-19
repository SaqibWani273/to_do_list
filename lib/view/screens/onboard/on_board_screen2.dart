import 'package:flutter/material.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:to_do_list/constants/image_constants.dart';
import 'package:to_do_list/view/screens/onboard/onBoardScreen1.dart';
import 'package:to_do_list/view/widgets/custom_text_button.dart';

import '../../../constants/theme/custom_theme.dart';
import '../../widgets/custom_image_view.dart';
import 'on_board_screen3.dart';

class OnBoardScreen2 extends StatelessWidget {
  const OnBoardScreen2({Key? key})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.maxFinite,
          height: mediaQueryData.size.height,
          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 310,
                  width: 299,
                  child: Stack(
                    alignment: Alignment.centerRight,
                    children: [
                      Align(
                          alignment: Alignment.topLeft,
                          child:
                              CustomTextButton(text: 'Skip', onPressed: () {})),
                      CustomImageView(
                        svgPath: ImageConstant.onBoardImg2,
                        height: mediaQueryData.size.height * 0.3,
                        width: mediaQueryData.size.width * 0.8,
                        alignment: Alignment.centerRight,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: mediaQueryData.size.height * 0.035),
              SizedBox(
                height: 4,
                child: AnimatedSmoothIndicator(
                  activeIndex: 1,
                  count: 3,
                  effect: ScrollingDotsEffect(
                    spacing: 8.08,
                    activeDotColor: appTheme.whiteA700.withOpacity(0.87),
                    dotColor: appTheme.gray400,
                    dotHeight: 4,
                    dotWidth: 26,
                  ),
                ),
              ),
              SizedBox(height: mediaQueryData.size.height * 0.035),
              Text(
                "Create Daily Routine",
                style: theme.textTheme.headlineLarge,
              ),
              Container(
                width: 273,
                margin: EdgeInsets.only(
                  left: 27,
                  top: 40,
                  right: 26,
                ),
                child: Text(
                  "In Saqib's Tod0 you can create your personalized routine to stay productive",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge!.copyWith(
                    height: 1.50,
                  ),
                ),
              ),
              Spacer(),
              SizedBox(height: mediaQueryData.size.height * 0.035),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                        top: 14,
                        bottom: 13,
                      ),
                      child: CustomTextButton(
                          text: 'Back',
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => onBoardScreen1(),
                            ));
                          })),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => OnBoardScreen3(),
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
