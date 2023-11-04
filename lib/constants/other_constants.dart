const String usedDevice = 'usedDevice';
const String userHasNoData = 'userHasNoData';

enum TaskEnum {
  Edit,
  Delelte,
  ToggleMark,
}

final List<TaskEnum> popMenuItemList = [
  TaskEnum.Delelte,
  TaskEnum.Edit,
  TaskEnum.ToggleMark
];

enum ListTasksBy {
  all,
  date,
  lowPriority,
  mediumPriority,
  highPriority,
  completed,
  personalCategory,
  workCategory,
  studyCategory,
  otherCategory,
}
