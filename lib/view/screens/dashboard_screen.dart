import 'dart:async';
// ignore: unused_import
import 'dart:developer';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:to_do_list/constants/bottom_bar_list.dart';
import 'package:to_do_list/model/user_model.dart';
import 'package:to_do_list/view_model/user_provider.dart';

import '../../model/task.dart';
import '../../view_model/task_provider.dart';
import '../widgets/app_bar/custom_app_bar.dart';
import '../widgets/place_holder_widget.dart';
import 'calendar_screen.dart';
import 'home_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final _pageController = PageController(initialPage: 0);
  final _notchController = NotchBottomBarController(index: 0);
  UserModel? userProfile;
  var loadingData = true;
  late List<Task>? tasksList;

  @override
  void initState() {
    super.initState();
    //to load all kinds of user related data
    loadUserData();
  }

  Future<void> loadUserData() async {
    await ref.read(taskProvider.notifier).setTasksList();
    await ref.read(userProvider.notifier).setUserProfile();
    tasksList = ref.read(taskProvider);
    //to stop showing shimmer effect in ui
    setState(() {
      loadingData = false;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _notchController.dispose();
    // connectivityStream.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final mediaQueryData = MediaQuery.of(context);
    tasksList = ref.watch(taskProvider);
    if (loadingData) {
      return Scaffold(
        body: Shimmer.fromColors(
          baseColor:
              Theme.of(context).colorScheme.onBackground.withOpacity(0.05),
          highlightColor: Theme.of(context).scaffoldBackgroundColor,
          child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context, index) => const PlaceHolderWidget(),
          ),
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
          appBar: const CustomAppBar(
            height: 62,
            leadingWidth: 57,
            centerTitle: true,
          ),
          body: PageView(
            controller: _pageController,
            children: [
              HomeScreen(tasksList: tasksList),
              CalendarScreen(tasksList: tasksList),
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
          )),
    );
  }
}
