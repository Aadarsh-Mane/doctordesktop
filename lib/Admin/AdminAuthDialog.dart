import 'package:doctordesktop/screens/DoctorRegister.dart';
import 'package:doctordesktop/screens/NurseRegister.dart';
import 'package:flutter/material.dart';

class AdminAuthDialog extends StatefulWidget {
  @override
  _AdminAuthDialogState createState() => _AdminAuthDialogState();
}

class _AdminAuthDialogState extends State<AdminAuthDialog> {
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String correctUserId = "123";
  final String correctPassword = "123";

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _authenticate(BuildContext context) {
    String userId = _userIdController.text;
    String password = _passwordController.text;

    if (userId == correctUserId && password == correctPassword) {
      Navigator.pop(context); // Close the dialog box
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DesktopButtonScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid User ID or Password'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Admin Login'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _userIdController,
            decoration: InputDecoration(labelText: 'User ID'),
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _authenticate(context);
          },
          child: Text('Login'),
        ),
      ],
    );
  }
}

class DesktopButtonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
        title: Text('Admin Panel'),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/ok.png'), // Replace with your background image asset
            fit: BoxFit.cover,
            // colorFilter: ColorFilter.mode(
            //   Colors.black
            //       .withOpacity(0.1), // Overlay for better text visibility
            //   BlendMode.darken,
            // ),
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Hospital Logo
              // Container(
              //   width: 120,
              //   height: 120,
              //   decoration: BoxDecoration(
              //     shape: BoxShape.circle,
              //     color: Colors.white,
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.black26,
              //         blurRadius: 10,
              //         offset: Offset(0, 4),
              //       ),
              //     ],
              //     // image: DecorationImage(
              //     //   image: AssetImage(
              //     //       'assets/images/spanddd.jpeg'), // Replace with your logo asset
              //     //   fit: BoxFit.cover,
              //     // ),
              //   ),
              // ),
              SizedBox(height: 40),
              // Horizontal Buttons
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildDesktopButton('Register Doctor', () {
                      _navigateTo(context, DoctorRegisterScreen());
                    }),
                    SizedBox(width: 20),
                    _buildDesktopButton('Register Nurse', () {
                      _navigateTo(context, NurseRegisterScreen());
                    }),
                    // SizedBox(width: 20),
                    // _buildDesktopButton('B', () {
                    //   _navigateTo(context, ThirdScreen());
                    // }),
                    // SizedBox(width: 20),
                    // _buildDesktopButton('Button 4', () {
                    //   _navigateTo(context, FourthScreen());
                    // }),
                    // SizedBox(width: 20),
                    // _buildDesktopButton('Button 5', () {
                    //   _navigateTo(context, FifthScreen());
                    // }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
        shadowColor: Colors.white,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}

Widget _buildDesktopButton(String label, VoidCallback onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(vertical: 15),
      backgroundColor: Colors.teal.shade600,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 5,
      shadowColor: Colors.black45,
    ),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}

void _navigateTo(BuildContext context, Widget screen) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}

// Dummy Screens for Navigation

class DesktopButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  DesktopButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          textStyle: TextStyle(fontSize: 18),
        ),
        child: Text(label),
      ),
    );
  }
}

// Individual Screens
class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _DesktopScreenTemplate(
        title: 'First Screen', message: 'Welcome to the First Screen!');
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _DesktopScreenTemplate(
        title: 'Second Screen', message: 'Welcome to the Second Screen!');
  }
}

class ThirdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _DesktopScreenTemplate(
        title: 'Third Screen', message: 'Welcome to the Third Screen!');
  }
}

class FourthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _DesktopScreenTemplate(
        title: 'Fourth Screen', message: 'Welcome to the Fourth Screen!');
  }
}

class FifthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _DesktopScreenTemplate(
        title: 'Fifth Screen', message: 'Welcome to the Fifth Screen!');
  }
}

class _DesktopScreenTemplate extends StatelessWidget {
  final String title;
  final String message;

  _DesktopScreenTemplate({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          message,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
