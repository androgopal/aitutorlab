import 'package:aitutorlab/session/SessionManager.dart';
import 'package:aitutorlab/ui/home/HomeScreen.dart';
import 'package:aitutorlab/ui/login/SignUpPage.dart';
import 'package:aitutorlab/ui/login/VerifyOtpScreen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Constant.dart';
import '../apiservice/ApiService.dart';
import '../utils/styleUtil.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  var isShowPassword = false.obs;
  var bottomTabIndex = 0.obs;
  final ApiService _apiService = ApiService();
  Future<void> loginProcess(Map<String, dynamic> userData) async {
    isLoading.value = true;
    try {
      final response = await _apiService.postRequest(
        data: userData,
          Constant.LOGNIAPI
      );
      debugPrint("LoginResponse: $response");
      if(response["status"] == "success"){
        showToast(response["message"]);
        Map uData = response["data"];
        SessionManager().saveUserData(uData);
      }else{
        showToast(response["message"]);
      }
    } catch (error) {
      // ERROR handling from your ApiService
      debugPrint("Login Failed: ${error.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> reSendOTP(Map<String, dynamic> userData) async {
    try {
      final response = await _apiService.postRequest(
        data: userData,
          Constant.SendOTP
      );
      debugPrint("LoginResponse: $response");
      if(response["status"] == "success"){
        showToast(response["message"]);
        Get.off(VerifyOTPScreen(email: userData["user_email"], pageType: "signup"));
      }else{
        showToast(response["message"]);
      }
    } catch (error) {
      // ERROR handling from your ApiService
      debugPrint("Login Failed: ${error.toString()}");
    } finally {
    }
  }

  Future<void> sendOTP(Map<String, dynamic> userData) async {
    isLoading.value = true;
    try {
      final response = await _apiService.postRequest(
        data: userData,
          Constant.SendOTP
      );
      debugPrint("LoginResponse: $response");
      if(response["status"] == "success"){
        showToast(response["message"]);
        Get.off(VerifyOTPScreen(email: userData["user_email"], pageType: "signup"));
      }else{
        showToast(response["message"]);
      }
    } catch (error) {
      // ERROR handling from your ApiService
      debugPrint("Login Failed: ${error.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOTP(Map<String, dynamic> userData) async {
    isLoading.value = true;
    try {
      final response = await _apiService.postRequest(
        data: userData,
          Constant.OTPVerifyAPI
      );
      debugPrint("VerifyResponse: $response");
      if(response["status"] == "success"){
        showToast(response["message"]);
        Get.off(SignUpPage(email: userData["user_email"]));
      }else{
        showToast(response["message"]);
      }
    } catch (error) {
      // ERROR handling from your ApiService
      debugPrint("Login Failed: ${error.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> finalRegister1(Map<String, dynamic> userData) async {
    isLoading.value = true;
    try {
      final response = await _apiService.postRequest(
        data: userData,
          Constant.REGISTERPROCESS
      );
      debugPrint("registerResponse: $response");
      if(response["status"] == "success"){
        showToast(response["message"]);
        Map uData = response["data"];
        SessionManager().saveUserData(uData);
      }else{
        showToast(response["message"]);
      }
    } catch (error) {
      // ERROR handling from your ApiService
      debugPrint("Login Failed: ${error.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> finalRegister(Map<String, dynamic> userData) async {
    isLoading.value = true;
    try {
      final response = await _apiService.postRequest(
        Constant.REGISTERPROCESS,
        data: userData,
      );
      debugPrint("registerResponse: $response");
      if (response["status"] == "success") {
        showToast(response["message"]);
        Map uData = response["data"];
        SessionManager().saveUserData(uData);
      } else {
        showToast(response["message"] ?? "Registration failed");
      }
    } on DioException catch (e) {
      // This is the important part: server response body is in e.response?.data
      debugPrint("REGISTER ERROR STATUS: ${e.response?.statusCode}");
      debugPrint("REGISTER ERROR DATA: ${e.response?.data}");

      final respData = e.response?.data;
      if (respData is Map && respData.containsKey('errors')) {
        final errors = respData['errors'] as Map;
        final combined = errors.entries.map((entry) {
          final key = entry.key;
          final val = entry.value;
          if (val is List && val.isNotEmpty) return "$key: ${val.first}";
          return "$key: $val";
        }).join("\n");
        showToast(combined);
      } else if (respData is Map && respData.containsKey('message')) {
        showToast(respData['message'].toString());
      } else {
        showToast("Registration failed. Check logs.");
      }
    } catch (error) {
      debugPrint("Login Failed: ${error.toString()}");
      showToast("An unexpected error occurred");
    } finally {
      isLoading.value = false;
    }
  }
}