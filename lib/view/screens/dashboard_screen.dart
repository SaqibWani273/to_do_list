import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/constants/bottom_bar_list.dart';
import 'package:to_do_list/view/screens/add_task_screen.dart';

import '../../constants/image_constants.dart';
import '../widgets/app_bar/custom_app_bar.dart';
import '../widgets/custom_image_view.dart';

class DashboardScreen extends StatefulWidget {
  DashboardScreen({Key? key})
      : super(
          key: key,
        );

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _pageController = PageController(initialPage: 1);
  final _notchController = NotchBottomBarController(index: 1);
  @override
  void dispose() {
    _pageController.dispose();
    _notchController.dispose();
    super.dispose();
  }

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
          body: PageView(
            controller: _pageController,
            children: [CalendarScreen(), HomeScreen1(), FocusScreen()],
          ),
          extendBody:
              true, //This property is often useful when the [bottomNavigationBar]
          //has a non-rectangular shape, like [CircularNotchedRectangle],
          bottomNavigationBar: AnimatedNotchBottomBar(
            durationInMilliSeconds: 400,
            notchBottomBarController: _notchController,
            bottomBarWidth: 300,
            removeMargins: true,
            showLabel: true,
            bottomBarItems: bottomBarList
                .map((item) => BottomBarItem(
                      inActiveItem: Icon(
                        item.notActiveIcon,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      activeItem: Icon(
                        item.activeIcon,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      itemLabel: item.label,
                    ))
                .toList(),
            onTap: (value) {
              _pageController.animateToPage(value,
                  duration: Duration(milliseconds: 400), curve: Curves.easeIn);
            },
          )
          //  CustomBottomAppBar(
          //   onChanged: (BottomBarEnum type) {},

          ),
    );
  }
}

class HomeScreen1 extends StatelessWidget {
  const HomeScreen1({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      //   alignment: Alignment.bottomLeft,
      children: [
        Container(
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
          //    floatingActionButtonLocation: FloatingActionButtonLocation,
        ),
        Positioned(
            bottom: 100,
            right: 20,
            height: 65,
            width: 65,
            child: FloatingActionButton(
              elevation: 20,
              child: Icon(
                Icons.add,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTaskScreen(
                        onSave: (newTask) {
                          print(newTask.toString());
                        },
                      ),
                    ));
              },
            ))
      ],
    );
  }
}

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('CAlendar'),
      ),
    );
  }
}

class FocusScreen extends StatelessWidget {
  const FocusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('Focus'),
      ),
    );
  }
}
