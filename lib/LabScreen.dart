import 'dart:io';
import 'package:dio/io.dart';
import 'package:doctordesktop/authProvider/auth_provider.dart';
import 'package:doctordesktop/constants/Url.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;

import 'dart:async';

import 'package:dio/dio.dart'; // Import dio for downloading
import 'package:flutter_pdfview/flutter_pdfview.dart'; // For showing PDFs

class LabPatientsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get the current state (labPatients)
    final labPatients = ref.watch(labPatientsProvider);

    // Watch loading state as well
    final isLoading = labPatients.isEmpty;

    // Trigger data fetch if it's empty (this ensures data is fetched only once)
    if (isLoading && ref.read(labPatientsProvider.notifier).state.isEmpty) {
      ref.read(labPatientsProvider.notifier).fetchLabPatients();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Lab Patients'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner
          : ListView.builder(
              itemCount: labPatients.length,
              itemBuilder: (context, index) {
                final labPatient = labPatients[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          labPatient.patient.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text('Age: ${labPatient.patient.age}'),
                        Text('Gender: ${labPatient.patient.gender}'),
                        Text('Contact: ${labPatient.patient.contact}'),
                        SizedBox(height: 8.0),
                        Text(
                          'Doctor: ${labPatient.doctor.doctorName}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text('Test: ${labPatient.labTestNameGivenByDoctor}'),
                        SizedBox(height: 8.0),
                        Text(
                          'Reports:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        ListView.builder(
                          itemCount: labPatient.reports.length,
                          shrinkWrap: true, // Important to avoid layout issues
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, reportIndex) {
                            final report = labPatient.reports[reportIndex];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(report.labTestName),
                              subtitle: Text('Type: ${report.labType}'),
                              trailing: IconButton(
                                icon: Icon(Icons.download),
                                onPressed: () async {
                                  final url = report.reportUrl;

                                  await _downloadFile(url, context);
                                },
                              ),
                            );
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.upload_file),
                            label: Text('Upload Report'),
                            onPressed: () {
                              // Navigate to the Upload Lab Report screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UploadLabReportScreen(
                                    admissionId: labPatient.admissionId,
                                    patientId: labPatient.patient.id,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  // Method to download file using Dio

  Future<void> _downloadFile(String url, BuildContext context) async {
    try {
      final dio = Dio();

      // Disable SSL certificate validation (use only in development/testing environments)
      if (Platform.isWindows) {
        (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
            (client) {
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) =>
                  true; // Ignore cert validation
          return client;
        };
      }

      // Convert Google Drive link to direct download link
      String directDownloadUrl = _getGoogleDriveDirectDownloadUrl(url);

      // Get the app's document directory
      final directory =
          Directory('${Platform.environment['USERPROFILE']}\\Desktop\\reports');
      if (!await directory.exists()) {
        await directory.create(
            recursive: true); // Create the folder if it doesn't exist
      }

      // Extract the file ID from the URL and generate a valid file name
      String fileName = _getFileNameFromUrl(url);

      final savePath =
          path.join(directory.path, fileName); // Safer path construction

      // Download the file
      await dio.download(directDownloadUrl, savePath);
      print('Download completed: $savePath');

      // Show PDF in the same screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFViewerScreen(pdfPath: savePath),
        ),
      );
    } catch (e) {
      print('Error downloading file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading file')),
      );
    }
  }

// Convert the Google Drive link to a direct download URL
  String _getGoogleDriveDirectDownloadUrl(String url) {
    final fileId = _extractFileIdFromUrl(url);
    return 'https://drive.google.com/uc?export=download&id=$fileId';
  }

// Extract file ID from the Google Drive URL
  String _extractFileIdFromUrl(String url) {
    final match = RegExp(r'\/d\/([^\/]+)\/').firstMatch(url);
    if (match != null) {
      return match.group(1)!;
    }
    throw Exception('Unable to extract file ID from URL');
  }

// Generate a valid file name based on the file ID or use a default name
  String _getFileNameFromUrl(String url) {
    final fileId = _extractFileIdFromUrl(url);
    return '$fileId.pdf'; // You can replace this with a more meaningful file name if available
  }
}

class PDFViewerScreen extends StatelessWidget {
  final String pdfPath;

  const PDFViewerScreen({required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PDF Viewer')),
      body: PDFView(
        filePath: pdfPath,
      ),
    );
  }
}

class UploadLabReportScreen extends StatefulWidget {
  final String admissionId;
  final String patientId;

  UploadLabReportScreen({required this.admissionId, required this.patientId});

  @override
  _UploadLabReportScreenState createState() => _UploadLabReportScreenState();
}

class _UploadLabReportScreenState extends State<UploadLabReportScreen> {
  File? _selectedFile;
  String? labTestName;
  String? labType;

  // Function to pick a PDF file
  Future<void> pickFile() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  // Function to upload the PDF
  Future<void> uploadReport() async {
    if (_selectedFile == null || labTestName == null || labType == null) {
      // Show error if any field is missing
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please fill in all fields and select a file')));
      return;
    }

    var request = http.MultipartRequest(
        'POST', Uri.parse('${VERCEL_URL}/labs/upload-lab-report'));
    request.fields['admissionId'] = widget.admissionId;
    request.fields['patientId'] = widget.patientId;
    request.fields['labTestName'] = labTestName!;
    request.fields['labType'] = labType!;

    // Attach the selected file
    request.files
        .add(await http.MultipartFile.fromPath('image', _selectedFile!.path));

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lab report uploaded successfully')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to upload report')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Lab Report')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Lab Test Name'),
              onChanged: (value) => labTestName = value,
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Lab Type'),
              onChanged: (value) => labType = value,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: pickFile,
              child: Text(_selectedFile == null
                  ? 'Pick PDF File'
                  : 'File Selected: ${_selectedFile!.path.split('/').last}'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadReport,
              child: Text('Upload Report'),
            ),
          ],
        ),
      ),
    );
  }
}
