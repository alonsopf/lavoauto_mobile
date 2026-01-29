import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lavoauto/bloc/bloc/user_info_bloc.dart';
import 'package:lavoauto/data/repositories/auth_repo.dart';
import 'package:lavoauto/data/repositories/worker_repo.dart';
import 'package:lavoauto/data/models/request/worker/update_worker_info_modal.dart';
import 'package:lavoauto/data/models/response/auth/profile_image_response_modal.dart';
import 'package:lavoauto/data/models/api_response.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/utils.dart';
import 'package:lavoauto/utils/image_utils.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final List<TextEditingController> _controllers = List.generate(11, (index) => TextEditingController());
  bool _isLoading = false;
  bool _isImageLoading = false;
  String? _currentImageUrl;
  bool _isLavador = false;
  bool _hasPrePopulated = false;

  @override
  void initState() {
    super.initState();
    // Pre-populate fields immediately on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _prePopulateFields();
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _prePopulateFields() {
    if (_hasPrePopulated) return;

    final userInfoState = context.read<UserInfoBloc>().state;
    if (userInfoState is UserInfoSuccess && userInfoState.userWorkerInfo?.data != null) {
      final data = userInfoState.userWorkerInfo!.data!;
      final userType = userInfoState.userWorkerInfo!.userType;

      setState(() {
        _isLavador = userType == 'lavador';
        _controllers[0].text = data.nombre ?? '';
        _controllers[1].text = data.apellidos ?? '';
        _controllers[2].text = data.rfc ?? '';
        _controllers[3].text = data.clabe ?? '';
        _controllers[4].text = data.calle ?? '';
        _controllers[5].text = data.numeroexterior ?? '';
        _controllers[6].text = data.numerointerior ?? '';
        _controllers[7].text = data.colonia ?? '';
        _controllers[8].text = data.ciudad ?? '';
        _controllers[9].text = data.estado ?? '';
        _controllers[10].text = data.codigoPostal ?? '';
        _currentImageUrl = data.fotoUrl;
        _hasPrePopulated = true;
      });
    }
  }

  Future<void> _changeProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      await _processAndUploadImage(image);
    }
  }

  Future<void> _processAndUploadImage(XFile image) async {
    setState(() => _isImageLoading = true);

    try {
      final localPath = await ImageUtils.processAndSaveProfileImage(image);
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
      } else {
        _showMessage('Error al subir imagen: ${uploadResponse.errorMessage}');
      }
    } catch (e) {
      _showMessage('Error al procesar imagen: $e');
    } finally {
      setState(() => _isImageLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

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

      bool success = false;

      if (_isLavador) {
        // Use worker repo for lavadores
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
            fotoURL: _currentImageUrl ?? userInfoState.userWorkerInfo?.data?.fotoUrl,
          ),
        );

        final response = await workerRepo.updateWorkerInfo(updateRequest);
        success = response.data != null;
        if (!success) {
          _showMessage('Error: ${response.errorMessage ?? 'No se pudo actualizar'}');
        }
      } else {
        // Use auth repo for clients
        final authRepo = AuthRepo();
        final response = await authRepo.updateClienteProfile(
          token: token,
          calle: _controllers[4].text.trim(),
          numeroExterior: _controllers[5].text.trim(),
          numeroInterior: _controllers[6].text.trim(),
          colonia: _controllers[7].text.trim(),
          ciudad: _controllers[8].text.trim(),
          estado: _controllers[9].text.trim(),
          codigoPostal: _controllers[10].text.trim(),
          lat: userInfoState.userWorkerInfo?.data?.lat ?? 0.0,
          lng: userInfoState.userWorkerInfo?.data?.lon ?? 0.0,
          fotoUrl: _currentImageUrl ?? userInfoState.userWorkerInfo?.data?.fotoUrl,
        );
        success = response.data != null;
        if (!success) {
          _showMessage('Error: ${response.errorMessage ?? 'No se pudo actualizar'}');
        }
      }

      if (success) {
        _showMessage('Perfil actualizado exitosamente');
        context.read<UserInfoBloc>().add(FetchUserProfileInfoEvent(token: token));
      }
    } catch (e) {
      _showMessage('Error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: message.contains('Error') ? AppColors.error : AppColors.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Mi Perfil",
          style: TextStyle(
            color: AppColors.primaryNewDark,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0,
      ),
      body: BlocBuilder<UserInfoBloc, UserInfoState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile photo with edit button
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.borderGrey,
                          border: Border.all(
                            color: AppColors.primaryNew,
                            width: 3,
                          ),
                        ),
                        child: _currentImageUrl != null && _currentImageUrl!.isNotEmpty
                            ? ClipOval(
                                child: Image.network(
                                  _currentImageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.person,
                                      size: 60,
                                      color: Colors.white,
                                    );
                                  },
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white,
                              ),
                      ),
                      if (_isImageLoading)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.5),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          ),
                        ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: _changeProfileImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryNew,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Form fields
                _buildTextField(label: "Nombre", controller: _controllers[0], readOnly: true),
                const SizedBox(height: 16),
                _buildTextField(label: "Apellidos", controller: _controllers[1], readOnly: true),
                // RFC and CLABE only shown for lavadores
                if (_isLavador) ...[
                  const SizedBox(height: 16),
                  _buildTextField(label: "RFC", controller: _controllers[2], readOnly: true),
                  const SizedBox(height: 16),
                  _buildTextField(label: "CLABE", controller: _controllers[3]),
                ],
                const SizedBox(height: 20),
                const Text(
                  "Dirección",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryNewDark,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextField(label: "Calle", controller: _controllers[4]),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(label: "Núm. Ext.", controller: _controllers[5]),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(label: "Núm. Int.", controller: _controllers[6]),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTextField(label: "Colonia", controller: _controllers[7]),
                const SizedBox(height: 16),
                _buildTextField(label: "Ciudad", controller: _controllers[8]),
                const SizedBox(height: 16),
                _buildTextField(label: "Estado", controller: _controllers[9]),
                const SizedBox(height: 16),
                _buildTextField(label: "Código Postal", controller: _controllers[10]),
                const SizedBox(height: 30),
                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryNew,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _isLoading ? null : _saveProfile,
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            "Guardar",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
            filled: true,
            fillColor: readOnly ? AppColors.borderGrey.withOpacity(0.3) : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderGrey, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.borderGrey, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryNew, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}

