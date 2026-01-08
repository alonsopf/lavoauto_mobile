import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/bloc/bloc/user_info_bloc.dart';
import 'package:lavoauto/core/constants/app_strings.dart';
import 'package:lavoauto/data/models/response/auth/user_worker_info_modal.dart';
import 'package:lavoauto/data/models/request/worker/update_worker_info_modal.dart';
import 'package:lavoauto/data/repositories/worker_repo.dart';
import 'package:lavoauto/data/repositories/auth_repo.dart';
import 'package:lavoauto/data/models/response/auth/profile_image_response_modal.dart';
import 'package:lavoauto/presentation/common_widgets/custom_text.dart';
import 'package:lavoauto/presentation/common_widgets/primary_button.dart';
import 'package:lavoauto/presentation/common_widgets/profile_image_widget.dart';
import 'package:lavoauto/utils/image_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/marginUtils/margin_imports.dart';
import 'package:lavoauto/utils/utils.dart';
import 'dart:io';

import '../../../core/constants/assets.dart';
import '../../common_widgets/app_bar.dart';
import '../../common_widgets/custom_drawer.dart';
import '../../common_widgets/image_.dart';
import '../../common_widgets/text_field.dart';
import '../../../../data/models/api_response.dart';

@RoutePage()
class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  // Text controllers for all form fields - service providers don't need phone
  final List<TextEditingController> _controllers = List.generate(11, (index) => TextEditingController());
  
  bool _isLoading = false;
  bool _isImageLoading = false;
  String? _currentImageUrl;
  
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

  Future<void> _saveWorkerInfo() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      String token = Utils.getAuthenticationToken();
      if (token.isEmpty) {
        _showMessage('Error: No se encontró token de autenticación');
        return;
      }

      final userInfoState = context.read<UserInfoBloc>().state;
      if (userInfoState is! UserInfoSuccess) {
        _showMessage('Error: Información de usuario no disponible');
        return;
      }

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
        _showMessage('Información actualizada exitosamente');
        // Refresh user info
        context.read<UserInfoBloc>().add(FetchUserProfileInfoEvent(token: token));
      } else {
        _showMessage('Error: ${response.errorMessage ?? 'No se pudo actualizar la información'}');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: CustomAppBar.getCustomBar(
        title: AppStrings.personalInfo,
      ),
      drawer: CustomDrawer(
        title: AppStrings.personalInfo,
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
          
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  const YMargin(24.0),
                  Row(
                    children: [
                      const XMargin(20.0),
                      // Show user photo using ProfileImageWidget with tap to change
                      Stack(
                        children: [
                          CircularProfileImage(
                            radius: 50.0,
                            networkImageUrl: _currentImageUrl ?? 
                                (state is UserInfoSuccess 
                                    ? state.userWorkerInfo?.data?.fotoUrl 
                                    : null),
                            showBorder: true,
                            borderColor: Colors.white,
                            borderWidth: 2.0,
                          ),
                          if (_isImageLoading)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.0,
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
                                padding: const EdgeInsets.all(6.0),
                                decoration: const BoxDecoration(
                                  color: AppColors.secondary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const XMargin(20.0),
                      Expanded(
                        child: CustomText(
                          text: AppStrings.personalInfo,
                          fontColor: AppColors.primary,
                          fontSize: 40.0,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.bold,
                        ).setText(),
                      ),
                      const YMargin(20.0),
                    ],
                  ),
                  const YMargin(24.0),
                  ...List.generate(
                      11,
                      (index) {
                        return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (index == 3) ...[
                                  const Divider(
                                    height: 10,
                                    color: AppColors.white,
                                    thickness: 4,
                                  )
                                ],
                                if (index == 4) ...[
                                  const YMargin(10.0),
                                  CustomText(
                                    text: AppStrings.direction,
                                    fontColor: AppColors.primary,
                                    fontSize: 24.0,
                                    maxLines: 1,
                                    textAlign: TextAlign.left,
                                    fontWeight: FontWeight.bold,
                                  ).setText(),
                                ],
                                _buildTextField(
                                    isDisable: (index == 0 || index == 1),
                                    hintText: _getHintTextByIndex(index),
                                    controller: _controllers[index]),
                                if (index == 3) ...[
                                  const Divider(
                                    height: 10,
                                    color: AppColors.white,
                                    thickness: 4,
                                  )
                                ],
                              ],
                            ),
                          );
                      }),
                  const YMargin(10.0),
                  Center(
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
                          )
                        : PrimaryButton.secondaryIconbutton(
                            color: AppColors.secondary,
                            text: AppStrings.save,
                            onpressed: _saveWorkerInfo,
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getHintTextByIndex(int index) {
    switch (index) {
      case 0:
        return AppStrings.firstName;
      case 1:
        return AppStrings.lastName;
      case 2:
        return AppStrings.rfc;
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
      default:
        return '';
    }
  }

  Widget _buildTextField(
      {required String hintText,
      required TextEditingController controller,
      bool isDisable = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: CustomTextFieldWidget(
        controller: controller,
        maxLength: 100,
        isVisible: true,
        fillcolour:
            isDisable ? AppColors.grey.withValues(alpha: 0.8) : AppColors.white,
        readOnly: isDisable,
        hintText: hintText,
      ),
    );
  }
}
