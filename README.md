# Timer for Facebbok

Let me explain the MVC pattern in this project:
<br>
<h2>Model:</h2>
TimerModel: Handles timer state and logic <br>
AppStateModel: Manages app state persistence <br>
ReportModel: Handles usage statistics <br>
WebContentModel: Manages web content states <br>
ThemeModel: Handles app theming <br>
<br>
<h2>View:</h2>
<br>
TimerView: Displays timer UI <br>
SurfingContainerView: Main container view <br>
NavigationView: Navigation UI <br>
TimerPickerView: Timer selection UI <br>
WebContentView: Displays web content <br>
<br>
<h2>Controller:</h2>
<br>
TimerController: Mediates between TimerModel and TimerView <br>
WebContentController: Manages web content display <br>
SurfingViewController: Main view controller coordinating all components <br>
ReportViewController: Handles report display <br>
<br>
<h2>Flow Example:</h2>
<br>
1. User starts timer: <br>
View: User interacts with TimerPickerView <br>
Controller: TimerController processes the input <br>
Model: TimerModel updates timer state <br>
Controller: Updates TimerView with new state <br>
2. App state changes: <br>
Controller: Detects state change <br>
Model: AppStateModel saves state <br>
Controller: Updates relevant views <br>
