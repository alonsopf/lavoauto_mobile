import '/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dependencyInjection/di.dart';
import 'presentation/screens/lavoautoApp/app.dart';
import 'theme/apptheme.dart';
import 'utils/systemorientationUtils/system_orientation_imports.dart';
import 'data/services/stripe_service.dart';
import 'core/config/app_config.dart';

void main() async {
  // Wrap everything in a try-catch to prevent any crash
  try {
    await _initializeApp();
  } catch (e) {
    debugPrint("💥 FATAL ERROR in main(): $e");
    // Last resort - run minimal app
    runApp(_buildEmergencyApp(e.toString()));
  }
}

Future<void> _initializeApp() async {
  // Initialize Flutter binding first - this must succeed
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint("🚀 Starting Lavoauto App initialization...");

  // Track initialization status
  bool environmentLoaded = false;
  bool firebaseLoaded = false;
  bool dependenciesLoaded = false;
  bool sharedPrefsLoaded = false;
  bool stripeLoaded = false;

  // 1. Initialize Firebase - required for push notifications
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDTZ1aiq1KdAc67dvr5zuUpjuAYgBCoxCA',
        appId: '1:981242199322:ios:49add20e65768621d840a3',
        messagingSenderId: '981242199322',
        projectId: 'lavoauto-c6522',
        storageBucket: 'lavoauto-c6522.firebasestorage.app',
      ),
    );
    firebaseLoaded = true;
    debugPrint("✅ Firebase initialized");
  } catch (e) {
    debugPrint("⚠️  Firebase initialization failed: $e");
    debugPrint("🔔 Push notifications disabled");
  }

  // 2. Environment variables - graceful fallback
  try {
    await dotenv.load(fileName: ".env");
    environmentLoaded = true;
    debugPrint("✅ Environment variables loaded");
  } catch (e) {
    debugPrint("⚠️  Environment file not accessible: $e");
    debugPrint("📱 Using hardcoded fallback values");
    // Ensure dotenv is in a safe state
    try {
      dotenv.env.clear();
    } catch (_) {
      // Ignore secondary errors
    }
  }
  
  // 3. Print configuration (non-critical)
  try {
    AppConfig.printConfiguration();
  } catch (e) {
    debugPrint("⚠️  Configuration debug failed: $e");
  }

  // 4. Dependency injection - continue if fails
  try {
    await AppContainer.init();
    dependenciesLoaded = true;
    debugPrint("✅ Dependencies initialized");
  } catch (e) {
    debugPrint("⚠️  Dependencies failed: $e - continuing anyway");
  }

  // 5. Theme observer - non-critical
  try {
    ThemeObserver().didChangePlatformBrightness();
    debugPrint("✅ Theme observer ready");
  } catch (e) {
    debugPrint("⚠️  Theme observer failed: $e");
  }

  // 6. System orientation - non-critical
  try {
    SystemOrientation.setSystemOrientation();
    debugPrint("✅ Orientation set");
  } catch (e) {
    debugPrint("⚠️  Orientation setup failed: $e");
  }

  // 7. SharedPreferences - critical for user data
  try {
    await Utils.setSharedPreference();
    sharedPrefsLoaded = true;
    debugPrint("✅ SharedPreferences ready");
  } catch (e) {
    debugPrint("⚠️  SharedPreferences failed: $e");
    debugPrint("📱 User data features may be limited");
  }

  // 8. Stripe - non-critical for basic app function
  try {
    await StripeService.initialize();
    stripeLoaded = true;
    debugPrint("✅ Stripe ready");
  } catch (e) {
    debugPrint("⚠️  Stripe failed: $e");
    debugPrint("💳 Payment features disabled");
  }

  // 9. Launch app
  debugPrint("🎉 Initialization complete!");
  debugPrint("📊 Status: FIREBASE:${firebaseLoaded ? '✅' : '❌'} ENV:${environmentLoaded ? '✅' : '❌'} DI:${dependenciesLoaded ? '✅' : '❌'} PREFS:${sharedPrefsLoaded ? '✅' : '❌'} STRIPE:${stripeLoaded ? '✅' : '❌'}");

  runApp(const LavoautoApp());
}

Widget _buildEmergencyApp(String error) {
  return MaterialApp(
    title: 'Lavoauto',
    home: Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning_amber, size: 64, color: Colors.orange),
              SizedBox(height: 24),
              Text(
                'Lavoauto',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'La aplicación está iniciando en modo seguro',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Try to restart the app
                  main();
                },
                child: Text('Reintentar'),
              ),
              SizedBox(height: 16),
              Text(
                'Si el problema persiste, reinstala la aplicación',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
