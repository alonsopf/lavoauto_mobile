import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lavoauto/bloc/user/addresses_bloc.dart';
import 'package:lavoauto/core/constants/assets.dart';
import 'package:lavoauto/data/models/order/order_model.dart';
import 'package:lavoauto/data/models/request/user/save_user_address_request.dart';
import 'package:lavoauto/dependencyInjection/di.dart';
import 'package:lavoauto/features/pages/service/date_time_picker_page.dart';
import 'package:lavoauto/features/pages/ironingPreferences/ironing_preferences_page.dart';
import 'package:lavoauto/features/widgets/custom_button.dart';
import 'package:lavoauto/features/widgets/custom_scaffold.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';

class PickupSchedulePage extends StatefulWidget {
  final String selectedGanchoOption;
  final String? selectedService;
  final String? selectedDate;
  final String? clothesQuantity;
  final bool? ropaDiaria;
  final bool? ropaDelicada;
  final bool? blancos;
  final bool? ropaTrabajo;
  final String? clothesNote;
  final String? selectedDetergent;
  final bool? softener;
  final String? temperature;
  final String? fragranceNote;

  const PickupSchedulePage({
    super.key,
    this.selectedGanchoOption = "Sin gancho",
    this.selectedService,
    this.selectedDate,
    this.clothesQuantity,
    this.ropaDiaria,
    this.ropaDelicada,
    this.blancos,
    this.ropaTrabajo,
    this.clothesNote,
    this.selectedDetergent,
    this.softener,
    this.temperature,
    this.fragranceNote,
  });

  @override
  State<PickupSchedulePage> createState() => _PickupSchedulePageState();
}

class _PickupSchedulePageState extends State<PickupSchedulePage> {
  // State variables
  String selectedAddressTitle = "Casa"; // Casa, Trabajo, or custom address
  String selectedPickupTime = "10 de abril de 2024"; // Default
  String selectedPickupTimeRange = "Entre 7:00 y 8:00 p.m.";
  String selectedDeliveryTime = "Lo antes posible";
  String? selectedUrgency; // sin urgencia, urgente, etc.
  int? selectedAddressId; // To track the actual address ID
  late AddressesBloc _addressesBloc; // Store reference to the BLoC

  @override
  void initState() {
    super.initState();
    // Fetch user addresses after first frame when BlocProvider is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _addressesBloc = context.read<AddressesBloc>();
        _addressesBloc.add(FetchAddressesEvent());
      }
    });
  }

  void _selectPickupTime() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => const DateTimePickerPage(),
      ),
    );

    if (result != null) {
      setState(() {
        selectedPickupTime = result;
        // TODO: Extract time range from result if needed
      });
    }
  }

  void _selectDeliveryTime() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => const DateTimePickerPage(),
      ),
    );

    if (result != null) {
      setState(() {
        selectedDeliveryTime = result;
      });
    }
  }

  void _showAddAddressDialog() {
    final addressesBloc = context.read<AddressesBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => AddAddressDialog(
        addressesBloc: addressesBloc,
        onAddAddress: (addressTitle) {
          // Address has been added, update the selected address
          setState(() {
            selectedAddressTitle = addressTitle;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AddressesBloc>(
      create: (context) => AppContainer.getIt.get<AddressesBloc>(),
      child: CustomScaffold(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 28),
              const Center(
                child: Text(
                  "¿Dónde y cuándo\npasamos por tu ropa?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryNewDark,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              BlocBuilder<AddressesBloc, AddressesState>(
                builder: (context, state) {
                  return _card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Dirección",
                          style: TextStyle(
                            fontSize: 22,
                            color: AppColors.primaryNewDark,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 14),
                        if (state is AddressesLoading)
                          const Center(
                            child: CircularProgressIndicator(),
                          )
                        else if (state is AddressesLoaded)
                          ...state.addresses.map((address) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _buildAddressOption(
                                address.etiqueta ?? address.tipo,
                                Assets.home,
                                onTap: () {
                                  setState(() {
                                    selectedAddressTitle =
                                        address.etiqueta ?? address.tipo;
                                    selectedAddressId = address.id;
                                  });
                                },
                                isSelected: selectedAddressId == address.id,
                              ),
                            );
                          }).toList()
                        else
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: _buildAddressOption(
                              "Casa",
                              Assets.home,
                              onTap: () {
                                setState(() {
                                  selectedAddressTitle = "Casa";
                                  selectedAddressId = null;
                                });
                              },
                              isSelected: selectedAddressId == null &&
                                  selectedAddressTitle == "Casa",
                            ),
                          ),
                        const SizedBox(height: 14),
                        GestureDetector(
                          onTap: _showAddAddressDialog,
                          child: const Text(
                            "Agregar nueva dirección",
                            style: TextStyle(
                              fontSize: 20,
                              color: AppColors.primaryNewDark,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            const SizedBox(height: 20),
            _card(
              child: GestureDetector(
                onTap: _selectPickupTime,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Horario de recolección",
                      style: TextStyle(
                        fontSize: 22,
                        color: AppColors.primaryNewDark,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          Assets.calenderSvg,
                          color: AppColors.primaryNewDark,
                          height: 26,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedPickupTime,
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: AppColors.primaryNewDark,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                selectedPickupTimeRange,
                                style: const TextStyle(
                                  color: AppColors.primaryNewDark,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 18,
                          color: AppColors.primaryNewDark,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Horario de entrega",
                    style: TextStyle(
                      fontSize: 22,
                      color: AppColors.primaryNewDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: _selectDeliveryTime,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          Assets.time,
                          color: AppColors.primaryNewDark,
                          height: 26,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                selectedDeliveryTime,
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: AppColors.primaryNewDark,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (selectedDeliveryTime != "Lo antes posible")
                                const Text(
                                  "Elegir fecha y hora",
                                  style: TextStyle(
                                    color: AppColors.primaryNewDark,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.primaryNewDark,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(height: 1, color: AppColors.borderGrey),
                  const SizedBox(height: 20),
                  const Text(
                    "Opciones (tarifa más elevada)",
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.primaryNewDark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _urgencyOption("sin urgencia", selectedUrgency == null || selectedUrgency == "sin urgencia"),
                  const SizedBox(height: 10),
                  _urgencyOption("urgente", selectedUrgency == "urgente"),
                  const SizedBox(height: 10),
                  _urgencyOption("etc.", selectedUrgency == "etc."),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    title: "Atrás",
                    isPrimary: false,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: CustomButton(
                    title: "Continuar",
                    isPrimary: true,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => IroningPreferencesPage(
                            selectedService: widget.selectedService,
                            selectedDate: widget.selectedDate,
                            clothesQuantity: widget.clothesQuantity,
                            ropaDiaria: widget.ropaDiaria,
                            ropaDelicada: widget.ropaDelicada,
                            blancos: widget.blancos,
                            ropaTrabajo: widget.ropaTrabajo,
                            clothesNote: widget.clothesNote,
                            selectedDetergent: widget.selectedDetergent,
                            softener: widget.softener,
                            temperature: widget.temperature,
                            fragranceNote: widget.fragranceNote,
                            selectedAddressTitle: selectedAddressTitle,
                            selectedAddressId: selectedAddressId,
                            selectedPickupTime: selectedPickupTime,
                            selectedPickupTimeRange: selectedPickupTimeRange,
                            selectedDeliveryTime: selectedDeliveryTime,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    ),
    );
  }

  Widget _buildAddressOption(
    String title,
    String icon, {
    VoidCallback? onTap,
    bool isSelected = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryNewDark.withValues(alpha: 0.1)
              : Colors.grey.shade100,
          border: Border.all(
            color: isSelected ? AppColors.primaryNewDark : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              height: 22,
              color: AppColors.primaryNewDark,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.primaryNewDark,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryNewDark,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  Widget _urgencyOption(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedUrgency = title == "sin urgencia" ? null : title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryNew.withOpacity(0.1) : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryNew : AppColors.borderGrey,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primaryNew : AppColors.borderGrey,
                  width: 2,
                ),
                color: isSelected ? AppColors.primaryNew : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? AppColors.primaryNew : AppColors.primaryNewDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
  }
}

class AddAddressDialog extends StatefulWidget {
  final Function(String) onAddAddress;
  final AddressesBloc addressesBloc;

  const AddAddressDialog({
    required this.onAddAddress,
    required this.addressesBloc,
    super.key,
  });

  @override
  State<AddAddressDialog> createState() => _AddAddressDialogState();
}

class _AddAddressDialogState extends State<AddAddressDialog> {
  final _formKey = GlobalKey<FormState>();
  final _etiquetaController = TextEditingController();
  final _calleController = TextEditingController();
  final _numeroExteriorController = TextEditingController();
  final _numeroInteriorController = TextEditingController();
  final _coloniaController = TextEditingController();
  final _ciudadController = TextEditingController();
  final _estadoController = TextEditingController();
  final _codigoPostalController = TextEditingController();
  final _descripcionController = TextEditingController();

  String _selectedType = "Casa";
  bool _esPredeterminada = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _etiquetaController.dispose();
    _calleController.dispose();
    _numeroExteriorController.dispose();
    _numeroInteriorController.dispose();
    _coloniaController.dispose();
    _ciudadController.dispose();
    _estadoController.dispose();
    _codigoPostalController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  void _submitAddress() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final token = Utils.getAuthenticationToken();
        debugPrint("🔐 Debug: Retrieved token from Utils: '$token'");
        debugPrint("🔐 Debug: Token is empty: ${token.isEmpty}");
        debugPrint("🔐 Debug: Token length: ${token.length}");

        if (token.isEmpty) {
          _showError("No se encontró token de autenticación");
          setState(() => _isLoading = false);
          return;
        }

        // Create the address request with all required fields
        final request = SaveUserAddressRequest(
          token: token,
          tipo: _selectedType,
          etiqueta: _etiquetaController.text.isEmpty ? _selectedType : _etiquetaController.text,
          calle: _calleController.text,
          numero_exterior: _numeroExteriorController.text,
          numero_interior: _numeroInteriorController.text,
          colonia: _coloniaController.text,
          ciudad: _ciudadController.text,
          estado: _estadoController.text,
          codigo_postal: _codigoPostalController.text,
          lat: 0.0, // Default value - can be enhanced with map integration
          lon: 0.0, // Default value - can be enhanced with map integration
          es_predeterminada: _esPredeterminada,
          descripcion_adicional: _descripcionController.text,
        );

        debugPrint("🔐 Debug: SaveUserAddressRequest created with all fields");
        debugPrint("🔐 Address data: tipo=$_selectedType, calle=${_calleController.text}, colonia=${_coloniaController.text}");

        // Add the event to the BLoC
        widget.addressesBloc.add(SaveAddressEvent(request));

        // Listen for the response
        widget.addressesBloc.stream.listen((state) {
          if (!mounted) return;

          if (state is AddressesSaved) {
            widget.onAddAddress(_selectedType);
            if (mounted) Navigator.pop(context);
          } else if (state is AddressesError) {
            _showError(state.message);
            if (mounted) setState(() => _isLoading = false);
          }
        });
      } catch (e) {
        _showError("Error al agregar dirección: $e");
        setState(() => _isLoading = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isRequired,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isRequired ? "$label *" : label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryNewDark,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          validator: isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return "$label es requerido";
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Agregar nueva dirección",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryNewDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Los campos con * son obligatorios",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tipo de dirección
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Tipo de dirección *",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primaryNewDark,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: _selectedType,
                            isExpanded: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            items: ["Casa", "Trabajo", "Otro"]
                                .map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  _selectedType = newValue;
                                });
                              }
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Selecciona un tipo de dirección";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Etiqueta (optional label)
                      _buildTextField(
                        controller: _etiquetaController,
                        label: "Etiqueta",
                        hint: "Ej: Casa de mis papás",
                        isRequired: false,
                      ),
                      const SizedBox(height: 16),

                      // Calle
                      _buildTextField(
                        controller: _calleController,
                        label: "Calle",
                        hint: "Ej: Avenida Principal",
                        isRequired: true,
                      ),
                      const SizedBox(height: 16),

                      // Número Exterior
                      _buildTextField(
                        controller: _numeroExteriorController,
                        label: "Número Exterior",
                        hint: "Ej: 123",
                        isRequired: true,
                      ),
                      const SizedBox(height: 16),

                      // Número Interior
                      _buildTextField(
                        controller: _numeroInteriorController,
                        label: "Número Interior",
                        hint: "Ej: Apto 5B",
                        isRequired: false,
                      ),
                      const SizedBox(height: 16),

                      // Colonia
                      _buildTextField(
                        controller: _coloniaController,
                        label: "Colonia",
                        hint: "Ej: Centro",
                        isRequired: true,
                      ),
                      const SizedBox(height: 16),

                      // Ciudad
                      _buildTextField(
                        controller: _ciudadController,
                        label: "Ciudad",
                        hint: "Ej: Monterrey",
                        isRequired: false,
                      ),
                      const SizedBox(height: 16),

                      // Estado
                      _buildTextField(
                        controller: _estadoController,
                        label: "Estado",
                        hint: "Ej: Nuevo León",
                        isRequired: false,
                      ),
                      const SizedBox(height: 16),

                      // Código Postal
                      _buildTextField(
                        controller: _codigoPostalController,
                        label: "Código Postal",
                        hint: "Ej: 64000",
                        isRequired: false,
                      ),
                      const SizedBox(height: 16),

                      // Descripción Adicional
                      _buildTextField(
                        controller: _descripcionController,
                        label: "Descripción Adicional",
                        hint: "Ej: Junto a la farmacia",
                        isRequired: false,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),

                      // Es predeterminada checkbox
                      Row(
                        children: [
                          Checkbox(
                            value: _esPredeterminada,
                            onChanged: (value) {
                              setState(() {
                                _esPredeterminada = value ?? false;
                              });
                            },
                            activeColor: AppColors.primaryNewDark,
                          ),
                          const Text(
                            "Usar como dirección predeterminada",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryNewDark,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Cancelar",
                        style: TextStyle(
                          color: AppColors.primaryNewDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryNewDark,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: _isLoading ? null : _submitAddress,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              "Agregar",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
