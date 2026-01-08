# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Lavoauto** is a Flutter mobile application for car washing services in Spanish. It connects car washers (lavadores) with clients who need car washing services, featuring service pricing by vehicle type, distance-based pricing, payments via Stripe, and user ratings.

## Development Commands

### Setup and Dependencies
```bash
# Install Flutter dependencies
flutter pub get

# Generate auto_route routes and JSON serialization code
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes and auto-rebuild generated files
flutter pub run build_runner watch --delete-conflicting-outputs
```

### Running the Application
```bash
# Run in debug mode
flutter run

# Run on specific device
flutter run -d <device_id>

# Run with device preview for responsive testing
flutter run --dart-define=DEVICE_PREVIEW=true
```

### Building for Production
```bash
# Android APK
flutter build apk

# Android App Bundle
flutter build appbundle

# iOS
flutter build ios
```

### Code Quality and Analysis
```bash
# Run static analysis
flutter analyze

# Run linter
flutter pub run dart_fix --dry-run
flutter pub run dart_fix --apply
```

## Architecture Overview

### State Management
- **BLoC Pattern**: Uses `flutter_bloc` for state management
- **Dependency Injection**: Uses `injectable` and `get_it` for service locator pattern
- **Repository Pattern**: Data layer with repositories for API communication

### Key Architectural Components

#### Core Structure
- `lib/main.dart` - Application entry point with Stripe initialization
- `lib/core/config/app_config.dart` - Environment configuration (hardcoded to production)
- `lib/dependencyInjection/` - DI setup using injectable/get_it pattern

#### Presentation Layer
- `lib/presentation/screens/` - Two main user types: clients and washers (lavadores)
- `lib/presentation/router/` - Auto-generated routing using `auto_route`
- `lib/presentation/common_widgets/` - Reusable UI components

#### Data Layer
- `lib/data/data_sources/remote/` - API client with UTF-8 encoding handling
- `lib/data/models/` - Request/response models with JSON serialization
- `lib/data/repositories/` - Repository implementations for different domains
- `lib/data/services/stripe_service.dart` - Payment processing

#### Business Logic
- `lib/bloc/` - BLoC classes organized by feature (auth, user_info, orders, etc.)

### User Types and Features

1. **Clients (Customers)**
   - Add and manage their vehicles
   - Select vehicle type and service
   - Create car wash orders with location
   - View washer offers (base price + distance price)
   - Select washer and request service
   - Payment via Stripe after service completion
   - Rate washers

2. **Lavadores (Car Washers)**
   - Set prices per service type and vehicle category
   - Set price per kilometer for travel distance
   - Browse available orders
   - Accept orders
   - Manage completed work
   - Track earnings and ratings

## Backend API Integration

### Lavoauto Endpoints
All endpoints use the `lavoauto_` prefix:

**Authentication:**
- `POST /lavoauto_register` - Client registration
- `POST /lavoauto_register-lavador` - Washer registration
- `POST /lavoauto_login` - Login (auto-detects client vs washer)

**NOTE:** Other endpoints (orders, vehicles, services, payments) are pending implementation.

### Database Schema
The backend uses PostgreSQL with the `lavoauto` schema:
- `lavoauto.clientes` - Client information
- `lavoauto.lavadores` - Washer information with `precio_km` field
- `lavoauto.tipos_servicio` - Service types (catalog + custom per washer)
- `lavoauto.lavador_servicios_precios` - Pricing matrix (service × vehicle category)
- `lavoauto.catalogo_vehiculos` - Vehicle catalog (250+ vehicles from official Mexican sources)
- `lavoauto.vehiculos_cliente` - Client's vehicles
- `lavoauto.ordenes` - Service orders with pricing calculation
- `lavoauto.tokens` - Authentication tokens

### Vehicle Categories
```dart
enum VehicleCategory {
  moto,           // Motorcycle
  compacto,       // Compact car
  sedan,          // Sedan
  suv,            // SUV
  pickup,         // Pickup truck
  camionetaGrande // Large truck/van
}
```

## Key Differences from lavoauto

| Feature | lavoauto (Laundry) | Lavoauto (Car Wash) |
|---------|-------------------|---------------------|
| Service | Laundry | Car washing |
| Pricing | Bidding system | Fixed price per service + distance |
| Items | Clothes (kg) | Vehicles (by type) |
| Service Types | Wash/dry/iron | Exterior/complete/premium/etc |
| Distance | Not a factor | Price per km |
| Catalog | N/A | 250+ vehicle models |

## Technical Notes

### API Integration
- Base URL: Same AWS API Gateway as lavoauto
- Character encoding: Custom UTF-8 handling in API client
- Authentication: Token-based (stored in SharedPreferences)
- Endpoints: All use `lavoauto_` prefix

### Payment Processing
- Stripe integration with production keys
- Payment after service completion (not upfront)
- Tokenization for secure transactions

### Code Generation
Run the build_runner command after:
- Adding new auto_route pages
- Modifying JSON serializable models
- Adding new injectable services

### Environment
- Currently hardcoded to production environment
- Stripe keys are embedded in code (consider moving to environment variables for better security)

## Current Implementation Status

✅ **Completed:**
- Project structure copied from lavoauto
- Package renamed to `lavoauto`
- Android app ID updated to `com.alonsopf.lavoauto`
- API endpoints updated for auth (login, register)
- Backend handlers created for login/register

⚠️ **Pending:**
- Vehicle management screens (add/edit/delete vehicles)
- Service type selection
- Order creation with vehicle and service selection
- Washer pricing management
- Order list and details
- Payment integration
- Chat/messaging
- Ratings and reviews
- Push notifications

## UI/UX Notes

The app inherits the modern design from lavoauto:
- Off-white backgrounds (#F7F9FA)
- Blue gradient color scheme (#32D688F → #7EB5D6 → #A88FFE2)
- White cards with subtle shadows
- Rounded corners (12px buttons, 20px cards)
- Clean, minimal aesthetic

## Assets

Currently using lavoauto assets (logos, icons, etc.). These will be replaced with lavoauto branding later.

## Next Steps

1. Clean build artifacts: `flutter clean`
2. Get dependencies: `flutter pub get`
3. Generate code: `flutter pub run build_runner build --delete-conflicting-outputs`
4. Test login/register flows
5. Implement vehicle management screens
6. Implement order creation workflow
7. Add washer-specific screens
