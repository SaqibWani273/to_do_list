import 'dart:async';
import 'dart:developer';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/constants/bottom_bar_list.dart';
import 'package:to_do_list/model/user_model.dart';
import 'package:to_do_list/view_model/user_provider.dart';

import '../../view_model/task_provider.dart';
import '../widgets/app_bar/custom_app_bar.dart';
import 'home_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  DashboardScreen({Key? key})
      : super(
          key: key,
        );

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final _pageController = PageController(initialPage: 1);
  final _notchController = NotchBottomBarController(index: 1);
  UserModel? userProfile;
  late StreamSubscription<ConnectivityResult> connectivityStream;
  late ConnectivityResult _connectivityResult;
  @override
  void initState() {
    super.initState();
    //to load all kinds of user related data
    loadUserData();
    //to check  internet for the first time
    checkInternet();
    //listen to internet connectivity changes
    listenInternetConnectivity();
  }

  Future<void> loadUserData() async {
    log('load user data called..');
    // await ref.read(taskProvider.notifier).setTasksList();
    // await ref.read(userProvider.notifier).setUserProfile();
  }

  checkInternet() async {
    _connectivityResult = await Connectivity().checkConnectivity();
    manageIneternetConnectivity(_connectivityResult);
  }

  listenInternetConnectivity() {
    connectivityStream = Connectivity()
        .onConnectivityChanged
        .listen(manageIneternetConnectivity);
  }

  manageIneternetConnectivity(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      log('no internet');
    } else if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      log('connected to internet');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _notchController.dispose();
    connectivityStream.cancel();
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
              log('value = $value');
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
