import 'package:doctordesktop/authRepository/auth_repository.dart';
import 'package:doctordesktop/model/getDoctorProfile.dart';
import 'package:doctordesktop/model/getLabPatient.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AssignedLabsNotifier extends StateNotifier<List<AssignedLab>> {
  final AuthRepository authRepository;

  AssignedLabsNotifier(this.authRepository) : super([]);

  // Fetch the assigned labs from the API
  Future<void> fetchAssignedLabs() async {
    try {
      final labs = await authRepository.getAssignedLabs();
      state = labs; // Update the state with fetched data
    } catch (e) {
      throw Exception('Failed to fetch assigned labs: $e');
    }
  }
}

class DoctorProfileNotifier extends StateNotifier<DoctorProfile?> {
  final AuthRepository authRepository;

  DoctorProfileNotifier(this.authRepository) : super(null);

  // Fetch the doctor profile from the API
  Future<void> getDoctorProfile() async {
    print('Fetching doctor profile...');

    try {
      final doctorProfile = await authRepository.fetchDoctorProfile();
      print('Doctor profile fetched successfully: $doctorProfile');

      state = doctorProfile; // Update the state with fetched data
    } catch (e) {
      throw Exception('Failed to fetch doctor profile: $e');
    }
  }
}
