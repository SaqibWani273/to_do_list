import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/constants/on_board_screen_constant.dart';
import 'package:to_do_list/constants/other_constants.dart';
import 'package:to_do_list/view/widgets/on_board_widget.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({Key? key})
      : super(
          key: key,
        );

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  final _pageController = PageController(initialPage: 0);
  Future<void> setData() async {
    final sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool(usedDevice, true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    setData();

    return SafeArea(
        child: Scaffold(
      body: Container(
        height: mediaQueryData.size.height,
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 10,
        ),
        child: PageView(
            controller: _pageController,
            children: onBoardScreens
                .asMap()
                .map((index, screenData) => MapEntry(
                    index,
                    OnBoardWidget(
                      mediaQueryData: mediaQueryData,
                      text1: screenData.text1,
                      text2: screenData.text2,
                      svgPath: screenData.svgPath,
                      pageController: _pageController,
                      index: index,
                    )))
                .values
                .toList()),
      ),
    ));
  }
}
