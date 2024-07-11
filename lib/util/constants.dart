

import '../dao/user_dao.dart';

class Constants {
  static String authTokenK = "auth-token";
  static String authTokenV = "";
  static String courseFlagK = "course-flag";
  static String courseFlagV = "fa";
  static const theme = "hi_theme";
  static headers() {
    ///设置请求头校验，注意留意：Console的log输出：flutter: received:
    Map<String, dynamic> header = {
      Constants.authTokenK: Constants.authTokenV,
      Constants.courseFlagK: Constants.courseFlagV
    };
    header[UserDao.AUTHORIZATION] = UserDao.getToken();
    return header;
  }
}
