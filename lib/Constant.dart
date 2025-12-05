import 'package:aitutorlab/session/SessionManager.dart';

class Constant {
  static String appName = "AI TUTOR LAB";

  static String BASE_URL = "https://www.skcip.in/api/";

  static String LOCAL_BASE_URL = "https://www.skcip.in/api/";

  static String HOMEDATAAPI = "${BASE_URL}home-data-api";


  static String DASHBOARDDATAAPI = "${BASE_URL}dashboard-data-api";

  static String LOGNIAPI = "${BASE_URL}login-process";
  static String SendOTP = "${BASE_URL}send-otp-process";
  static String OTPVerifyAPI = "${BASE_URL}verify-otp-process";
  static String REGISTERPROCESS = "${BASE_URL}register-process";



/*  Map<String, String> userHeader = {
    "x-authorization" : SessionManager().user_token ?? ""
  };*/
  Map<String, String> userHeader = {
    // 'Content-Type': 'application/json',
    'Accept': 'application/json',
    "X-AUTH-TOKEN" : SessionManager.getTokenId() ?? ""
  };
}