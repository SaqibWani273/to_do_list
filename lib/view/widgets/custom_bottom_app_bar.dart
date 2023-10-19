import 'package:flutter/material.dart';

import '../../constants/bottom_app_bar_constants.dart';
import '../../constants/image_constants.dart';
import '../../constants/theme/custom_theme.dart';
import '../../model/bottom_menu_model.dart';
import 'custom_image_view.dart';

class CustomBottomAppBar extends StatefulWidget {
  CustomBottomAppBar({this.onChanged});

  Function(BottomBarEnum)? onChanged;

  @override
  CustomBottomAppBarState createState() => CustomBottomAppBarState();
}

class CustomBottomAppBarState extends State<CustomBottomAppBar> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      color: appTheme.blue400,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            bottomMenuList.length,
            (index) {
              return InkWell(
                //to change current selected item
                onTap: () {
                  for (var element in bottomMenuList) {
                    element.isSelected = false;
                  }
                  bottomMenuList[index].isSelected = true;
                  widget.onChanged?.call(bottomMenuList[index].type);
                  setState(() {});
                },
                child: bottomMenuList[index].isSelected
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomImageView(
                            svgPath: bottomMenuList[index].activeIcon,
                            height: 24,
                            width: 24,
                            color: appTheme.whiteA700,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              bottomMenuList[index].title ?? "",
                              style: theme.textTheme.bodySmall!.copyWith(
                                color: appTheme.whiteA700.withOpacity(0.87),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomImageView(
                            svgPath: bottomMenuList[index].icon,
                            height: 24,
                            width: 24,
                            color: appTheme.whiteA700,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              bottomMenuList[index].title ?? "",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: appTheme.whiteA700.withOpacity(0.98),
                                  ),
                            ),
                          ),
                        ],
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}
