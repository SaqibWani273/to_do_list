import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../constants/theme/custom_theme.dart';
import '../../view_model/my_app.dart';
import 'custom_image_view.dart';
import 'custom_text_button.dart';

class OnBoardWidget extends StatelessWidget {
  const OnBoardWidget({
    super.key,
    required this.mediaQueryData,
    required this.text1,
    required this.text2,
    required this.svgPath,
    required this.index,
    required this.pageController,
  });

  final MediaQueryData mediaQueryData;
  final String text1;
  final String text2;
  final String svgPath;
  final PageController pageController;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    child: CustomTextButton(
                      text: 'Skip',
                      onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AuthStreamHandler(),
                          )),
                    )),
                CustomImageView(
                  svgPath: svgPath,
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
            activeIndex: index,
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
          text1,
          style: theme.textTheme.headlineLarge,
        ),
        Container(
          width: 273,
          margin: const EdgeInsets.only(
            left: 27,
            top: 40,
            right: 26,
          ),
          child: Text(
            text2,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge!.copyWith(
              height: 1.50,
            ),
          ),
        ),
        const Spacer(),
        SizedBox(height: mediaQueryData.size.height * 0.035),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
                padding: const EdgeInsets.only(
                  top: 14,
                  bottom: 13,
                ),
                child: CustomTextButton(
                    text: 'Back',
                    onPressed: () {
                      pageController.animateToPage(index == 0 ? 0 : index - 1,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeIn);
                    })),
            ElevatedButton(
              onPressed: () {
                index == 2
                    ? Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AuthStreamHandler(),
                      ))
                    : pageController.animateToPage(index + 1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeIn);
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ],
    );
  }
}
