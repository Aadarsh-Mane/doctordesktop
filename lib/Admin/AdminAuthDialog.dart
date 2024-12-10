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
        title: Text('Desktop Button Screen'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 400, // Fixed width for desktop layout
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DesktopButton(
                label: 'Button 1',
                onPressed: () {
                  _navigateTo(context, FirstScreen());
                },
              ),
              SizedBox(height: 20),
              DesktopButton(
                label: 'Button 2',
                onPressed: () {
                  _navigateTo(context, SecondScreen());
                },
              ),
              SizedBox(height: 20),
              DesktopButton(
                label: 'Button 3',
                onPressed: () {
                  _navigateTo(context, ThirdScreen());
                },
              ),
              SizedBox(height: 20),
              DesktopButton(
                label: 'Button 4',
                onPressed: () {
                  _navigateTo(context, FourthScreen());
                },
              ),
              SizedBox(height: 20),
              DesktopButton(
                label: 'Button 5',
                onPressed: () {
                  _navigateTo(context, FifthScreen());
                },
              ),
            ],
          ),
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
