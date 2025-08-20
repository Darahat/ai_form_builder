/// Home Page State
class HomeState {
  ///variable for bottom navigation tab position
  final int currentTabIndex;

  /// Home State Constructor
  const HomeState({this.currentTabIndex = 0});

  /// Copy HomeState instance for update
  HomeState copyWith({int? currentTabIndex}) {
    return HomeState(currentTabIndex: currentTabIndex ?? this.currentTabIndex);
  }
}
