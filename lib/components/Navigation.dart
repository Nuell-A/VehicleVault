/*
Navigation menu for bottom navigation bar. 
*/
enum TabItem {History, Vehicle, Schedule, }

class TabItemData {
  final String title;

  TabItemData({required this.title});
}

final Map<TabItem, TabItemData> tabItems = {
  TabItem.History: TabItemData(title: "History"),
  TabItem.Vehicle: TabItemData(title: "Vehicle"),
  TabItem.Schedule: TabItemData(title: "Schedule")
};