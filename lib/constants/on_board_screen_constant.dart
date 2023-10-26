// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:to_do_list/constants/image_constants.dart';

class OnBoardScreen {
  final String text1;
  final String text2;
  final String svgPath;
  OnBoardScreen({
    required this.text1,
    required this.text2,
    required this.svgPath,
  });
}

final List<OnBoardScreen> onBoardScreens = [
  OnBoardScreen(
    text1: 'Manage Your Tasks',
    text2: "You can easily manage all of your tasks in SaQib's ToDo for free",
    svgPath: ImageConstant.onBoardImg1,
  ),
  OnBoardScreen(
    text1: "Create Daily Routine",
    text2:
        "In Saqib's Tod0 you can create your personalized routine to stay productive",
    svgPath: ImageConstant.onBoardImg2,
  ),
  OnBoardScreen(
    text1: "Organize your tasks",
    text2:
        "You can organize your daily tasks by adding your tasks into separate categories",
    svgPath: ImageConstant.onBoardImg3,
  ),
];
