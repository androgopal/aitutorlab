import 'package:aitutorlab/session/SessionManager.dart';

class Constant {
  static String appName = "AI TUTOR LAB";

  static String BASE_URL = "https://www.skcip.in/api/";

  static String LOCAL_BASE_URL = "https://www.skcip.in/api/";

  static String HOMEDATAAPI = "${BASE_URL}home-data-api";



/*  Map<String, String> userHeader = {
    "x-authorization" : SessionManager().user_token ?? ""
  };*/
  Map<String, String> userHeader = {
    // 'Content-Type': 'application/json',
    'Accept': 'application/json',
    "X-AUTH-TOKEN" : SessionManager.getTokenId() ?? ""
  };
}