import 'package:shared_preferences/shared_preferences.dart';

const String userHasNoTasksData = 'userHasNoTasksData';
const String userHasNoProfileData = 'userHasNoProfileData';

const String usedDevice = 'usedDevice';

late SharedPreferences sharedPref;

class SharedRef {
  Future<bool> get noTasksData async {
    sharedPref = await SharedPreferences.getInstance();
    if (sharedPref.getBool(userHasNoTasksData) != null &&
        sharedPref.getBool(userHasNoTasksData) == true) {
      //=> user has no data
      return true;
    }
    //user has data
    return false;
  }

  void setNoTasksData() async {
    sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool(userHasNoTasksData, true);
  }

  Future<bool> get noUserData async {
    sharedPref = await SharedPreferences.getInstance();
    if (sharedPref.getBool(userHasNoProfileData) != null &&
        sharedPref.getBool(userHasNoProfileData) == true) {
      //=> user has no data
      return true;
    }
    //user has data
    return false;
  }

  void setNoProfileData() async {
    sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool(userHasNoProfileData, true);
  }

  Future<void> recognizeDevice() async {
    sharedPref = await SharedPreferences.getInstance();
    sharedPref.setBool(usedDevice, true);
  }
}
