import 'dart:io';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lavoauto/bloc/bloc/auth_bloc.dart';
import 'package:lavoauto/core/constants/app_strings.dart';
import 'package:lavoauto/presentation/common_widgets/custom_text.dart';
import 'package:lavoauto/presentation/common_widgets/primary_button.dart';
import 'package:lavoauto/theme/app_color.dart';
import 'package:lavoauto/utils/marginUtils/margin_imports.dart';

import 'package:lavoauto/presentation/router/router.gr.dart' as routeFiles;
import '../../../core/constants/assets.dart';
import '../../../data/models/request/user/register_modal.dart';
import '../../../data/models/request/worker/register_modal.dart';
import '../../../theme/apptheme.dart';
import '../../../utils/loadersUtils/LoaderClass.dart';
import '../../../utils/utils.dart';
import '../../common_widgets/image_.dart';
import '../../common_widgets/text_field.dart';

@RoutePage()
class RegistrationInfoScreen extends StatefulWidget {
  const RegistrationInfoScreen({super.key, this.isUser = false});
  final bool isUser;

  @override
  State<RegistrationInfoScreen> createState() => _RegistrationInfoScreenState();
}

class _RegistrationInfoScreenState extends State<RegistrationInfoScreen> {
  // Store all controllers in a list
  final List<TextEditingController> _controllers =
      List.generate(14, (_) => TextEditingController());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController getControllerbyIndex(int index) {
    return _controllers[index];
  }

  @override
  Widget build(BuildContext context) {
    dynamic loader = Loader.getLoader(context);
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: BlocConsumer<AuthBloc, AuthState>(
            buildWhen: (context, state) {
              return (state is! AuthRegistrationFailure ||
                  state is! AuthInitialLoading);
            },
            listener: (context, state) {
              debugPrint("user info state: $state");
              if (state is AuthRegistrationFailure) {
                Loader.hideLoader(loader);
                Utils.showSnackbar(
                  msg: state.error,
                  context: context,
                );
                return;
              } else if (state is AuthRegistrationSuccess) {
                Loader.hideLoader(loader);
                if (state.userRegistrationResponse != null) {
                  Utils.showSnackbar(
                    duration: 3000,
                    msg: state.userRegistrationResponse?.message ?? '',
                    context: context,
                  );

                  context.router.replaceAll([ routeFiles.LoginRoute()]);
                  return;
                } else if (state.locationResponse?.allow == 0) {
                  Loader.hideLoader(loader);
                  Utils.showSnackbar(
                    duration: 3000,
                    msg:
                        "we´re sorry, we are not providing service in that location",
                    context: context,
                  );
                }
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
                debugPrint(
                    "state Profile Image Path: ${state.profileImage?.path}");
              }
              return ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: [
                  CustomText(
                    text: AppStrings.registration,
                    fontColor: AppColors.primary,
                    fontSize: 24.0,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.bold,
                  ).setText(),
                  const YMargin(20.0),
                  if (state is AuthRegistrationSuccess &&
                      state.profileImage != null) ...[
                    CircleAvatar(
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
                  ] else ...[
                    InkWell(
                      onTap: () async {
                        if (await Utils.permissionSetting()) {
                          if (!context.mounted) return;
                          await Utils.submitProfile(context, () async {
                            XFile? image = await Utils.getImage(isCamera: true);
                            if (context.mounted) {
                              context.router.maybePop();
                              FocusScope.of(context)
                                  .unfocus(); // Close the keyboard
                            }
                            if (image != null) {
                              if (context.mounted) {
                                context.read<AuthBloc>().add(
                                      RegistrationEvent(
                                          isUser: widget.isUser,
                                          profileImage: image,
                                          isProfileSelected: true),
                                    );
                              }
                            }
                          }, () async {
                            XFile? image = await Utils.getImage();
                            if (context.mounted) {
                              context.router.maybePop();
                              FocusScope.of(context)
                                  .unfocus(); // Close the keyboard
                            }
                            if (image != null) {
                              if (context.mounted) {
                                context.read<AuthBloc>().add(
                                      RegistrationEvent(
                                          isUser: widget.isUser,
                                          profileImage: image,
                                          isProfileSelected: true),
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
                      child: ImagesPng.assetPNG(
                        Assets.placeholderAddPhoto,
                        height: 100.0,
                        width: 100.0,
                      ),
                    )
                  ],
                  const YMargin(24.0),
                  ...List.generate(
                    14,
                    (index) => _buildTextField(
                      context: context,
                      index: index,
                      hintText: getTitlebyIndex(index),
                      controller: getControllerbyIndex(index),
                      dropdownItems: index == 1
                          ? (state is AuthRegistrationSuccess)
                              ? state.locationResponse?.results
                                  ?.map((e) => e.dAsenta)
                                  .toList()
                              : []
                          : [], // Pass dropdown items for index 1
                    ),
                  ),
                  const YMargin(5.0),
                  CheckboxListTile(
                      value: (state is AuthRegistrationSuccess)
                          ? state.isWasher
                          : false,
                      title: CustomText(
                        text: AppStrings.hasWasherDryer,
                        fontColor: AppColors.primary,
                        fontSize: 20.0,
                        textAlign: TextAlign.left,
                        fontWeight: FontWeight.w500,
                      ).setText(),
                      visualDensity: VisualDensity.comfortable,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: AppColors.secondary,
                      onChanged: (value) {
                        context.read<AuthBloc>().add(UpdateServiceEvent(
                            isWasher: value ?? false,
                            isTransport: (state is AuthRegistrationSuccess)
                                ? (state).isTransport ?? false
                                : false));
                      }),
                  CheckboxListTile(
                      value: (state is AuthRegistrationSuccess)
                          ? state.isTransport
                          : false,
                      contentPadding: EdgeInsets.zero,
                      title: CustomText(
                        text: AppStrings.hasTransport,
                        fontColor: AppColors.primary,
                        fontSize: 20.0,
                        textAlign: TextAlign.left,
                        fontWeight: FontWeight.w500,
                      ).setText(),
                      visualDensity: VisualDensity.comfortable,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: AppColors.secondary,
                      onChanged: (value) {
                        context.read<AuthBloc>().add(UpdateServiceEvent(
                            isTransport: value ?? false,
                            isWasher: (state is AuthRegistrationSuccess)
                                ? (state).isWasher ?? false
                                : false));
                      }),
                  const YMargin(10.0),
                  Center(
                    child: PrimaryButton.secondaryIconbutton(
                      color: AppColors.secondary,
                      text: AppStrings.save,
                      onpressed: () {
                        FocusScope.of(context).unfocus(); // Close the keyboard

                        // Allow registration attempts regardless of previous state (unless currently loading)
                        if (state is! AuthRegistrationLoading) {
                          // Get profile image from current state if available
                          XFile? profileImage;
                          if (state is AuthRegistrationSuccess) {
                            profileImage = state.profileImage;
                          }

                          // Check if profile image is selected (after test remove !)
                          /*if (profileImage == null) {
                            Utils.showSnackbar(
                              duration: 3000,
                              msg: "Por favor seleccione una imagen de perfil",
                              context: context,
                            );
                            return;
                          }*/

                          if (validateFields()) {
                            Loader.insertLoader(context, loader);
                            if (profileImage == null) {
                              context.read<AuthBloc>().add(GetProfileUrlEvent(
                                  isUser: widget.isUser,
                                  profileImage: profileImage!));
                            }

                            if (widget.isUser) {
                              // Create RegisterRequest for user
                              final registerRequest = RegisterRequest(
                                nombre: _controllers[7].text.trim(),
                                apellidos: _controllers[8].text.trim(),
                                rfc: _controllers[9].text.trim(),
                                email: _controllers[4].text.trim(),
                                calle: _controllers[10].text.trim(),
                                numeroexterior: _controllers[11].text.trim(),
                                numerointerior: _controllers[12].text.trim().isEmpty ? null : _controllers[12].text.trim(), // Optional
                                colonia: _controllers[1].text.trim(),
                                ciudad: _controllers[2].text.trim(),
                                estado: _controllers[3].text.trim(),
                                codigoPostal: _controllers[0].text.trim(),
                                lat: 0.0, // Replace with actual latitude logic
                                lon: 0.0, // Replace with actual longitude logic
                                telefono: _controllers[13]
                                    .text
                                    .trim(), // Assuming phone number is at index 13
                                fotoUrl: profileImage?.path, // Optional for users
                                passwordHash: _controllers[5].text.trim(),
                              );

                              context.read<AuthBloc>().add(
                                    RegistrationEvent(
                                      isUser: widget.isUser,
                                      userRegistrationModel: registerRequest,
                                      profileImage: profileImage,
                                    ),
                                  );
                            } else {
                              // Service provider registration
                              String? imageUrl;
                              if (state is AuthRegistrationSuccess) {
                                imageUrl = state.profileImageUrl;
                              }
                              
                              final registerLavadorRequest =
                                  RegisterLavadorRequest(
                                clabe: _controllers[10].text.trim(),
                                nombre: _controllers[7].text.trim(),
                                apellidos: _controllers[8].text.trim(),
                                rfc: _controllers[9].text.trim(),
                                email: _controllers[4].text.trim(),
                                calle: _controllers[11].text.trim(),
                                numeroexterior: _controllers[12].text.trim(),
                                numerointerior: _controllers[13].text.trim().isEmpty ? null : _controllers[13].text.trim(), // Optional
                                colonia: _controllers[1].text.trim(),
                                ciudad: _controllers[2].text.trim(),
                                estado: _controllers[3].text.trim(),
                                codigoPostal: _controllers[0].text.trim(),
                                lat: 0.0, // Replace with actual latitude logic
                                lon: 0.0, // Replace with actual longitude logic
                                telefono: _controllers[13]
                                    .text
                                    .trim(), // Assuming phone number is at index 13
                                fotoUrl: imageUrl,
                                passwordHash: _controllers[5].text.trim(),
                              );

                              context.read<AuthBloc>().add(
                                    RegistrationEvent(
                                      isUser: widget.isUser,
                                      workerRegistrationModel:
                                          registerLavadorRequest,
                                      profileImage: profileImage,
                                    ),
                                  );
                            }
                          }
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  bool validateFields() {
    for (int i = 0; i < _controllers.length; i++) {
      final value = _controllers[i].text.trim();
      switch (i) {
        case 0: // Código Postal
          if (value.isEmpty || value.length < 4) {
            Utils.showSnackbar(
                msg: "Por favor ingrese un código postal válido",
                context: context);
            return false;
          }
          break;
        case 1: // Colonia
          if (value.isEmpty) {
            Utils.showSnackbar(
                msg: "Por favor seleccione una colonia", context: context);
            return false;
          }
          break;
        case 2: // Ciudad
          if (value.isEmpty) {
            Utils.showSnackbar(
                msg: "Por favor ingrese una ciudad", context: context);
            return false;
          }
          break;
        case 3: // Estado
          if (value.isEmpty) {
            Utils.showSnackbar(
                msg: "Por favor ingrese un estado", context: context);
            return false;
          }
          break;
        case 4: // Correo Electrónico
          if (value.isEmpty) {
            Utils.showSnackbar(
                msg: "Por favor ingrese un correo electrónico válido",
                context: context);
            return false;
          }
          break;
        case 5: // Contraseña
          if (value.isEmpty || value.length < 6) {
            Utils.showSnackbar(
                msg: "La contraseña debe tener al menos 6 caracteres",
                context: context);
            return false;
          }
          break;
        case 6: // Confirmar Contraseña
          if (value.isEmpty || value != _controllers[5].text.trim()) {
            Utils.showSnackbar(
                msg: "Las contraseñas no coinciden", context: context);
            return false;
          }
          break;
        case 7: // Nombre
          if (value.isEmpty) {
            Utils.showSnackbar(
                msg: "Por favor ingrese su nombre", context: context);
            return false;
          }
          break;
        case 8: // Apellidos
          if (value.isEmpty) {
            Utils.showSnackbar(
                msg: "Por favor ingrese sus apellidos", context: context);
            return false;
          }
          break;
        case 9: // RFC
          if (value.isEmpty) {
            Utils.showSnackbar(
                msg: "Por favor ingrese su RFC", context: context);
            return false;
          }
          break;
        case 10: // CLABE
          if (value.isEmpty) {
            Utils.showSnackbar(
                msg: "La CLABE debe tener 18 dígitos", context: context);
            return false;
          }
          break;
        case 11: // Calle
          if (value.isEmpty) {
            Utils.showSnackbar(
                msg: "Por favor ingrese su calle", context: context);
            return false;
          }
          break;
        case 12: // Número Exterior
          if (value.isEmpty) {
            Utils.showSnackbar(
                msg: "Por favor ingrese su número exterior", context: context);
            return false;
          }
          break;
        case 13: // Número Interior - Optional
          // No validation needed - interior number is optional
          break;
        default:
          break;
      }
    }
    return true;
  }

  VoidCallback? textfieldactionbyindex(
      BuildContext context, int index, TextEditingController controller) {
    switch (index) {
      case 0: // Postal Code
        return () async {
          debugPrint("statement: ${controller.text}");
          if (controller.text.isNotEmpty && controller.text.length >= 4) {
            // Example: Fetch locations by postal code
            FocusScope.of(context).unfocus();
            context
                .read<AuthBloc>()
                .add(LocationEvent(postalCode: controller.text.trim()));

            debugPrint("statement inside : ${controller.text}");
          } else {
            // Utils.showSnackbar(
            //     msg: "Please enter a postal code", context: context);
          }
        };
      case 1: //Neighborhood
        return null; // No action
      case 2: //City
        return null; // No action
      case 3: //State
        return null;
      case 4: //Email
        return null;
      case 5: //Password
        return null;
      case 6: //Confirm Password
        return null;
      case 7: //First Name
        return null;
      case 8: //Last Name
        return null;
      case 9: //RFC
        return null;
      case 10: //CLABE
        return null;
      case 11: //Street
        return null;
      case 12: //Exterior Number
        return null;
      case 13: // Interior Number
        return null;
      default:
        return null;
    }
  }

  String getTitlebyIndex(int index) {
    switch (index) {
      case 0:
        return AppStrings.postalCode;
      case 1:
        return AppStrings.neighborhood;
      case 2:
        return AppStrings.city;
      case 3:
        return AppStrings.state;
      case 4:
        return AppStrings.email;
      case 5:
        return AppStrings.password;
      case 6:
        return AppStrings.confirmPassword;
      case 7:
        return AppStrings.firstName;
      case 8:
        return AppStrings.lastName;
      case 9:
        return AppStrings.rfc;
      case 10:
        return AppStrings.clabe;
      case 11:
        return AppStrings.street;
      case 12:
        return AppStrings.exteriorNumber;
      case 13:
        return AppStrings.interiorNumber;

      default:
        return '';
    }
  }

  Widget _buildTextField({
    required int index,
    required BuildContext context,
    required String hintText,
    required TextEditingController controller,
    List<String>? dropdownItems, // Add dropdown items for index 1
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
          items: dropdownItems?.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: CustomText(
                    text: item,
                    fontColor: AppColors.black,
                    textAlign: TextAlign.left,
                    fontWeight: FontWeight.w500,
                  ).setText(),
                );
              }).toList() ??
              [],
          onChanged: (value) {
            controller.text = value ?? '';
          },
          iconSize: 16.0,
          decoration: InputDecoration(
            hintText:
                dropdownItems?.isNotEmpty == true ? 'Select Colonia' : hintText,
            hintStyle: AppTheme.theme.textTheme.bodyMedium?.copyWith(
              fontSize: 20.0,
              color: AppColors.greyNormalColor,
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: AppColors.white,
            counter: const Offstage(),
            isCollapsed: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
          maxLength: 100,
          isVisible: true,
          onEditingComplete: textfieldactionbyindex(context, index, controller),
          hintText: hintText,
        ),
      );
    }
  }
}
