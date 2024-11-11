import 'package:doctordesktop/screens/AssignDoctor.dart';
import 'package:doctordesktop/screens/Doctor/fetchDoctor.dart';
import 'package:doctordesktop/screens/DoctorRegister.dart';
import 'package:doctordesktop/screens/ListPatienAssignToDoctor.dart';
import 'package:doctordesktop/screens/NurseRegister.dart';
import 'package:doctordesktop/screens/Patient/fetchPatient.dart';
import 'package:doctordesktop/screens/PatientRegister.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1920, 1080), // Set screen size for responsive scaling
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Windows App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: GoogleFonts.poppinsTextTheme(),
          ),
          home: HomeScreen(),
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController; // Tab controller for TabBar

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Number of tabs
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Spandan Hospital',
          style: TextStyle(
            color: Colors.white, // Text color for the AppBar title
          ),
        ),
        bottom: TabBar(
          labelColor: Colors.white, // Color for the selected tab text
          unselectedLabelColor: Colors.grey, // Color for unselected tab tex
          controller: _tabController,
          tabs: [
            Tab(text: 'Home'),
            Tab(text: 'Screens'),
            Tab(text: 'Settings'), // Example tab
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _homeTab(), // Home tab content
          _screensTab(), // Screens tab content
          _settingsTab(), // Settings tab content
        ],
      ),
    );
  }

  // Home tab content
  Widget _homeTab() {
    return Stack(
      children: [
        // Background Image
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/span.png'), // Background image
              fit: BoxFit.fill,
            ),
          ),
        ),
        // Content
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to the Flutter Windows App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30.h),
              // Individual Buttons
              Wrap(
                spacing: 100.w,
                runSpacing: 30.h,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 90, right: 90),
                  ),
                  SizedBox(
                    width: 220,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DoctorRegisterScreen()),
                      );
                    },
                    style: _buttonStyle(),
                    child: Text('Register Doctor', style: _buttonTextStyle()),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NurseRegisterScreen()),
                      );
                    },
                    style: _buttonStyle(),
                    child: Text('Nurse Register', style: _buttonTextStyle()),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PatientAddScreen()),
                      );
                    },
                    style: _buttonStyle(),
                    child: Text('Patient  Register', style: _buttonTextStyle()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Screens tab content with buttons
  Widget _screensTab() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/span.png'), // Background image
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
        child: Wrap(
          spacing: 30.w,
          runSpacing: 30.h,
          children: [
            Container(
              padding: EdgeInsets.only(top: 90, right: 90),
            ),
            SizedBox(
              width: 250,
            ),
            // Stylish Buttons with enhanced design
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PatientListScreen()),
                );
              },
              style: _buttonStyle(),
              child: Text('Get Patient', style: _buttonTextStyle()),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DoctorListScreen()),
                );
              },
              style: _buttonStyle(),
              child: Text('Get Doctor', style: _buttonTextStyle()),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AssignDoctorScreen()),
                );
              },
              style: _buttonStyle(),
              child: Text('Assign Doctor', style: _buttonTextStyle()),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PatientAssignmentScreen()),
                );
              },
              style: _buttonStyle(),
              child: Text('Doctor Patient', style: _buttonTextStyle()),
            ),
            // Add more buttons as needed for additional screens
          ],
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.blueAccent, // Text color
      elevation: 8, // Shadow effect
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), // Rounded corners
      ),
      shadowColor: Colors.blueGrey.withOpacity(0.5), // Shadow color
      textStyle:
          TextStyle(fontSize: 16, fontWeight: FontWeight.w600), // Text style
    ).copyWith(
      side: MaterialStateProperty.all(
        BorderSide(color: Colors.blueAccent, width: 2), // Border style
      ),
    );
  }

  TextStyle _buttonTextStyle() {
    return TextStyle(
      fontSize: 18, // Adjust the font size for better visibility
      fontWeight: FontWeight.bold, // Bold font weight for emphasis
      letterSpacing: 1.2, // Slight letter spacing for readability
      color: Colors.white, // White text color
    );
  }

  // Example Settings tab content
  Widget _settingsTab() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/sp.png'), // Background image
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
          // child: Text(
          //   style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
          // ),
          ),
    );
  }

  // Button style for reuse
  // ButtonStyle _buttonStyle1() {
  //   return ElevatedButton.styleFrom(
  //     padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 45.h),
  //     backgroundColor: Colors.black.withOpacity(0.8),
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  //     shadowColor: Colors.black45,
  //     elevation: 8,
  //   );
  // }

  // Text style for button labels
}

// Sample screens for each button
class Screen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _basicScreen('Screen 3');
  }
}

class Screen4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _basicScreen('Screen 4');
  }
}

class Screen5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _basicScreen('Screen 5');
  }
}

class Screen6 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _basicScreen('Screen 6');
  }
}

// Basic screen widget for each screen
Widget _basicScreen(String title) {
  return Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(
      child: Text(
        'This is $title',
        style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
