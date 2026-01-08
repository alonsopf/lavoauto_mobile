import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageUtils {
  static const String _profileImageKey = 'profile_image_path';
  static const int _imageSize = 512; // 512x512 pixels
  
  /// Resize image to 512x512 pixels and convert to JPG
  static Future<File> resizeImage(XFile imageFile) async {
    // Read the image file
    final bytes = await imageFile.readAsBytes();
    debugPrint("📸 Original image size: ${bytes.length} bytes");
    
    // Decode the image
    img.Image? originalImage = img.decodeImage(bytes);
    if (originalImage == null) {
      throw Exception('Failed to decode image');
    }
    
    debugPrint("📸 Original dimensions: ${originalImage.width}x${originalImage.height}");
    
    // Resize to 512x512 with appropriate fit
    img.Image resizedImage = img.copyResize(
      originalImage,
      width: _imageSize,
      height: _imageSize,
      interpolation: img.Interpolation.linear,
    );
    
    debugPrint("📸 Resized dimensions: ${resizedImage.width}x${resizedImage.height}");
    
    // Encode as JPG with high quality (smaller file size than PNG)
    List<int> resizedBytes = img.encodeJpg(resizedImage, quality: 90);
    debugPrint("📸 JPG encoded size: ${resizedBytes.length} bytes");
    
    // Get app documents directory
    final directory = await getApplicationDocumentsDirectory();
    final resizedFile = File('${directory.path}/temp_resized_profile.jpg');
    
    // Write the resized image
    await resizedFile.writeAsBytes(resizedBytes);
    debugPrint("📸 JPG file created at: ${resizedFile.path}");
    
    return resizedFile;
  }
  
  /// Save profile image locally and return the local path
  static Future<String> saveProfileImageLocally(File imageFile) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final localPath = '${directory.path}/profile_image.jpg';
      
      // Copy the image to local storage
      await imageFile.copy(localPath);
      
      // Save the path in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_profileImageKey, localPath);
      
      return localPath;
    } catch (e) {
      throw Exception('Failed to save profile image locally: $e');
    }
  }
  
  /// Get local profile image path from SharedPreferences
  static Future<String?> getLocalProfileImagePath() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_profileImageKey);
    } catch (e) {
      return null;
    }
  }
  
  /// Get local profile image file if it exists
  static Future<File?> getLocalProfileImageFile() async {
    try {
      final path = await getLocalProfileImagePath();
      if (path != null) {
        final file = File(path);
        if (await file.exists()) {
          return file;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
  
  /// Check if local profile image exists
  static Future<bool> hasLocalProfileImage() async {
    final file = await getLocalProfileImageFile();
    return file != null;
  }
  
  /// Delete local profile image
  static Future<void> deleteLocalProfileImage() async {
    try {
      final file = await getLocalProfileImageFile();
      if (file != null && await file.exists()) {
        await file.delete();
      }
      
      // Remove from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_profileImageKey);
    } catch (e) {
      // Ignore errors when deleting
    }
  }
  
  /// Complete flow: resize image, save locally, return local path
  static Future<String> processAndSaveProfileImage(XFile imageFile) async {
    // 1. Resize the image
    final resizedFile = await resizeImage(imageFile);
    
    // 2. Save locally
    final localPath = await saveProfileImageLocally(resizedFile);
    
    // 3. Clean up temp file
    if (await resizedFile.exists()) {
      await resizedFile.delete();
    }
    
    return localPath;
  }
  
  /// Convert image file to base64 for API upload
  static Future<String> imageToBase64(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return base64Encode(bytes);
  }
  
  /// Get content type - always JPEG for processed images
  static String getContentType(String filePath) {
    // For processed profile images, always return JPEG since we convert everything to JPG
    if (filePath.contains('profile_image') || filePath.contains('temp_resized_profile')) {
      return 'image/jpeg';
    }
    
    // For other files, detect by extension
    if (filePath.toLowerCase().endsWith('.png')) {
      return 'image/png';
    } else if (filePath.toLowerCase().endsWith('.jpg') || 
               filePath.toLowerCase().endsWith('.jpeg')) {
      return 'image/jpeg';
    } else if (filePath.toLowerCase().endsWith('.gif')) {
      return 'image/gif';
    } else {
      return 'image/jpeg'; // Default to JPEG for processed images
    }
  }
} 