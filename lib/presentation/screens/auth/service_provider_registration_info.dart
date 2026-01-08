import 'dart:convert';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lavoauto/bloc/bloc/auth_bloc.dart';
import 'package:lavoauto/core/constants/app_strings.dart';
import 'package:lavoauto/presentation/common_widgets/custom_text.dart';
import 'package:lavoauto/presentation/common_widgets/primary_button.dart';
import 'package:lavoauto/presentation/router/router.gr.dart' as routeFiles;
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/marginUtils/margin_imports.dart';

import '../../../core/constants/assets.dart';
import '../../../data/models/request/worker/register_modal.dart';
import '../../../theme/apptheme.dart';
import '../../../utils/loadersUtils/LoaderClass.dart';
import '../../../utils/utils.dart';
import '../../common_widgets/image_.dart';
import '../../common_widgets/privacy_policy_checkbox.dart';
import '../../common_widgets/text_field.dart';

@RoutePage()
class ServiceProviderRegistrationInfoScreen extends StatefulWidget {
  const ServiceProviderRegistrationInfoScreen({super.key});

  @override
  State<ServiceProviderRegistrationInfoScreen> createState() => _ServiceProviderRegistrationInfoScreenState();
}

class _ServiceProviderRegistrationInfoScreenState extends State<ServiceProviderRegistrationInfoScreen> {
  // Store all controllers in a list
  final List<TextEditingController> _controllers = List.generate(15, (_) => TextEditingController());

  // Create FocusNodes for navigation between fields
  final List<FocusNode> _focusNodes = List.generate(15, (_) => FocusNode());

  List<String> _coloniaOptions = [];
  bool _isLoadingColonias = false;
  bool _isPrivacyPolicyAccepted = false;

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  TextEditingController getControllerbyIndex(int index) {
    return _controllers[index];
  }

  void _moveToNextField(int currentIndex) {
    // Skip colonia field (index 1) as it's a dropdown
    int nextIndex = currentIndex + 1;
    if (nextIndex == 1) nextIndex = 2; // Skip dropdown

    if (nextIndex < _focusNodes.length) {
      FocusScope.of(context).requestFocus(_focusNodes[nextIndex]);
    } else {
      // Last field, close keyboard
      FocusScope.of(context).unfocus();
    }
  }

  TextInputAction _getTextInputAction(int index) {
    // Last meaningful field should have "done"
    if (index >= 14) return TextInputAction.done;
    // Skip next if it's the dropdown (colonia)
    if (index == 0) return TextInputAction.next; // Will skip to index 2
    return TextInputAction.next;
  }

  Future<void> _fetchColoniasByZip(String postalCode) async {
    debugPrint('🏠 [Service Provider] Fetching colonias for postal code: $postalCode');

    if (postalCode.length != 5) {
      debugPrint('❌ [Service Provider] Postal code length is not 5: ${postalCode.length}');
      return;
    }

    setState(() {
      _isLoadingColonias = true;
      _coloniaOptions = [];
      // Clear the colonia field when postal code changes
      _controllers[1].clear();
    });

    try {
      final url = 'https://xscuh60ayi.execute-api.mx-central-1.amazonaws.com/prod/zip?zip=$postalCode';
      debugPrint('🌐 [Service Provider] Calling API: $url');

      final response = await http.get(Uri.parse(url));

      debugPrint('📡 [Service Provider] Response status: ${response.statusCode}');
      debugPrint('📡 [Service Provider] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        if (data['results'] != null) {
          final int allow = data['allow'] ?? 0;

          if (allow == 0) {
            // Show alert for unsupported zone
            debugPrint('⚠️ [Service Provider] Zone not supported (allow = 0)');
            if (mounted) {
              Utils.showAlert(
                title: 'Zona no soportada',
                message: "Tu zona no está soportada aún. Pronto estaremos disponibles en tu área.",
                context: context,
              );
            }
            return;
          }

          final List<dynamic> results = data['results'];
          if (results.isNotEmpty) {
            // Get city and state from first result (they should all be the same)
            final firstResult = results.first;
            final ciudad = firstResult['d_mnpio']?.toString() ?? '';
            final estado = firstResult['d_estado']?.toString() ?? '';

            // Extract all colonias
            final colonias = results.map((item) => item['d_asenta'].toString()).toSet().toList();

            debugPrint('✅ [Service Provider] Found ${colonias.length} colonias: $colonias');
            debugPrint('🏙️ [Service Provider] Ciudad: $ciudad, Estado: $estado');

            setState(() {
              _coloniaOptions = colonias;
              // Auto-populate city and state fields
              _controllers[13].text = ciudad; // City field
              _controllers[14].text = estado; // State field
            });
          }
        } else {
          debugPrint('❌ [Service Provider] API returned no results');
        }
      } else {
        debugPrint('❌ [Service Provider] HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('💥 [Service Provider] Error fetching colonias: $e');
    } finally {
      setState(() {
        _isLoadingColonias = false;
      });
    }
  }

  Icon _getIcon(int index) {
    switch (index) {
      case 0:
        return const Icon(Icons.location_on_outlined, color: AppColors.secondary);
      case 1:
        return const Icon(Icons.map_outlined, color: AppColors.secondary);
      case 2:
        return const Icon(Icons.email_outlined, color: AppColors.secondary);
      case 3:
        return const Icon(Icons.lock_outline, color: AppColors.secondary);
      case 4:
        return const Icon(Icons.lock_reset, color: AppColors.secondary);
      case 5:
        return const Icon(Icons.phone_outlined, color: AppColors.secondary);
      case 6:
        return const Icon(Icons.person_outline, color: AppColors.secondary);
      case 7:
        return const Icon(Icons.person_outline, color: AppColors.secondary);
      case 8:
        return const Icon(Icons.badge_outlined, color: AppColors.secondary);
      case 9:
        return const Icon(Icons.account_balance_outlined, color: AppColors.secondary);
      case 10:
        return const Icon(Icons.home_outlined, color: AppColors.secondary);
      case 11:
        return const Icon(Icons.confirmation_number_outlined, color: AppColors.secondary);
      case 12:
        return const Icon(Icons.tag_outlined, color: AppColors.secondary);
      case 13:
        return const Icon(Icons.location_city_outlined, color: AppColors.secondary);
      case 14:
        return const Icon(Icons.map_outlined, color: AppColors.secondary);
      default:
        return const Icon(Icons.edit, color: AppColors.secondary);
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic loader = Loader.getLoader(context);
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => context.router.maybePop(),
        ),
        title: CustomText(
          text: "Registro Proveedor",
          fontColor: AppColors.white,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ).setText(),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned(
            top: -140,
            left: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withOpacity(0.25),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 3.2,
            right: -90,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -140,
            left: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withOpacity(0.25),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: BlocConsumer<AuthBloc, AuthState>(
                buildWhen: (context, state) {
                  return true; // Allow all state changes to trigger rebuild
                },
                listener: (context, state) {
                  debugPrint("service provider info state: $state");
                  if (state is AuthRegistrationFailure) {
                    Loader.hideLoader(loader);
                    Utils.showAlert(
                      title: 'Error de registro',
                      message: state.error,
                      context: context,
                      onSuccess: () {
                        // Reset state after error dialog
                        context.read<AuthBloc>().add(const AuthInitialEvent());
                      },
                    );
                    return;
                  } else if (state is AuthRegistrationSuccess) {
                    Loader.hideLoader(loader);

                    // Check if this is a profile image upload success
                    if (state.profileImageUrl != null && state.userRegistrationResponse == null) {
                      debugPrint("✅ [ServiceProvider] Profile image uploaded successfully: ${state.profileImageUrl}");
                      Utils.showAlert(
                        title: 'Imagen subida',
                        message: 'La imagen de perfil se ha subido correctamente.',
                        context: context,
                        onSuccess: () {
                          // Keep the current state but ensure UI updates properly
                          // Don't reset to initial since we need to keep the image data
                        },
                      );
                      return;
                    }

                    // Check if this is a registration success
                    if (state.userRegistrationResponse != null) {
                      debugPrint("✅ [ServiceProvider] Registration completed successfully");
                      Utils.showAlert(
                        title: 'Registro exitoso',
                        message:
                            'Su registro se ha completado correctamente. Por favor ingrese su correo y contraseña para continuar.',
                        context: context,
                        onSuccess: () {
                          debugPrint("🔄 [ServiceProvider] Navigating to login after successful registration");
                          context.router.replaceAll([routeFiles.LoginRoute()]);
                        },
                      );
                      return;
                    }
                  } else if (state is AuthRegistrationLoading) {
                    debugPrint("🔄 [ServiceProvider] Loading state - showing loader");
                    Loader.insertLoader(context, loader);
                    return;
                  } else if (state is AuthInitialLoading) {
                    Loader.insertLoader(context, loader);
                    return;
                  }
                },
                builder: (context, state) {
                  debugPrint("state: $state");
                  if (state is AuthRegistrationSuccess) {
                    debugPrint("state Profile Image URL: ${state.profileImageUrl}");
                    debugPrint("state Profile Image Path: ${state.profileImage?.path}");
                  }
                  return ListView(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      const YMargin(20.0),
                      _glassCard(
                        child: Column(
                          children: [
                            _sectionTitle("Datos Personales"),
                            const YMargin(16),
                            if (state is AuthRegistrationSuccess && state.profileImage != null) ...[
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.secondary,
                                    width: 3.0,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.secondary.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                    radius: 50.0,
                                    backgroundColor: AppColors.white,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50.0),
                                      child: Image.file(
                                        File(
                                          state.profileImage?.path ?? '',
                                        ),
                                        errorBuilder: (context, error, stackTrace) {
                                          return ImagesPng.assetPNG(
                                            Assets.placeholderAddPhoto,
                                            height: 100.0,
                                            width: 100.0,
                                          );
                                        },
                                        height: 100.0,
                                        width: 100.0,
                                      ),
                                    )),
                              ),
                            ] else ...[
                              InkWell(
                                onTap: () async {
                                  if (await Utils.permissionSetting()) {
                                    if (!context.mounted) return;
                                    await Utils.submitProfile(context, () async {
                                      XFile? image = await Utils.getImage(isCamera: true);
                                      if (context.mounted) {
                                        context.router.maybePop();
                                        FocusScope.of(context).unfocus(); // Close the keyboard
                                      }
                                      if (image != null) {
                                        if (context.mounted) {
                                          debugPrint(
                                              "🖼️ [ServiceProvider] Image selected, dispatching GetProfileUrlEvent");
                                          context.read<AuthBloc>().add(
                                                GetProfileUrlEvent(isUser: false, profileImage: image),
                                              );
                                        }
                                      }
                                    }, () async {
                                      XFile? image = await Utils.getImage();
                                      if (context.mounted) {
                                        context.router.maybePop();
                                        FocusScope.of(context).unfocus(); // Close the keyboard
                                      }
                                      if (image != null) {
                                        if (context.mounted) {
                                          debugPrint(
                                              "🖼️ [ServiceProvider] Image selected from gallery, dispatching GetProfileUrlEvent");
                                          context.read<AuthBloc>().add(
                                                GetProfileUrlEvent(isUser: false, profileImage: image),
                                              );
                                        }
                                      }
                                    });
                                  } else {
                                    if (context.mounted) {
                                      await Utils.showPermissionDialog(context);
                                    }
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.secondary,
                                      width: 3.0,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.secondary.withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ImagesPng.assetPNG(
                                    Assets.placeholderAddPhoto,
                                    height: 100.0,
                                    width: 100.0,
                                  ),
                                ),
                              )
                            ],
                            const YMargin(16.0),
                            _buildTextField(
                              context: context,
                              index: 6,
                              hintText: getTitlebyIndex(6),
                              controller: getControllerbyIndex(6),
                            ),
                            _buildTextField(
                              context: context,
                              index: 7,
                              hintText: getTitlebyIndex(7),
                              controller: getControllerbyIndex(7),
                            ),
                            _buildTextField(
                              context: context,
                              index: 5,
                              hintText: getTitlebyIndex(5),
                              controller: getControllerbyIndex(5),
                            ),
                          ],
                        ),
                      ),
                      const YMargin(16),
                      _glassCard(
                        child: Column(
                          children: [
                            _sectionTitle("Datos Fiscales"),
                            const YMargin(12),
                            _buildTextField(
                              context: context,
                              index: 8,
                              hintText: getTitlebyIndex(8),
                              controller: getControllerbyIndex(8),
                            ),
                            _buildTextField(
                              context: context,
                              index: 9,
                              hintText: getTitlebyIndex(9),
                              controller: getControllerbyIndex(9),
                            ),
                          ],
                        ),
                      ),
                      const YMargin(16),
                      _glassCard(
                        child: Column(
                          children: [
                            _sectionTitle("Dirección"),
                            const YMargin(12),
                            _buildTextField(
                              context: context,
                              index: 0,
                              hintText: getTitlebyIndex(0),
                              controller: getControllerbyIndex(0),
                            ),
                            _buildTextField(
                              context: context,
                              index: 1,
                              hintText: getTitlebyIndex(1),
                              controller: getControllerbyIndex(1),
                            ),
                            _buildTextField(
                              context: context,
                              index: 10,
                              hintText: getTitlebyIndex(10),
                              controller: getControllerbyIndex(10),
                            ),
                            _buildTextField(
                              context: context,
                              index: 11,
                              hintText: getTitlebyIndex(11),
                              controller: getControllerbyIndex(11),
                            ),
                            _buildTextField(
                              context: context,
                              index: 12,
                              hintText: getTitlebyIndex(12),
                              controller: getControllerbyIndex(12),
                            ),
                            _buildTextField(
                              context: context,
                              index: 13,
                              hintText: getTitlebyIndex(13),
                              controller: getControllerbyIndex(13),
                            ),
                            _buildTextField(
                              context: context,
                              index: 14,
                              hintText: getTitlebyIndex(14),
                              controller: getControllerbyIndex(14),
                            ),
                          ],
                        ),
                      ),
                      const YMargin(16),
                      _glassCard(
                        child: Column(
                          children: [
                            _sectionTitle("Credenciales"),
                            const YMargin(12),
                            _buildTextField(
                              context: context,
                              index: 2,
                              hintText: getTitlebyIndex(2),
                              controller: getControllerbyIndex(2),
                            ),
                            _buildTextField(
                              context: context,
                              index: 3,
                              hintText: getTitlebyIndex(3),
                              controller: getControllerbyIndex(3),
                            ),
                            _buildTextField(
                              context: context,
                              index: 4,
                              hintText: getTitlebyIndex(4),
                              controller: getControllerbyIndex(4),
                            ),
                          ],
                        ),
                      ),
                      const YMargin(16),
                      _glassCard(
                        child: Column(
                          children: [
                            const YMargin(5.0),
                            // Removed checkboxes for washer/dryer and transport services
                            const YMargin(10.0),
                            PrivacyPolicyCheckbox(
                              isChecked: _isPrivacyPolicyAccepted,
                              onChanged: (value) {
                                setState(() {
                                  _isPrivacyPolicyAccepted = value ?? false;
                                });
                              },
                              isUser: false,
                            ),
                            const YMargin(20.0),
                            SizedBox(
                              width: double.infinity,
                              child: PrimaryButton.secondaryIconbutton(
                                color: (state is AuthRegistrationLoading)
                                    ? AppColors.secondary.withOpacity(0.6)
                                    : AppColors.secondary,
                                text: (state is AuthRegistrationLoading) ? 'Registrando...' : AppStrings.save,
                                onpressed: (state is AuthRegistrationLoading)
                                    ? null
                                    : () {
                                        FocusScope.of(context).unfocus(); // Close the keyboard

                                        // Prevent multiple calls - only allow if not currently loading
                                        if (state is! AuthRegistrationLoading) {
                                          // Get profile image from current state if available
                                          XFile? profileImage;
                                          if (state is AuthRegistrationSuccess) {
                                            profileImage = state.profileImage;
                                          }

                                          if (validateFields() && validatePrivacyPolicy()) {
                                            // Check if profile image URL is available
                                            String? imageUrl;
                                            if (state is AuthRegistrationSuccess) {
                                              imageUrl = state.profileImageUrl;
                                              debugPrint(
                                                  "🔍 [ServiceProvider] Current state profileImageUrl: '$imageUrl'");
                                            } else {
                                              debugPrint(
                                                  "🔍 [ServiceProvider] Current state is not AuthRegistrationSuccess: ${state.runtimeType}");
                                            }

                                            if (imageUrl == null || imageUrl.isEmpty) {
                                              debugPrint(
                                                  "❌ [ServiceProvider] Image URL validation failed: imageUrl='$imageUrl'");
                                              Utils.showAlert(
                                                title: 'Error de validación',
                                                message:
                                                    "Por favor seleccione y suba una imagen de perfil antes de continuar. La imagen es requerida para prestadores de servicio.",
                                                context: context,
                                              );
                                              return;
                                            }

                                            debugPrint("✅ [ServiceProvider] Image URL validation passed: '$imageUrl'");

                                            final registerLavadorRequest = RegisterLavadorRequest(
                                              clabe: _controllers[9].text.trim(),
                                              nombre: _controllers[6].text.trim(),
                                              apellidos: _controllers[7].text.trim(),
                                              rfc: _controllers[8].text.trim(),
                                              email: _controllers[2].text.trim(),
                                              calle: _controllers[10].text.trim(),
                                              numeroexterior: _controllers[11].text.trim(),
                                              numerointerior: _controllers[12].text.trim().isEmpty
                                                  ? null
                                                  : _controllers[12].text.trim(),
                                              colonia: _controllers[1].text.trim(),
                                              ciudad: _controllers[13].text.trim(),
                                              estado: _controllers[14].text.trim(),
                                              codigoPostal: _controllers[0].text.trim(),
                                              lat: 0.0, // Replace with actual latitude logic
                                              lon: 0.0, // Replace with actual longitude logic
                                              telefono: _controllers[5].text.trim(),
                                              fotoUrl: imageUrl,
                                              passwordHash: _controllers[3].text.trim(),
                                            );

                                            context.read<AuthBloc>().add(
                                                  RegistrationEvent(
                                                    isUser: false,
                                                    workerRegistrationModel: registerLavadorRequest,
                                                    profileImage: profileImage,
                                                  ),
                                                );
                                          }
                                        }
                                      },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const YMargin(16),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String title) {
    return Row(
      children: [
        Container(width: 4, height: 20, color: AppColors.secondary, margin: const EdgeInsets.only(right: 10)),
        CustomText(text: title, fontColor: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold).setText(),
      ],
    );
  }

  bool validateFields() {
    for (int i = 0; i < _controllers.length; i++) {
      final value = _controllers[i].text.trim();
      switch (i) {
        case 0: // Código Postal
          if (value.isEmpty || value.length != 5) {
            Utils.showAlert(
                title: 'Error de validación',
                message: "Por favor ingrese un código postal válido de 5 dígitos",
                context: context);
            return false;
          }
          break;
        case 1: // Colonia
          if (value.isEmpty) {
            Utils.showAlert(
                title: 'Error de validación', message: "Por favor seleccione una colonia", context: context);
            return false;
          }
          break;
        case 2: // Correo Electrónico
          if (value.isEmpty) {
            Utils.showAlert(
                title: 'Error de validación',
                message: "Por favor ingrese un correo electrónico válido",
                context: context);
            return false;
          }
          break;
        case 3: // Contraseña
          if (value.isEmpty || value.length < 6) {
            Utils.showAlert(
                title: 'Error de validación',
                message: "La contraseña debe tener al menos 6 caracteres",
                context: context);
            return false;
          }
          break;
        case 4: // Confirmar Contraseña
          if (value.isEmpty || value != _controllers[3].text.trim()) {
            Utils.showAlert(title: 'Error de validación', message: "Las contraseñas no coinciden", context: context);
            return false;
          }
          break;
        case 5: // Teléfono
          if (value.isEmpty) {
            Utils.showAlert(title: 'Error de validación', message: "Por favor ingrese su teléfono", context: context);
            return false;
          }
          break;
        case 6: // Nombre
          if (value.isEmpty) {
            Utils.showAlert(title: 'Error de validación', message: "Por favor ingrese su nombre", context: context);
            return false;
          }
          break;
        case 7: // Apellidos
          if (value.isEmpty) {
            Utils.showAlert(title: 'Error de validación', message: "Por favor ingrese sus apellidos", context: context);
            return false;
          }
          break;
        case 8: // RFC - MANDATORY for service providers
          if (value.isEmpty) {
            Utils.showAlert(title: 'Error de validación', message: "Por favor ingrese su RFC", context: context);
            return false;
          }
          break;
        case 9: // CLABE - MANDATORY for service providers
          if (value.isEmpty || value.length != 18) {
            Utils.showAlert(title: 'Error de validación', message: "La CLABE debe tener 18 dígitos", context: context);
            return false;
          }
          break;
        case 10: // Calle
          if (value.isEmpty) {
            Utils.showAlert(title: 'Error de validación', message: "Por favor ingrese su calle", context: context);
            return false;
          }
          break;
        case 11: // Número Exterior
          if (value.isEmpty) {
            Utils.showAlert(
                title: 'Error de validación', message: "Por favor ingrese su número exterior", context: context);
            return false;
          }
          break;
        case 12: // Número Interior - Optional for service providers
          // No validation needed - interior number is optional
          break;
        case 13: // Ciudad
          if (value.isEmpty) {
            Utils.showAlert(title: 'Error de validación', message: "Por favor ingrese una ciudad", context: context);
            return false;
          }
          break;
        case 14: // Estado
          if (value.isEmpty) {
            Utils.showAlert(title: 'Error de validación', message: "Por favor ingrese un estado", context: context);
            return false;
          }
          break;
        default:
          break;
      }
    }
    return true;
  }

  bool validatePrivacyPolicy() {
    if (!_isPrivacyPolicyAccepted) {
      Utils.showAlert(
        title: 'Error de validación',
        message: "Debes aceptar las Políticas de Privacidad y Condiciones de Uso para continuar",
        context: context,
      );
      return false;
    }
    return true;
  }

  String getTitlebyIndex(int index) {
    switch (index) {
      case 0:
        return AppStrings.postalCode;
      case 1:
        return AppStrings.neighborhood;
      case 2:
        return AppStrings.email;
      case 3:
        return AppStrings.password;
      case 4:
        return AppStrings.confirmPassword;
      case 5:
        return "Teléfono";
      case 6:
        return AppStrings.firstName;
      case 7:
        return AppStrings.lastName;
      case 8:
        return AppStrings.rfc;
      case 9:
        return AppStrings.clabe;
      case 10:
        return AppStrings.street;
      case 11:
        return AppStrings.exteriorNumber;
      case 12:
        return AppStrings.interiorNumber;
      case 13:
        return AppStrings.city;
      case 14:
        return AppStrings.state;
      default:
        return '';
    }
  }

  Widget _buildTextField({
    required int index,
    required BuildContext context,
    required String hintText,
    required TextEditingController controller,
  }) {
    if (index == 1) {
      // Render a dropdown for Neighborhood
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: DropdownButtonFormField<String>(
          value: controller.text.isNotEmpty ? controller.text : null,
          padding: EdgeInsets.zero,
          isDense: true,
          alignment: Alignment.centerLeft,
          items: _coloniaOptions.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: CustomText(
                text: item,
                fontColor: AppColors.black,
                textAlign: TextAlign.left,
                fontWeight: FontWeight.w500,
              ).setText(),
            );
          }).toList(),
          onChanged: (value) {
            controller.text = value ?? '';
          },
          iconSize: 16.0,
          decoration: InputDecoration(
            prefixIcon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: _getIcon(index),
            ),
            hintText: _isLoadingColonias
                ? 'Cargando colonias...'
                : _coloniaOptions.isNotEmpty
                    ? 'Seleccione una colonia'
                    : hintText,
            hintStyle: AppTheme.theme.textTheme.bodyMedium?.copyWith(
              fontSize: 20.0,
              color: AppColors.greyNormalColor,
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: AppColors.white,
            counter: const Offstage(),
            isCollapsed: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      );
    } else {
      // Render a regular text field for other indices
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: CustomTextFieldWidget(
          controller: controller,
          focusNode: _focusNodes[index],
          textInputAction: _getTextInputAction(index),
          onFieldSubmitted: (_) => _moveToNextField(index),
          maxLength: index == 0 ? 5 : (index == 9 ? 18 : 100), // Postal code: 5, CLABE: 18, others: 100
          keyboardType: (index == 0 || index == 5 || index == 9)
              ? TextInputType.number
              : (index == 2)
                  ? TextInputType.emailAddress
                  : null, // Set email keyboard for email field, numeric for postal code, phone, and CLABE
          isVisible: index != 3 && index != 4, // Hide password fields
          readOnly: index == 13 || index == 14, // Make city and state read-only
          prefixWidget: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: _getIcon(index),
          ),
          onChanged: index == 0
              ? (value) {
                  if (value.length == 5) {
                    _fetchColoniasByZip(value.trim());
                  } else if (value.length < 5) {
                    // Clear colonias if postal code is incomplete
                    setState(() {
                      _coloniaOptions = [];
                      _controllers[1].clear();
                      // Clear city and state when postal code changes
                      _controllers[13].clear();
                      _controllers[14].clear();
                    });
                  }
                }
              : null,
          hintText: hintText,
        ),
      );
    }
  }
}
