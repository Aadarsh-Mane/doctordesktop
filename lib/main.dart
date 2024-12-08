import 'package:doctordesktop/screens/Admin/AdminAuthDialog.dart';
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
      designSize: Size(1920, 1080),
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
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
            color: Colors.white,
          ),
        ),
        bottom: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          controller: _tabController,
          tabs: [
            Tab(text: 'Home'),
            Tab(text: 'Screens'),
            Tab(text: 'Settings'),
          ],
        ),
      ),
      drawer: _buildDrawer(context),
      body: TabBarView(
        controller: _tabController,
        children: [
          _homeTab(),
          _screensTab(),
          _settingsTab(),
        ],
      ),
    );
  }

  // Drawer widget
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blueAccent),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person_add),
            title: Text('Register Doctor'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DoctorRegisterScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person_add_alt),
            title: Text('Register Nurse'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NurseRegisterScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person_add_alt_1),
            title: Text('Register Patient'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PatientAddScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Patient List'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PatientListScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.list_alt),
            title: Text('Doctor List'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DoctorListScreen()),
              );
            },
          ),
          // New Screens
          ListTile(
            leading: Icon(Icons.assignment_ind),
            title: Text('Assign Doctor'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AssignDoctorScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.assignment),
            title: Text('Patient Assignments'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PatientAssignmentScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Admin'),
            onTap: () {
              // Add functionality if needed
              showDialog(
                context: context,
                builder: (context) => AdminAuthDialog(),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {
              // Add functionality if needed
            },
          ),
        ],
      ),
    );
  }

  Widget _homeTab() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/span.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text(
              //   'Welcome to the Flutter Windows App',
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 32.sp,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              SizedBox(height: 180.h),
              Wrap(
                spacing: 100.w,
                runSpacing: 30.h,
                children: [
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
                    child: Text('Patient Register', style: _buttonTextStyle()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _screensTab() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/span.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
        child: Wrap(
          spacing: 30.w,
          runSpacing: 30.h,
          children: [
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
          ],
        ),
      ),
    );
  }

  Widget _settingsTab() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/sp.png'),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: Colors.blueAccent,
      elevation: 8,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      shadowColor: Colors.blueGrey.withOpacity(0.5),
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ).copyWith(
      side: MaterialStateProperty.all(
        BorderSide(color: Colors.blueAccent, width: 2),
      ),
    );
  }

  TextStyle _buttonTextStyle() {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
      color: Colors.white,
    );
  }
}
