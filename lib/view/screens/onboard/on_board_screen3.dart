import 'package:flutter/material.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:to_do_list/constants/image_constants.dart';
import 'package:to_do_list/view/screens/onboard/on_board_screen2.dart';
import 'package:to_do_list/view/widgets/custom_text_button.dart';

import '../../../constants/theme/custom_theme.dart';
import '../../../main.dart';
import '../../widgets/custom_image_view.dart';

class OnBoardScreen3 extends StatelessWidget {
  const OnBoardScreen3({Key? key})
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
                        svgPath: ImageConstants.onBoardImg3,
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
                  activeIndex: 2,
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
                "Organize your tasks",
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
                  "You can organize your daily tasks by adding your tasks into separate categories",
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
                              builder: (context) => OnBoardScreen2(),
                            ));
                          })),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => MyApp(isNewUser: false),
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
