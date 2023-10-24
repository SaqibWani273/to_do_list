import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:to_do_list/constants/bottom_bar_list.dart';

import '../widgets/app_bar/custom_app_bar.dart';
import 'home_screen.dart';

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
    //final mediaQueryData = MediaQuery.of(context);

    return SafeArea(
      child: Scaffold(
          appBar: CustomAppBar(
            height: 62,
            leadingWidth: 57,
            centerTitle: true,
          ),
          body: PageView(
            controller: _pageController,
            children: [
              const CalendarScreen(),
              const HomeScreen(),
              const FocusScreen()
            ],
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
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeIn);
            },
          )
          //  CustomBottomAppBar(
          //   onChanged: (BottomBarEnum type) {},

          ),
    );
  }
}

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
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
      child: const Center(
        child: Text('Focus'),
      ),
    );
  }
}
