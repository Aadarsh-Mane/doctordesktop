import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:doctordesktop/constants/Url.dart';

// Patient Add Screen UI Enhancements
class PatientAddScreen extends StatefulWidget {
  @override
  _PatientAddScreenState createState() => _PatientAddScreenState();
}

class _PatientAddScreenState extends State<PatientAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _reasonForAdmissionController =
      TextEditingController();
  final TextEditingController _symptomsController = TextEditingController();
  final TextEditingController _initialDiagnosisController =
      TextEditingController();

  bool _isLoading = false;

  Future<void> _addPatient() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final response = await http.post(
        Uri.parse('${BASE_URL}/reception/addPatient'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _nameController.text,
          'age': _ageController.text,
          'gender': _genderController.text,
          'contact': _contactController.text,
          'address': _addressController.text,
          'reasonForAdmission': _reasonForAdmissionController.text,
          'symptoms': _symptomsController.text,
          'initialDiagnosis': _initialDiagnosisController.text,
        }),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final String patientId = data['patientDetails']['patientId'];
        final String admissionId =
            data['patientDetails']['admissionRecords'].last['_id'];

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Patient added successfully!'),
          backgroundColor: Colors.green,
        ));

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorSelectionScreen(
                patientId: patientId, admissionId: admissionId),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to add patient. Please try again.'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Patient'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildFormField(_nameController, 'Name'),
              _buildFormField(_ageController, 'Age',
                  keyboardType: TextInputType.number),
              _buildFormField(_genderController, 'Gender'),
              _buildFormField(_contactController, 'Contact',
                  keyboardType: TextInputType.phone),
              _buildFormField(_addressController, 'Address'),
              _buildFormField(
                  _reasonForAdmissionController, 'Reason for Admission'),
              _buildFormField(_symptomsController, 'Symptoms'),
              _buildFormField(_initialDiagnosisController, 'Initial Diagnosis'),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _addPatient,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blueAccent),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        )),
                      ),
                      child: Text('Submit', style: TextStyle(fontSize: 18)),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField(TextEditingController controller, String labelText,
      {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: labelText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            prefixIcon: Icon(Icons.text_fields),
          ),
          validator: (value) =>
              value!.isEmpty ? 'Please enter $labelText' : null,
        ),
      ),
    );
  }
}

// Doctor Selection Screen UI Enhancements
class DoctorSelectionScreen extends StatefulWidget {
  final String patientId;
  final String admissionId;

  DoctorSelectionScreen({required this.patientId, required this.admissionId});

  @override
  _DoctorSelectionScreenState createState() => _DoctorSelectionScreenState();
}

class _DoctorSelectionScreenState extends State<DoctorSelectionScreen> {
  List<Map<String, dynamic>> _doctors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  Future<void> _fetchDoctors() async {
    final response =
        await http.get(Uri.parse('${BASE_URL}/reception/listDoctors'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _doctors = (data['doctors'] as List).map((d) {
          return {
            'id': d['_id'],
            'name': d['doctorName'],
            'email': d['email'],
            'usertype': d['usertype']
          };
        }).toList();
        _isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load doctors.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _assignDoctor(String doctorId) async {
    final response = await http.post(
      Uri.parse('${BASE_URL}/reception/assign-Doctor'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'patientId': widget.patientId,
        'doctorId': doctorId,
        'admissionId': widget.admissionId,
        'isReadmission': false,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Doctor assigned successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to assign doctor.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Doctor'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _doctors.length,
              itemBuilder: (context, index) {
                final doctor = _doctors[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.medical_services, color: Colors.white),
                    ),
                    title: Text(doctor['name'],
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        'Email: ${doctor['email']}\nType: ${doctor['usertype']}'),
                    onTap: () => _assignDoctor(doctor['id']),
                  ),
                );
              },
            ),
    );
  }
}
