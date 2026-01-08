import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lavoauto/bloc/bloc/user_info_bloc.dart';
import 'package:lavoauto/core/constants/app_strings.dart';
import 'package:lavoauto/data/models/request/auth/delete_account_modal.dart';
import 'package:lavoauto/data/models/request/user/update_user_info_modal.dart';
import 'package:lavoauto/data/models/request/worker/update_worker_info_modal.dart';
import 'package:lavoauto/data/models/response/auth/profile_image_response_modal.dart';
import 'package:lavoauto/data/models/response/auth/user_worker_info_modal.dart';
import 'package:lavoauto/data/repositories/auth_repo.dart';
import 'package:lavoauto/data/repositories/user_repo.dart';
import 'package:lavoauto/data/repositories/worker_repo.dart';
import 'package:lavoauto/presentation/common_widgets/custom_text.dart';
import 'package:lavoauto/presentation/common_widgets/primary_button.dart';
import 'package:lavoauto/presentation/common_widgets/profile_image_widget.dart';
import 'package:lavoauto/presentation/router/router.gr.dart' as routeFiles;
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/image_utils.dart';
import 'package:lavoauto/utils/marginUtils/margin_imports.dart';
import 'package:lavoauto/utils/utils.dart';

import '../../common_widgets/app_bar.dart';
import '../../common_widgets/custom_drawer.dart';
import '../../common_widgets/text_field.dart';
import '../../../../data/models/api_response.dart';

@RoutePage()
class UserProviderPersonalInfo extends StatefulWidget {
  const UserProviderPersonalInfo({super.key});

  @override
  State<UserProviderPersonalInfo> createState() => _UserProviderPersonalInfoState();
}

class _UserProviderPersonalInfoState extends State<UserProviderPersonalInfo> {
  // Text controllers for all form fields (including phone field)
  final List<TextEditingController> _controllers = List.generate(12, (index) => TextEditingController());

  bool _isLoading = false;
  bool _isImageLoading = false;
  String? _currentImageUrl;
  bool _phoneFieldHasError = false;

  @override
  void initState() {
    super.initState();
    // Ensure user info is loaded
    final userInfoState = context.read<UserInfoBloc>().state;
    if (userInfoState is! UserInfoSuccess) {
      String token = Utils.getAuthenticationToken();
      if (token.isNotEmpty) {
        context.read<UserInfoBloc>().add(
              FetchUserProfileInfoEvent(token: token),
            );
      }
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _prePopulateFields(UserWorkerInfoResponse? userWorkerInfo) {
    if (userWorkerInfo?.data != null) {
      final data = userWorkerInfo!.data!;

      // Pre-populate controllers with user data
      _controllers[0].text = data.nombre ?? ''; // Name
      _controllers[1].text = data.apellidos ?? ''; // Last names
      _controllers[2].text = data.rfc ?? ''; // RFC
      _controllers[3].text = data.clabe ?? ''; // CLABE
      _controllers[4].text = data.calle ?? ''; // Street
      _controllers[5].text = data.numeroexterior ?? ''; // Exterior number
      _controllers[6].text = data.numerointerior ?? ''; // Interior number
      _controllers[7].text = data.colonia ?? ''; // Neighborhood
      _controllers[8].text = data.ciudad ?? ''; // City
      _controllers[9].text = data.estado ?? ''; // State
      _controllers[10].text = data.codigoPostal ?? ''; // Postal code
      _controllers[11].text = ''; // TODO: Phone number (not in backend model yet, review)

      // Store current image URL
      _currentImageUrl = data.fotoUrl;
    }
  }

  Future<void> _changeProfileImage() async {
    if (_isImageLoading) return;

    try {
      if (await Utils.permissionSetting()) {
        if (!mounted) return;

        await Utils.submitProfile(context, () async {
          // Camera option
          XFile? image = await Utils.getImage(isCamera: true);
          if (mounted && image != null) {
            context.router.maybePop();
            await _processAndUploadImage(image);
          }
        }, () async {
          // Gallery option
          XFile? image = await Utils.getImage();
          if (mounted && image != null) {
            context.router.maybePop();
            await _processAndUploadImage(image);
          }
        });
      } else {
        if (mounted) {
          await Utils.showPermissionDialog(context);
        }
      }
    } catch (e) {
      _showMessage('Error al seleccionar imagen: $e');
    }
  }

  Future<void> _processAndUploadImage(XFile image) async {
    setState(() {
      _isImageLoading = true;
    });

    try {
      // 1. Process and save image locally (resize to 512x512 and save)
      final localPath = await ImageUtils.processAndSaveProfileImage(image);

      // 2. Upload resized image to server
      final localFile = File(localPath);
      String imageBase64 = await ImageUtils.imageToBase64(localFile);
      String contentType = ImageUtils.getContentType(localPath);

      final authRepo = AuthRepo();
      final ApiResponse<ProfileImageResponse> uploadResponse =
          await authRepo.uploadProfilePhoto(imageBase64, contentType);

      if (uploadResponse.data != null) {
        setState(() {
          _currentImageUrl = uploadResponse.data!.imageUrl;
        });
        _showMessage('Imagen de perfil actualizada exitosamente');

        // Refresh the profile image widget
        if (mounted) {
          setState(() {});
        }
      } else {
        _showMessage('Error al subir imagen: ${uploadResponse.errorMessage}');
      }
    } catch (e) {
      _showMessage('Error al procesar imagen: $e');
    } finally {
      setState(() {
        _isImageLoading = false;
      });
    }
  }

  Future<void> _saveUserInfo() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      String token = Utils.getAuthenticationToken();
      if (token.isEmpty) {
        _showMessage('Error: No se encontró token de autenticación');
        setState(() => _isLoading = false);
        return;
      }

      final userInfoState = context.read<UserInfoBloc>().state;
      if (userInfoState is! UserInfoSuccess) {
        _showMessage('Error: Información de usuario no disponible');
        setState(() => _isLoading = false);
        return;
      }

      bool isLavador = userInfoState.userWorkerInfo?.userType?.toLowerCase() == 'lavador';

      // Validar que el teléfono no esté vacío para usuarios (clientes)
      if (!isLavador && _controllers[11].text.trim().isEmpty) {
        setState(() {
          _phoneFieldHasError = true;
          _isLoading = false;
        });
        _showMessage('Error: El número de teléfono es obligatorio');
        return;
      }
      
      // Si pasó la validación, limpiar el error
      setState(() {
        _phoneFieldHasError = false;
      });

      if (isLavador) {
        // Save worker info
        final workerRepo = WorkerRepo();
        final updateRequest = UpdateWorkerInfoRequest(
          token: token,
          body: UpdateWorkerInfoBody(
            nombre: _controllers[0].text.trim(),
            apellidos: _controllers[1].text.trim(),
            rfc: _controllers[2].text.trim(),
            clabe: _controllers[3].text.trim(),
            calle: _controllers[4].text.trim(),
            numeroExterior: _controllers[5].text.trim(),
            numeroInterior: _controllers[6].text.trim(),
            colonia: _controllers[7].text.trim(),
            ciudad: _controllers[8].text.trim(),
            estado: _controllers[9].text.trim(),
            codigoPostal: _controllers[10].text.trim(),
            lat: userInfoState.userWorkerInfo?.data?.lat ?? 0.0,
            lon: userInfoState.userWorkerInfo?.data?.lon ?? 0.0,
            // Only update photo URL if a new image was uploaded
            fotoURL: _currentImageUrl ?? userInfoState.userWorkerInfo?.data?.fotoUrl,
          ),
        );

        final response = await workerRepo.updateWorkerInfo(updateRequest);
        if (response.data != null) {
          _showMessage('Información de trabajador actualizada exitosamente');
          // Refresh user info
          context.read<UserInfoBloc>().add(FetchUserProfileInfoEvent(token: token));
        } else {
          _showMessage('Error: ${response.errorMessage ?? 'No se pudo actualizar la información'}');
        }
      } else {
        // Save user info
        final userRepo = UserRepo();
        final updateRequest = UpdateUserInfoRequest(
          token: token,
          body: UpdateUserInfoBody(
            nombre: _controllers[0].text.trim(),
            apellidos: _controllers[1].text.trim(),
            rfc: _controllers[2].text.trim(),
            calle: _controllers[4].text.trim(),
            numeroExterior: _controllers[5].text.trim(),
            numeroInterior: _controllers[6].text.trim(),
            colonia: _controllers[7].text.trim(),
            ciudad: _controllers[8].text.trim(),
            estado: _controllers[9].text.trim(),
            codigoPostal: _controllers[10].text.trim(),
            lat: userInfoState.userWorkerInfo?.data?.lat ?? 0.0,
            lon: userInfoState.userWorkerInfo?.data?.lon ?? 0.0,
            telefono: _controllers[11].text.trim(),
            // Only update photo URL if a new image was uploaded
            fotoURL: _currentImageUrl ?? userInfoState.userWorkerInfo?.data?.fotoUrl,
          ),
        );

        final response = await userRepo.updateUserInfo(updateRequest);
        if (response.data != null) {
          _showMessage('Información de usuario actualizada exitosamente');
          // Refresh user info
          context.read<UserInfoBloc>().add(FetchUserProfileInfoEvent(token: token));
        } else {
          _showMessage('Error: ${response.errorMessage ?? 'No se pudo actualizar la información'}');
        }
      }
    } catch (e) {
      _showMessage('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: message.contains('Error') ? Colors.red : Colors.green,
      ),
    );
  }

  void _showDeleteAccountConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '⚠️ Eliminar Cuenta',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            '¿Estás seguro de que quieres eliminar tu cuenta?\n\nEsta acción es irreversible.',
            style: TextStyle(fontSize: 16.0),
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.grey, fontSize: 16.0),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showFinalDeleteConfirmation();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              child: const Text('Continuar'),
            ),
          ],
        );
      },
    );
  }

  void _showFinalDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            '🚨 Última Oportunidad',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Si eliminas tu cuenta te perderías de:\n\n'
            '• Acceso a servicios de lavandería profesionales\n'
            '• Historial de pedidos y valoraciones\n'
            '• Métodos de pago guardados\n'
            '• Descuentos y promociones exclusivas\n'
            '• La comodidad de tener tu ropa lavada sin salir de casa\n\n'
            '¿Estás completamente seguro de continuar?',
            style: TextStyle(fontSize: 16.0),
          ),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Mantener mi cuenta',
                style: TextStyle(color: AppColors.primary, fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteUserAccount();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              child: const Text('Eliminar definitivamente'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteUserAccount() async {
    try {
      String token = Utils.getAuthenticationToken();
      if (token.isEmpty) {
        _showMessage('Error: No se encontró token de autenticación');
        return;
      }

      // Mostrar indicador de carga
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16.0),
                Text('Eliminando cuenta...'),
              ],
            ),
          );
        },
      );

      // Llamada al API para eliminar la cuenta
      final authRepo = AuthRepo();
      final deleteRequest = DeleteAccountRequest(token: token);

      final response = await authRepo.deleteAccount(deleteRequest);

      if (mounted) {
        Navigator.of(context).pop(); // Cerrar diálogo de carga

        if (response.data != null) {
          // Eliminación exitosa
          _showMessage('Cuenta eliminada exitosamente');

          // Limpiar token local y redirigir al login
          await Future.delayed(const Duration(seconds: 2));
          if (mounted) {
            // Limpiar token guardado
            await Utils.unAuthenticate();

            // Navegar a login/registro
            context.router.replaceAll([const routeFiles.RegistrationRoute()]);
          }
        } else {
          // Error en la eliminación
          String errorMessage = response.errorMessage ?? 'Error desconocido al eliminar la cuenta';
          _showMessage('Error: $errorMessage');
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Cerrar diálogo de carga
        _showMessage('Error al eliminar cuenta: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: CustomAppBar.getCustomBar(
        title: AppStrings.personalInfo,
      ),
      drawer: CustomDrawer(
        title: AppStrings.searchJobs,
        ontap: () {},
      ),
      body: BlocBuilder<UserInfoBloc, UserInfoState>(
        builder: (context, state) {
          // Pre-populate fields when user info is loaded
          if (state is UserInfoSuccess && state.userWorkerInfo?.data != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _prePopulateFields(state.userWorkerInfo);
            });
          }

          return ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: [
              const YMargin(24.0),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    const XMargin(20.0),
                    // Show user photo using ProfileImageWidget with tap to change
                    Stack(
                      children: [
                        CircularProfileImage(
                          radius: 55,
                          networkImageUrl: _currentImageUrl ??
                              (state is UserInfoSuccess ? state.userWorkerInfo?.data?.fotoUrl : null),
                          showBorder: true,
                          borderColor: Colors.white,
                          borderWidth: 3.0,
                        ),
                        if (_isImageLoading)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(60),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _isImageLoading ? null : _changeProfileImage,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 5,
                                  )
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const XMargin(20.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            AppStrings.personalInfo,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Actualiza tu información personal",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const YMargin(20.0),
                  ],
                ),
              ),
              const YMargin(24.0),
              ...List.generate(
                12,
                (index) {
                  // Determinar si el usuario es lavador
                  bool isLavador = false;
                  if (state is UserInfoSuccess && state.userWorkerInfo?.userType != null) {
                    isLavador = state.userWorkerInfo!.userType!.toLowerCase() == 'lavador';
                  }

                  // Ocultar campos RFC (índice 2) y CLABE (índice 3) para usuarios normales
                  if (!isLavador && (index == 2 || index == 3)) {
                    return const SizedBox.shrink(); // No mostrar estos campos
                  }

                  // Ocultar campo teléfono (índice 11) para lavadores
                  if (isLavador && index == 11) {
                    return const SizedBox.shrink(); // No mostrar este campo para lavadores
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (index == 3 && isLavador) ...[const Divider(height: 10, color: AppColors.white, thickness: 4)],
                      if (index == 4) ...[
                        const YMargin(10.0),
                        CustomText(
                          text: AppStrings.direction,
                          fontColor: AppColors.primary,
                          fontSize: 22.0,
                          maxLines: 1,
                          textAlign: TextAlign.left,
                          fontWeight: FontWeight.bold,
                        ).setText(),
                      ],
                      _buildTextField(
                          isDisable: (index == 0 || index == 1 || index == 2),
                          hintText: _getHintTextByIndex(index),
                          controller: _controllers[index],
                          hasError: index == 11 && _phoneFieldHasError),
                      if (index == 3 && isLavador) ...[const Divider(height: 10, color: AppColors.white, thickness: 4)],
                    ],
                  );
                },
              ),
              const YMargin(10.0),
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary))
                    : SizedBox(
                        width: double.infinity,
                        child: PrimaryButton.secondaryIconbutton(
                            color: AppColors.secondary, text: AppStrings.save, onpressed: _saveUserInfo),
                      ),
              ),
              const YMargin(20.0),
              // Botón de eliminar cuenta (solo visible al hacer scroll hacia abajo)
              ElevatedButton(
                onPressed: _showDeleteAccountConfirmation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete_forever, size: 20.0),
                    SizedBox(width: 8.0),
                    Text(
                      'Eliminar Cuenta',
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const YMargin(20.0),
            ],
          );
        },
      ),
    );
  }

  String _getHintTextByIndex(int index) {
    switch (index) {
      case 0:
        return AppStrings.firstName; // Use proper hint instead of hardcoded value
      case 1:
        return AppStrings.lastName; // Use proper hint instead of hardcoded value
      case 2:
        return AppStrings.rfc; // Use proper hint instead of hardcoded value
      case 3:
        return AppStrings.clabe;
      case 4:
        return AppStrings.street;
      case 5:
        return AppStrings.exteriorNumber;
      case 6:
        return AppStrings.interiorNumber;
      case 7:
        return AppStrings.neighborhood;
      case 8:
        return AppStrings.city;
      case 9:
        return AppStrings.state;
      case 10:
        return AppStrings.postalCode;
      case 11:
        return AppStrings.tel;
      default:
        return '';
    }
  }

  Widget _buildTextField(
      {required String hintText, required TextEditingController controller, bool isDisable = false, bool hasError = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        decoration: hasError
            ? BoxDecoration(
                border: Border.all(color: AppColors.error, width: 2),
                borderRadius: BorderRadius.circular(12),
              )
            : null,
        child: CustomTextFieldWidget(
          controller: controller,
          maxLength: 100,
          isVisible: true,
          fillcolour: isDisable ? AppColors.grey.withValues(alpha: 0.8) : AppColors.white,
          readOnly: isDisable,
          hintText: hintText,
          onChanged: hasError ? (_) {
            // Clear error when user starts typing
            setState(() {
              _phoneFieldHasError = false;
            });
          } : null,
        ),
      ),
    );
  }
}
