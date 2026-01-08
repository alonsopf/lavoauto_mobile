# Implementation Plan: Integrating Endpoints into Dummy Screens

## Overview
This plan outlines integrating backend endpoints into the dummy design screens (ClothesScreen, GanchoPage, ServiceSelectPage, etc.) that are part of the order creation flow. The goal is to replace hardcoded values with dynamic data from the backend while maintaining the existing UI designs.

## Current State Analysis

### Dummy Screens Identified
The following screens have hardcoded/dummy data and need endpoint integration:

1. **ServiceSelectPage** (`lib/features/pages/service/service_select_page.dart`)
   - Hardcoded service options: "Lavado", "Lavado y Secado", "Lavado, Secado y Planchado"
   - Hardcoded selected date: "Hoy"
   - Hardcoded bid from "Ana" with price "$180" and network image
   - **Endpoint needed**: `/list-available-orders` to get actual bids/offers

2. **ClothesScreen** (`lib/features/pages/clothes/clothes_screen.dart`)
   - Hardcoded quantity categories: "Poca", "Normal", "Mucha"
   - Hardcoded clothing types: "Ropa diaria", "Ropa delicada", "Blancos", "Ropa de trabajo"
   - Uses ClothesBloc for local state only
   - **Endpoint needed**: None (static options are acceptable)
   - **Note**: This screen collects user preferences for the order

3. **GanchoPage** (`lib/features/pages/Gancho/gancho_page.dart`)
   - Hardcoded hanger options: "Sin gancho", "Gancho nuevo", "Gancho del cliente"
   - Uses GanchoBloc for local state only
   - **Endpoint needed**: None (static options are acceptable)

4. **WashPreferencesPage** (`lib/features/pages/washPreferences/wash_preferences_page.dart`)
   - Hardcoded detergent types: "Detergente normal", "Detergente para piel sensible", "Ecológico"
   - Hardcoded water temperatures: "Fría", "Tibia", "Caliente"
   - Softener toggle
   - **Endpoint needed**: None (static options are acceptable)

5. **PickupSchedulePage** (`lib/features/pages/pickUp/pickup_schedule_page.dart`)
   - Hardcoded addresses: "Casa", "Trabajo"
   - Hardcoded date: "10 de abril de 2024"
   - Hardcoded time: "Entre 7:00 y 8:00 p.m."
   - **Endpoints needed**:
     - Get user's saved addresses
     - Get available pickup/delivery times

6. **ReviewOrderPage** (`lib/features/pages/reviewOrder/review_order_page.dart`)
   - **Status**: Need to verify hardcoded data
   - **Endpoint needed**: None (just displays order summary before creation)

### Order Creation Flow
```
HomePage
  ↓ (Nueva Orden button)
ServiceSelectPage (Select service type + date, browse available bids)
  ↓ (Continue button → ClothesScreen)
ClothesScreen (Select clothes types and quantity)
  ↓ (Continue button → GanchoPage)
GanchoPage (Select hanger preference)
  ↓ (Continue button → WashPreferencesPage)
WashPreferencesPage (Select detergent, water temp, softener)
  ↓ (Continue button → PickupSchedulePage)
PickupSchedulePage (Select address and pickup time)
  ↓ (Continue button → ReviewOrderPage)
ReviewOrderPage (Review order details)
  ↓ (Confirm button → POST /create-order)
HomePage (Order created successfully)
```

### Backend Endpoints Available
From `lavoauto/handlers.go`:
- ✅ `/create-order` - Create order (POST)
- ✅ `/get-order-requests` - Get user's orders
- ✅ `/list-available-orders` - Get available orders to bid on (for service providers)
- ✅ `/user-info` - Get user profile
- ⚠️ `/update-info` - Update user information (may include addresses)

### BLoC Current Status

| BLoC | Current Events | Current State | Needs API Integration |
|------|----------------|---------------|----------------------|
| ServiceBloc | SelectService, SelectDate | selectedService, selectedDate | ✅ Yes (list-available-orders) |
| ClothesBloc | ChangeQuantity, ToggleClothesType, ChangeNote, SubmitClothes | model (ClothesModel) | ❌ No (local state OK) |
| GanchoBloc | SelectGanchoOption | selectedOption | ❌ No (local state OK) |
| WashBloc | ToggleSoftener, SelectDetergent, SelectTemperature | softener, detergent, temperature | ❌ No (local state OK) |
| (Need to check) PickupBloc | ??? | ??? | ✅ Maybe (user addresses) |
| (Need to check) ReviewBloc | ??? | ??? | ❌ No (just display) |

### Router Status
**Current**: These screens are NOT registered in `router.dart`, they use `Navigator.push()` instead.
- ServiceSelectPage, ClothesScreen, GanchoPage, WashPreferencesPage, PickupSchedulePage, ReviewOrderPage

**Decision**: Keep using Navigator.push() for now (matches current design flow)

## Implementation Strategy

### Phase 1: Data Collection and BLoC Enhancement

#### Task 1.1: Create unified order data model
- Create `CreateOrderData` model to hold order state across all screens
- Include fields from `CreateUserOrderRequest`:
  - Service type (metodoSecado)
  - Quantity (pesoAproximadoKg)
  - Clothing types (as list of selected types)
  - Detergent (tipoDetergente)
  - Softener (suavizante)
  - Water temperature (not in request but can be notes)
  - Hanger type (affects tipoPlanchado)
  - Pickup address (direccion, lat, lon)
  - Pickup time (fechaRecogidaPropuestaCliente)
  - Delivery time (fechaEntregaPropuestaCliente)

#### Task 1.2: Enhance ClothesBloc with SubmitClothes handler
- Add event handler to `SubmitClothes` that saves the clothes selection
- Store quantity as approximate kg based on selection:
  - "Poca" → 5 kg
  - "Normal" → 7.5 kg (or get from estimate)
  - "Mucha" → 12 kg
- Add TODO comment: `// TODO: Map quantity to actual kg from backend/estimate endpoint`

#### Task 1.3: Enhance GanchoBloc with hanger type mapping
- In `SelectGanchoOption`, map selected option to `tipoPlanchado`:
  - "Sin gancho" → null
  - "Gancho nuevo" → "con_gancho"
  - "Gancho del cliente" → "con_gancho"
- Add TODO comment: `// TODO: Verify tipoPlanchado values from backend`

#### Task 1.4: Enhance WashBloc with detergent type mapping
- In `SelectDetergent`, map selected option to backend format:
  - "Detergente normal" → "En polvo" (or "Líquido")
  - "Detergente para piel sensible" → "Líquido"
  - "Ecológico" → "Ecológico"
- Add TODO comment: `// TODO: Verify detergent type values from backend`

### Phase 2: Address and Timing Data

#### Task 2.1: Create/enhance PickupBloc
- Fetch user's saved addresses on initialization
- Query endpoint: `GET /user-info` (already returns user data)
- If addresses not available, add TODO: `// TODO: Implement /get-user-addresses endpoint in backend`
- Store selected address (lat, lon, direccion)
- Handle date picker for pickup date
- Handle time picker for pickup time (0600-2200 range?)

#### Task 2.2: Add address selection logic
- Display user's saved addresses ("Casa", "Trabajo", etc.)
- Show "Agregar nueva dirección" as option
- On selection, store address data needed for CreateUserOrderRequest

### Phase 3: Service Selection and Bids Integration

#### Task 3.1: Integrate ServiceBloc with list-available-orders
- **Current**: Shows hardcoded bid from "Ana"
- **Change**:
  - Fetch actual available orders/bids from `/list-available-orders`
  - Display real bids instead of dummy data
  - Add TODO comment: `// TODO: Implement /list-available-orders integration`

- **Alternative Approach** (if orders haven't been created yet):
  - Keep ServiceSelectPage for service type selection only
  - Move bid selection to separate screen later in flow
  - Add TODO: `// TODO: Show actual available bids after order details are submitted`

#### Task 3.2: Map service type to backend fields
- "Lavado" → metodoSecado = "secado_al_aire"
- "Lavado y Secado" → metodoSecado = "secado_mecanico"
- "Lavado, Secado y Planchado" → tipoPlanchado = "con_gancho", metodoSecado = "secado_mecanico"

### Phase 4: Order Creation and Submission

#### Task 4.1: Update navigation to pass data
- Modify `SubmitClothes` button to pass collected data to next screen
- Modify `Continue` buttons in all screens to accumulate order data
- Store in BLoC state or pass via constructor

#### Task 4.2: Implement ReviewOrderPage integration
- Display all collected order details
- Add "Confirm" button that calls `/create-order` endpoint
- Handle payment method selection (if not already selected)
- Show loading state during creation
- Navigate to HomePage on success

#### Task 4.3: Error handling
- Add error states to all BLoCs
- Handle API failures gracefully
- Show user-friendly error messages

### Phase 5: Integration with Existing Endpoints

#### Task 5.1: Map to CreateUserOrderRequest
```dart
CreateUserOrderRequest(
  token: userToken,
  fechaProgramada: selectedDate.toIso8601String(),
  pesoAproximadoKg: weightFromQuantity, // 5, 7.5, or 12 kg
  tipoDetergente: selectedDetergent, // "En polvo", "Líquido", etc.
  suavizante: softenerToggleValue,
  metodoSecado: selectedServiceType, // "secado_al_aire", "secado_mecanico"
  tipoPlanchado: selectedHangerType, // "con_gancho" or null
  numeroPrendasPlanchado: estimateFromClothesType, // TODO: calculate
  instruccionesEspeciales: clothesNote,
  paymentMethodId: selectedPaymentMethod,
  lat: selectedAddress.latitude,
  lon: selectedAddress.longitude,
  direccion: selectedAddress.fullAddress,
  fechaRecogidaPropuestaCliente: pickupTime.toIso8601String(),
  fechaEntregaPropuestaCliente: deliveryTime?.toIso8601String(),
  lavadoUrgente: false, // TODO: add express option selector
)
```

#### Task 5.2: Create OrderBloc integration
- Add event: `CreateOrderFromDetailsEvent(orderData)`
- Handle API call to `/create-order`
- On success: Navigate to HomePage
- On error: Show error dialog in ReviewOrderPage

## Tasks Breakdown for Implementation

### HIGH PRIORITY (Phase 1-2)
- [ ] **Task 1**: Add `@RoutePage()` decorator to ServiceSelectPage, ClothesScreen, GanchoPage (if needed for router)
- [ ] **Task 2**: Create unified order data model (CreateOrderData class)
- [ ] **Task 3**: Enhance ClothesBloc with TODO comments for kg mapping
- [ ] **Task 4**: Enhance GanchoBloc with tipoPlanchado mapping
- [ ] **Task 5**: Enhance WashBloc with detergent type mapping
- [ ] **Task 6**: Create/enhance PickupBloc for address and time handling
- [ ] **Task 7**: Add TODO comments for missing backend endpoints (addresses, time slots)

### MEDIUM PRIORITY (Phase 3-4)
- [ ] **Task 8**: Replace hardcoded bids in ServiceSelectPage with TODO and mock data
- [ ] **Task 9**: Implement navigation data passing between screens
- [ ] **Task 10**: Implement ReviewOrderPage integration with order data display
- [ ] **Task 11**: Implement /create-order API call in OrderBloc
- [ ] **Task 12**: Add error handling and loading states across BLoCs

### LOW PRIORITY (Phase 5 / Backend Dependent)
- [ ] **Task 13**: Integrate ServiceSelectPage with /list-available-orders endpoint
- [ ] **Task 14**: Implement user addresses retrieval
- [ ] **Task 15**: Implement delivery time slot selection

## Key Files to Modify

### BLoCs to Enhance
- `lib/features/pages/clothes/bloc/clothes_bloc.dart`
- `lib/features/pages/Gancho/bloc/gancho_bloc.dart`
- `lib/features/pages/service/bloc/service_bloc.dart`
- `lib/features/pages/washPreferences/bloc/wash_bloc.dart`
- (Create) `lib/features/pages/pickUp/bloc/pickup_bloc.dart`
- `lib/bloc/user/order_bloc.dart` (for /create-order endpoint)

### Screens to Update
- `lib/features/pages/service/service_select_page.dart` - Add TODO for list-available-orders
- `lib/features/pages/clothes/clothes_screen.dart` - Link to ClothesBloc enhancement
- `lib/features/pages/Gancho/gancho_page.dart` - Link to GanchoBloc enhancement
- `lib/features/pages/washPreferences/wash_preferences_page.dart` - Link to WashBloc enhancement
- `lib/features/pages/pickUp/pickup_schedule_page.dart` - Link to PickupBloc
- `lib/features/pages/reviewOrder/review_order_page.dart` - Add order display and create-order call

### Models to Create
- `lib/data/models/order_creation_data.dart` (CreateOrderData model for holding state)

## Notes and Assumptions

1. **Weight Estimation**: Currently no endpoint for weight estimation based on clothing types. Will use fixed values or TODO comments.

2. **Available Bids**: ServiceSelectPage currently shows hardcoded bid. May need `/list-available-orders` endpoint integration after order details are submitted.

3. **User Addresses**: Assuming addresses come from `/user-info` endpoint or will need new backend endpoint.

4. **Payment Methods**: Assuming user has already selected payment method in earlier flow.

5. **Express Options**: Not shown in current UI but present in CreateUserOrderRequest. Can be added later.

6. **Navigation**: Currently using Navigator.push() - keeping as-is to match existing design flow. Can migrate to auto_route later.

7. **Form State**: All screens use local BLoC state. Could consolidate into single OrderBloc but keeping separate for modularity.

## Success Criteria

✅ All dummy hardcoded values replaced with TODO comments or proper data binding
✅ BLoCs enhanced with proper event handling for order data collection
✅ Order creation flow integrates with /create-order endpoint
✅ All screens display collected data in ReviewOrderPage
✅ Error handling and loading states implemented
✅ App compiles without errors after running build_runner

---

**Next Step**: Review this plan and provide feedback before implementation begins.
