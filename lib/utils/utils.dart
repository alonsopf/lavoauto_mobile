import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lavoauto/core/constants/app_strings.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../presentation/common_widgets/custom_text.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:image_picker/image_picker.dart';

class Utils {
  Utils._();
  static SharedPreferences? sharedpref;
  static DateTime? lastQuitTime;

  static TextEditingController calleController = TextEditingController();

  static TextEditingController numExtController = TextEditingController();

  static TextEditingController numIntController = TextEditingController();

  static TextEditingController coloniaController = TextEditingController();
  static TextEditingController approxWeightController = TextEditingController();
  static TextEditingController detergentTypeController = TextEditingController();
  static TextEditingController dryingMethodTypeController = TextEditingController();

  static TextEditingController serviceScheduleDateController = TextEditingController();
  static TextEditingController specialInstructionsController =
      TextEditingController();

  // New controllers for enhanced order features
  static TextEditingController pickupTimeClientController = TextEditingController();
  static TextEditingController deliveryTimeClientController = TextEditingController();
  static TextEditingController ironingNumberController = TextEditingController();

  // Boolean flags
  static bool suavizante = false;
  static bool lavadoUrgente = false;
  static bool lavadoSecadoUrgente = false;
  static bool lavadoSecadoPlanchadoUrgente = false;
  static String? selectedIroningType; // 'con_gancho' or 'sin_gancho'

  
  static final imagePicker = ImagePicker();
  static bool applicationExit(BuildContext context) {
    if (lastQuitTime == null ||
        DateTime.now().difference(lastQuitTime!).inSeconds > 1) {
      lastQuitTime = DateTime.now();
      showSnackbar(msg: AppStrings.appName, context: context, duration: 2000);

      return false;
    } else {
      SystemNavigator.pop();
      return true;
    }
  }

  static Future<String> convertToBase64WithPrefix(XFile xfile) async {
    List<int> imageBytes = await xfile.readAsBytes();

    final content = base64.encode(imageBytes);
    return content;
  }

  static Future<XFile?> getImage({bool isCamera = false}) async {
    XFile? file;

    file = await imagePicker.pickImage(
        preferredCameraDevice: CameraDevice.front,
        source: isCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 50);

    if (file != null) {
      return file;
    }
    return null;
  }

  static String getContentType(extension) {
    String? contentType;
    switch (extension) {
      case '.png':
        contentType = 'image/png';
        break;
      case '.jpg':
      case '.jpeg':
        contentType = 'image/jpeg';
        break;
      case '.gif':
        contentType = 'image/gif';
        break;
      default:
        throw Exception('Unsupported file type');
    }
    return contentType;
  }

  static Future<bool> permissionSetting() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    bool permission = false;

    try {
      if (Platform.isAndroid) {
        final androidDeviceInfo = await deviceInfoPlugin.androidInfo;
        int androidVersion = int.parse(androidDeviceInfo.version.release);
        if (androidVersion >= 13) {
          permission = (await Permission.camera.request().isGranted &&
              await Permission.photos.request().isGranted);
        } else {
          permission = (await Permission.camera.request().isGranted &&
              await Permission.storage.request().isGranted);
        }
      } else if (Platform.isIOS) {
        // For iOS, check current status first
        var cameraStatus = await Permission.camera.status;
        var photosStatus = await Permission.photos.status;
        
        debugPrint("🔒 iOS Current Status - Camera: $cameraStatus, Photos: $photosStatus");
        
        // If permissions are permanently denied, don't request again
        if (cameraStatus.isPermanentlyDenied || photosStatus.isPermanentlyDenied) {
          debugPrint("⚠️ Some permissions are permanently denied - directing to settings");
          return false;
        }
        
        // Request permissions if not already granted
        if (!cameraStatus.isGranted) {
          cameraStatus = await Permission.camera.request();
        }
        if (!photosStatus.isGranted) {
          photosStatus = await Permission.photos.request();
        }
        
        debugPrint("🔒 iOS Final Status - Camera: $cameraStatus, Photos: $photosStatus");
        
        permission = (cameraStatus.isGranted && photosStatus.isGranted);
      }
    } catch (e) {
      debugPrint("💥 Permission error: $e");
    }

    debugPrint("🔒 Final permission result: $permission");
    return permission;
  }

  static Future<void> showPermissionDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: CustomText(
            text: "Permisos requeridos",
            fontColor: AppColors.blackColor,
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
          ).setText(),
          content: CustomText(
            text: "Para usar esta función, necesitas permitir el acceso a la cámara y galería en la configuración de tu dispositivo.",
            fontColor: AppColors.greyNormalColor,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
            maxLines: 5,
          ).setText(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: CustomText(
                text: 'Cancelar',
                fontColor: AppColors.greyNormalColor,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ).setText(),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await openAppSettings();
              },
              child: CustomText(
                text: 'Ir a Configuración',
                fontColor: AppColors.primary,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ).setText(),
            ),
          ],
        );
      },
    );
  }

  static submitProfile(BuildContext context, oncamera, onGallery) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: oncamera,
                  minVerticalPadding: 0,
                  visualDensity: VisualDensity.comfortable,
                  minLeadingWidth: 10,
                  horizontalTitleGap: 20,
                  leading: const Icon(
                    Icons.camera,
                    color: AppColors.primary,
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.greyNormalColor,
                    size: 18.0,
                  ),
                  title: CustomText(
                    text: AppStrings.camera_,
                    fontColor: AppColors.greyNormalColor,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w600,
                  ).setText(),
                ),
                ListTile(
                  onTap: onGallery,
                  trailing: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: AppColors.greyNormalColor,
                    size: 18.0,
                  ),
                  minVerticalPadding: 0,
                  visualDensity: VisualDensity.comfortable,
                  minLeadingWidth: 10,
                  horizontalTitleGap: 20,
                  leading: const Icon(
                    Icons.image,
                    color: AppColors.primaryColor,
                  ),
                  title: CustomText(
                    text: AppStrings.gallery_,
                    fontColor: AppColors.greyNormalColor,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.w600,
                  ).setText(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static String formatDateTime(String dateTime) {
    DateTime dateTimeObj = DateTime.parse(dateTime).toLocal();
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm a');
    return formatter.format(dateTimeObj);
  }

  static Future<void> selectDate(
      BuildContext context, void Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      onDateSelected(picked);
    }
  }

  static Future<void> selectDateAndTime(
      BuildContext context, void Function(DateTime) onDateTimeSelected) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    
    if (pickedDate != null) {
      if (!context.mounted) return;
      
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      
      if (pickedTime != null) {
        // Combine date and time
        final DateTime dateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        onDateTimeSelected(dateTime);
      }
    }
  }

  static getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static exitApplication() {
    return false;
  }

  static navigateToScreen(dynamic screeninfo) async {
    await Future.delayed(
        const Duration(milliseconds: 4000), () => {screeninfo});
  }

  static Future<SharedPreferences> setSharedPreference() async {
    return sharedpref = await SharedPreferences.getInstance();
  }

  static Future<void> setAuthenticationToken(String? token, String? userType) async {
    if (sharedpref == null) {
      debugPrint("⚠️ SharedPreferences not initialized");
      return;
    }
    
    if (token != null && userType != null) {
      await sharedpref!.setBool('login', true);
      await sharedpref!.setString('token', token);
      await sharedpref!.setString('userType', userType);
    } else {
      debugPrint("⚠️ Cannot set null token or userType");
    }
  }

  static bool getAuthentication() {
    return sharedpref?.getBool('login') ?? false;
  }

  static String getAuthenticationUser() {
    return sharedpref?.getString('userType') ?? '';
  }

  static bool isClientUser() {
    String userType = getAuthenticationUser();
    debugPrint("🔍 isClientUser() - userType: '$userType', isClient: ${userType.toLowerCase() == 'client'}");
    return userType.toLowerCase() == 'client';
  }

  static bool isServiceProvider() {
    String userType = getAuthenticationUser();
    debugPrint("🔍 isServiceProvider() - userType: '$userType', isProvider: ${userType.toLowerCase() == 'lavador'}");
    return userType.toLowerCase() == 'lavador';
  }

  static String getAuthenticationToken() {
    return sharedpref?.getString('token') ?? '';
  }

  static Future<bool> unAuthenticate() async {
    if (sharedpref != null) {
      await sharedpref!.clear();
    } else {
      debugPrint("⚠️ SharedPreferences not initialized, cannot clear session");
    }
    return true;
  }

  static bool compareDates(String startDate, String endDate) {
    DateTime startDateTime = DateTime.parse(startDate).toLocal();
    DateTime endDateTime = DateTime.parse(endDate).toLocal();
    DateTime currentDateTime = DateTime.now().toLocal();

    if (currentDateTime.isBefore(endDateTime)) {
      return false;
    } else {
      return true;
    }
  }

  static void showSnackbar({
    String? msg,
    int duration = 3400,
    required BuildContext context,
  }) {
    if (!context.mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: BoxDecoration(
            color: AppColors.blackColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: CustomText(
            text: msg,
            maxLines: 3,
            fontColor: AppColors.whiteColor,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w500,
            fontSize: 18.0,
            letterSpacing: 0.5,
          ).setText(),
        ),
        backgroundColor: Colors.transparent,
        duration: Duration(milliseconds: duration),
        padding: EdgeInsets.zero,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  static void showAlert({
    String? title,
    String? message,
    required BuildContext context,
    String? buttonText,
    VoidCallback? onSuccess,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          title: title != null
              ? CustomText(
                  text: title,
                  fontColor: AppColors.blackColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                  textAlign: TextAlign.center,
                ).setText()
              : null,
          content: CustomText(
            text: message ?? '',
            fontColor: AppColors.greyNormalColor,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
            maxLines: 5,
          ).setText(),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (onSuccess != null) {
                  onSuccess();
                }
              },
              child: CustomText(
                text: buttonText ?? 'Aceptar',
                fontColor: AppColors.primary,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ).setText(),
            ),
          ],
        );
      },
    );
  }
}
