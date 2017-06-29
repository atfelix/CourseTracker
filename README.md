# ![](https://github.com/atfelix/CourseTracker/blob/master/CourseTracker/CT-Icon/ios/AppIcon.appiconset/Icon-App-20x20%403x.png "Course Tracker")CourseTracker 

iOS application for students in post secondary institutions (College/ University) that helps students by increasing their productivity. Students plan out their courses and athletics then find where it is located.

### Demo Images

![Home](https://github.com/atfelix/CourseTracker/blob/master/Demo/Home.png "Home")
![Calendar](https://github.com/atfelix/CourseTracker/blob/master/Demo/Calendar.png "Calendar")
![Courses Manager](https://github.com/atfelix/CourseTracker/blob/master/Demo/Courses.png "Courses")
![Athletics Manager](https://github.com/atfelix/CourseTracker/blob/master/Demo/Athletics.png "Athletics")

## User Case  

The user will add the courses they are currently taking. The courses will then be automatically displayed in a calendar with details about the course. The user can also add real-time athletic events provided by the university at a certain date. If the user double taps on a date on the calendar they will be provided with a map that displays where each class is and provide a path with the distance for each class of the day.

## Future Goals 
- Incorporate more University API’s: Waterloo, UFT, UBC etc. 
- Better mapping, Google Maps.
- Weekly calendar for better viewing or incorporate Apples build in calendar. 

## Technologies Used
-[University of Toronto API](https://cobalt.qas.im/) 

Access to real-time updated Univeristy of Toronto API.

-[Realm](https://realm.io/) 

Used to house the Data from API calls and for its cross platform accessibilty. 

-[Alamofire](https://github.com/Alamofire/Alamofire) 

Easy to use network-calls.

-[JTAppleCalendar](https://github.com/patchthecode/JTAppleCalendar)

Fully customizable calendar.

-[Carthage](https://github.com/Carthage/Carthage)

Used as our dependancy manager.
