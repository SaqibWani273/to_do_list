import 'package:flutter/material.dart';

class DeviceData {
  // Private fields
  BuildContext context;
  double? _width;
  double? _height;
  double? _paddingTop;
  double? _paddingBottom;
  double? _toolbarHeight;

  // Constructor
  DeviceData({required this.context}) {
    // _width = 0.0;
    // _height = 0.0;
    // _paddingTop = 0.0;
    // _paddingBottom = 0.0;
    // _toolbarHeight = 0.0;
  }

  double? get width => _width;

  double? get height => _height;

  double? get paddingTop => _paddingTop;

  double? get paddingBottom => _paddingBottom;

  double? get toolbarHeight => _toolbarHeight;

  // Method to set all of the fields
  void setAllFields() {
    Size size = MediaQuery.of(context).size;
    _width = size.width;
    _height = size.height;
    _paddingTop = MediaQuery.of(context).viewPadding.top;
    _paddingBottom = MediaQuery.of(context).viewPadding.bottom;
    _toolbarHeight = kToolbarHeight;
  }
}
