import 'package:flutter/material.dart';
import 'package:to_do_list/model/bottom_item_model.dart';

final List<BottomItemModel> bottomBarList = [
  BottomItemModel(
    activeIcon: Icons.home,
    label: 'Home',
    notActiveIcon: Icons.home_outlined,
  ),
  BottomItemModel(
    activeIcon: Icons.calendar_month,
    label: 'Calendar',
    notActiveIcon: Icons.calendar_month_outlined,
  ),
];
