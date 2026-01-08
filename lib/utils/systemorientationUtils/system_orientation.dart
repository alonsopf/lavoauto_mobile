part of 'system_orientation_imports.dart';

class SystemOrientation {
  SystemOrientation._();
  
  static void setSystemOrientation() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }
}
