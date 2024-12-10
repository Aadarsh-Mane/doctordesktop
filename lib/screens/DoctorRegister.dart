import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:doctordesktop/constants/Url.dart';

class DoctorRegisterScreen extends StatefulWidget {
  @override
  _DoctorRegisterScreenState createState() => _DoctorRegisterScreenState();
}

class _DoctorRegisterScreenState extends State<DoctorRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String userType = '';
  String doctorName = '';

  Future<void> submitData() async {
    final url =
        '${BASE_URL}/reception/addDoctor'; // Replace with your backend URL
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'usertype': userType,
          'doctorName': doctorName,
        }),
      );

      if (response.statusCode == 201) {
        // Handle success
        print('Data submitted successfully: ${response.body}');
        _showSnackbar(
            'Data submitted successfully!'); // Show Snackbar on success
        // Optionally navigate back or clear the form
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
        _showSnackbar(
            'Failed to submit data. Please try again.'); // Show Snackbar on error
      }
    } catch (error) {
      print('Error occurred: $error');
      _showSnackbar(
          'Error occurred. Please check your connection.'); // Show Snackbar on exception
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2), // Adjust duration as needed
        behavior:
            SnackBarBehavior.floating, // Optional: makes the snackbar floating
        backgroundColor: Colors.green, // Background color for success
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter User Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              SizedBox(height: 20.h),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              SizedBox(height: 20.h),
              TextFormField(
                decoration: InputDecoration(labelText: 'User Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the user type';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    userType = value;
                  });
                },
              ),
              SizedBox(height: 20.h),
              TextFormField(
                decoration: InputDecoration(labelText: 'Doctor Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the doctor\'s name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    doctorName = value;
                  });
                },
              ),
              SizedBox(height: 30.h),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    submitData(); // Call the API function
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
