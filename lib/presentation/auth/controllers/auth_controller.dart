// lib/presentation/auth/controllers/auth_controller.dart (enhanced)
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ai_task_management_app/data/datasources/local/auth_local_data_source.dart';

class AuthenticationCont extends GetxController {
  final AuthLocalDataSource authLocalDataSource;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxBool isLoggedIn = false.obs;

  AuthenticationCont({required this.authLocalDataSource});

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    isLoggedIn.value = await authLocalDataSource.isLoggedIn();
  }

  Future<bool> login(String email, String password) async {
    try {
      isLoading.value = true;
      error.value = '';

      // Simulate API call with validation
      await Future.delayed(const Duration(seconds: 2));

      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email and password are required');
      }

      if (!GetUtils.isEmail(email)) {
        throw Exception('Please enter a valid email');
      }

      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }

      // Mock successful login
      const mockToken = 'mock_jwt_token_12345';
      const mockUserId = 'user_123';

      // Save auth data to shared preferences
      await authLocalDataSource.saveAuthData(mockToken, mockUserId,email);
      isLoggedIn.value = true;

      return true;
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Login Failed',
        error.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> register(String email, String password, String confirmPassword) async {
    try {
      isLoading.value = true;
      error.value = '';

      // Simulate API call with validation
      await Future.delayed(const Duration(seconds: 2));

      if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
        throw Exception('All fields are required');
      }

      if (!GetUtils.isEmail(email)) {
        throw Exception('Please enter a valid email');
      }

      if (password.length < 6) {
        throw Exception('Password must be at least 6 characters');
      }

      if (password != confirmPassword) {
        throw Exception('Passwords do not match');
      }

      // Mock successful registration
      const mockToken = 'mock_jwt_token_12345';
      const mockUserId = 'user_123';

      // Save auth data to shared preferences
      await authLocalDataSource.saveAuthData(mockToken, mockUserId,email);
      isLoggedIn.value = true;

      return true;
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Registration Failed',
        error.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await authLocalDataSource.clearAuthData();
    isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }
}