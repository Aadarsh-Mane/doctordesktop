import 'package:doctordesktop/Doctor/AssignedLabScreen.dart';
import 'package:doctordesktop/Doctor/AssignedPatientScreen.dart';
import 'package:doctordesktop/LogoutScreen.dart';
import 'package:doctordesktop/authProvider/auth_provider.dart';
import 'package:doctordesktop/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter/material.dart';

class DoctorMainScreen extends StatefulWidget {
  @override
  _DoctorMainScreenState createState() => _DoctorMainScreenState();
}

class _DoctorMainScreenState extends State<DoctorMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DoctorHomeScreen(),
    );
  }
}

class DoctorHomeScreen extends ConsumerStatefulWidget {
  @override
  _DoctorHomeScreenState createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends ConsumerState<DoctorHomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(doctorProfileProvider.notifier).getDoctorProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final doctorProfile = ref.watch(doctorProfileProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        elevation: 10,
        toolbarHeight: 90,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              print("Settings button pressed");
            },
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Spandan's Doctor Portal,",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "“Your dedication saves lives, and your compassion inspires hope.”",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            // Doctor Profile Card with Animation and subtle gradient effect
            doctorProfile == null
                ? const Center(child: CircularProgressIndicator())
                : AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue[200]!, Colors.blue[600]!],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              AssetImage('assets/images/doctor14.png'),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome, Dr. ${doctorProfile.doctorName}",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Email: ${doctorProfile.email}",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
            const SizedBox(height: 10),

            // Navigation Buttons with improved hover effect and spacing
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 30,
              mainAxisSpacing: 30,
              childAspectRatio: 3.5, // Adjusted button size
              children: [
                _buildNavButton("Assigned Patients", Icons.people, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AssignedPatientsScreen()),
                  );
                }),
                _buildNavButton("Assigned Labs", Icons.local_hospital, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AssignedLabsScreen()),
                  );
                }),
                _buildNavButton("Logout", Icons.exit_to_app, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LogoutScreen()),
                  );
                }),
                _buildNavButton("Go Back Home", Icons.home, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                }),
                _buildNavButton("Go Back Home", Icons.home, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                }),
              ],
            ),

            const SizedBox(height: 20),

            // Animated Footer with fade-in effect
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.blue[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    "Powered by 20s Developers",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.developer_mode, color: Colors.white70),
                      const SizedBox(width: 8),
                      Text(
                        "20s Developers",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlueAccent[100],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom Navigation Button with Animation and hover effect
  Widget _buildNavButton(String label, IconData icon, VoidCallback onPressed) {
    bool isHovered = false; // Track the hover state

    return InkWell(
      onTap: onPressed,
      onHover: (isHoveredState) {
        setState(() {
          isHovered = isHoveredState; // Update hover state
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 18),
        decoration: BoxDecoration(
          color:
              isHovered ? Colors.cyan : Colors.black, // Change color on hover
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: Colors.white),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
