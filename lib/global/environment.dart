import 'dart:io';

class Environment {
  static String apiUrl =
      Platform.isAndroid ? 'http://10.0.2.2:3001/api' : 'localhost:3001/api';
  static String socketUrl =
      Platform.isAndroid ? 'http://10.0.2.2:3001' : 'localhost:3001';
}
