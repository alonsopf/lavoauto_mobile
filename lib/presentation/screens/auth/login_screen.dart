import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lavoauto/presentation/common_widgets/text_field.dart';
import 'package:lavoauto/presentation/router/router.gr.dart' as routeFiles;
import 'package:lavoauto/utils/loadersUtils/LoaderClass.dart';

import '../../../bloc/bloc/auth_bloc.dart';
import '../../../bloc/bloc/user_info_bloc.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/assets.dart';
import '../../../data/models/request/auth/forgot_password_modal.dart';
import '../../../data/models/request/auth/login_modal.dart';
import '../../../data/repositories/auth_repo.dart';
import '../../../theme/app_color.dart';
import '../../../utils/enum/user_type_enum.dart';
import '../../../utils/marginUtils/margin_imports.dart';
import '../../../utils/utils.dart';
import '../../common_widgets/custom_text.dart';
import '../../common_widgets/primary_button.dart';

@RoutePage()
class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    dynamic loader = Loader.getLoader(context);

    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      body: Stack(
        children: [
          _buildBackground(context: context),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
                child: Column(
                  children: [
                    Hero(
                      tag: 'app-logo',
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.borderGrey),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.shadowLight,
                              blurRadius: 14,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.asset("assets/logo_white.png", height: 96, width: 96, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    const YMargin(12.0),
                    CustomText(
                      text: AppStrings.welcome,
                      fontColor: AppColors.primary,
                      fontSize: 26.0,
                      fontWeight: FontWeight.w800,
                    ).setText(),
                    const YMargin(6.0),
                    CustomText(
                      text: AppStrings.loginTitle,
                      fontColor: AppColors.primary.withValues(alpha: 0.85),
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ).setText(),
                    const YMargin(14.0),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.5),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const YMargin(6.0),
                          const Text(
                            AppStrings.email,
                            style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                          const YMargin(8.0),
                          CustomTextFieldWidget(
                            controller: emailController,
                            maxLength: 40,
                            isVisible: true,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            hintText: AppStrings.email,
                            prefixWidget: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.email_outlined, size: 22, color: AppColors.secondary),
                            ),
                          ),
                          const YMargin(18.0),
                          const Text(
                            AppStrings.password,
                            style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                          const YMargin(8.0),
                          CustomTextFieldWidget(
                            controller: passwordController,
                            maxLength: 20,
                            isVisible: false,
                            isPassword: true,
                            hintText: AppStrings.password,
                            prefixWidget: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.lock_outline, size: 22, color: AppColors.secondary),
                            ),
                          ),
                          const YMargin(10.0),
                          SizedBox(
                            width: Utils.getScreenSize(context).width * 0.9,
                            child: BlocConsumer<AuthBloc, AuthState>(
                              listener: (context, state) {
                                debugPrint("login state $state");
                                if (state is AuthLoginLoadingState) {
                                  Loader.insertLoader(context, loader);
                                } else if (state is AuthLoginSuccessState) {
                                  if (state.userWorkerInfo != null) {
                                    String token = Utils.getAuthenticationToken();
                                    if (token.isNotEmpty) {
                                      context.read<UserInfoBloc>().add(
                                            FetchUserProfileInfoEvent(token: token),
                                          );
                                    }

                                    if (UserType.client.name ==
                                        state.userWorkerInfo?.userType.toString().toLowerCase()) {
                                      context.router.push(const routeFiles.HomePage());
                                    } else if (UserType.lavador.name ==
                                        state.userWorkerInfo?.userType.toString().toLowerCase()) {
                                      context.router.push(const routeFiles.LavadorHomePage());

                                      debugPrint("on login success ${state.userWorkerInfo?.userType}");
                                    }
                                  }
                                  Loader.hideLoader(loader);
                                } else if (state is AuthLoginFailure) {
                                  Loader.hideLoader(loader);
                                  Utils.showAlert(
                                    title: 'Error de acceso',
                                    message: 'Error en las credenciales, verifica tu usuario y contraseña',
                                    context: context,
                                  );
                                }
                              },
                              buildWhen: (previous, current) {
                                return (current is! AuthLoginFailure || current is! AuthLoginLoadingState);
                              },
                              builder: (context, state) {
                                debugPrint("login info ${Utils.getAuthentication()}");
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: GestureDetector(
                                        onTap: () => _showForgotPasswordDialog(context),
                                        child: const Text(
                                          AppStrings.forgotPassword,
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const YMargin(10.0),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: state is AuthLoginSuccessState ? state.keepSessionOpen : false,
                                          onChanged: (value) {
                                            context.read<AuthBloc>().add(
                                                  UpdateKeepSessionOn(iskeepsessionOn: value ?? false),
                                                );
                                          },
                                          activeColor: AppColors.primary,
                                        ),
                                        CustomText(
                                          text: AppStrings.keepSessionOpen,
                                          fontColor: AppColors.primary,
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                        ).setText(),
                                      ],
                                    ),
                                    const YMargin(10.0),
                                    PrimaryButton.primarybutton(
                                      isEnable: true,
                                      width: double.infinity,
                                      text: AppStrings.login,
                                      onpressed: () async {
                                        if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                                          Utils.showAlert(
                                            title: 'Campos requeridos',
                                            message: 'El correo electrónico y la contraseña son requeridos',
                                            context: context,
                                          );
                                          return;
                                        }
                                        final loginRequest = LoginRequest(
                                          email: emailController.text.trim(),
                                          password: passwordController.text.trim(),
                                        );
                                        // Loader.insertLoader(context, loader);
                                        // // Dispatch the login event
                                        context.read<AuthBloc>().add(UserLoginEvent(loginRequest: loginRequest));
                                      },
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const YMargin(20.0),
                    CustomText(
                      text: AppStrings.noAccount,
                      fontColor: AppColors.primary,
                      fontSize: 16.0,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.w600,
                    ).setText(),
                    const YMargin(20.0),
                    Row(
                      children: [
                        PrimaryButton.secondaryIconbutton(
                          color: AppColors.secondary,
                          img: Image.asset(
                            Assets.personalInfo,
                            height: 20.0,
                            width: 20.0,
                            color: AppColors.white,
                          ),
                          text: AppStrings.user,
                          onpressed: () {
                            context.read<AuthBloc>().add(const AuthInitialEvent());
                            context.router.push(const routeFiles.UserRegistrationInfoRoute());
                          },
                        ),
                        const XMargin(10.0),
                        Expanded(
                          child: PrimaryButton.secondaryIconbutton(
                            color: AppColors.secondary,
                            img: Image.asset(
                              Assets.serviceProvider,
                              height: 20.0,
                              width: 20.0,
                              color: AppColors.white,
                            ),
                            text: AppStrings.serviceProvider,
                            onpressed: () {
                              context.read<AuthBloc>().add(const AuthInitialEvent());
                              context.router.push(const routeFiles.ServiceProviderRegistrationInfoRoute());
                            },
                          ),
                        ),
                      ],
                    ),
                    const YMargin(10.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground({required BuildContext context}) {
    return Stack(
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
      ],
    );
  }

  Widget old({required BuildContext context}) {
    dynamic loader = Loader.getLoader(context);
    return Container(
      width: double.infinity,
      child: SizedBox(
        width: Utils.getScreenSize(context).width * 0.9,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const YMargin(10.0),
              ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: Image.asset(
                  "assets/logo_white.png",
                  height: 120,
                ),
              ),
              const YMargin(24.0),
              CustomText(
                text: AppStrings.welcome,
                fontColor: AppColors.primary,
                fontSize: 32.0,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w800,
              ).setText(),
              const YMargin(20.0),
              CustomText(
                text: AppStrings.loginTitle,
                fontColor: AppColors.primary.withValues(alpha: 0.75),
                fontSize: 18.0,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w600,
              ).setText(),
              const YMargin(16.0),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: AppColors.borderGrey),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      AppStrings.email,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CustomTextFieldWidget(
                      controller: emailController,
                      maxLength: 40,
                      isVisible: true,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      hintText: AppStrings.email,
                    ),
                    const YMargin(24.0),
                    const Text(
                      AppStrings.password,
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: Utils.getScreenSize(context).width * 0.9,
                      child: CustomTextFieldWidget(
                        controller: passwordController,
                        maxLength: 20,
                        isVisible: false,
                        isPassword: true,
                        hintText: AppStrings.password,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => _showForgotPasswordDialog(context),
                        child: const Text(
                          AppStrings.forgotPassword,
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const YMargin(16.0),
              SizedBox(
                width: Utils.getScreenSize(context).width * 0.9,
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    debugPrint("login state $state");
                    if (state is AuthLoginLoadingState) {
                      Loader.insertLoader(context, loader);
                    } else if (state is AuthLoginSuccessState) {
                      if (state.userWorkerInfo != null) {
                        String token = Utils.getAuthenticationToken();
                        if (token.isNotEmpty) {
                          context.read<UserInfoBloc>().add(
                                FetchUserProfileInfoEvent(token: token),
                              );
                        }

                        if (UserType.client.name == state.userWorkerInfo?.userType.toString().toLowerCase()) {
                          context.router.push(const routeFiles.HomePage());
                        } else if (UserType.lavador.name == state.userWorkerInfo?.userType.toString().toLowerCase()) {
                          context.router.push(const routeFiles.LavadorHomePage());

                          debugPrint("on login success ${state.userWorkerInfo?.userType}");
                        }
                      }
                      Loader.hideLoader(loader);
                    } else if (state is AuthLoginFailure) {
                      Loader.hideLoader(loader);
                      Utils.showAlert(
                        title: 'Error de acceso',
                        message: 'Error en las credenciales, verifica tu usuario y contraseña',
                        context: context,
                      );
                    }
                  },
                  buildWhen: (previous, current) {
                    return (current is! AuthLoginFailure || current is! AuthLoginLoadingState);
                  },
                  builder: (context, state) {
                    debugPrint("login info ${Utils.getAuthentication()}");
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CheckboxListTile(
                          value: state is AuthLoginSuccessState ? state.keepSessionOpen : false,
                          title: CustomText(
                            text: AppStrings.keepSessionOpen,
                            fontColor: AppColors.primary,
                            fontSize: 16.0,
                            textAlign: TextAlign.left,
                            fontWeight: FontWeight.w600,
                          ).setText(),
                          visualDensity: VisualDensity.comfortable,
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: AppColors.secondary,
                          checkColor: AppColors.white,
                          side: const BorderSide(
                            color: AppColors.borderGrey,
                            width: 2.0,
                          ),
                          onChanged: (value) {
                            context.read<AuthBloc>().add(
                                  UpdateKeepSessionOn(iskeepsessionOn: value ?? false),
                                );
                          },
                        ),
                        const YMargin(10.0),
                        PrimaryButton.primarybutton(
                          isEnable: true,
                          width: double.infinity,
                          text: AppStrings.login,
                          onpressed: () async {
                            if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                              Utils.showAlert(
                                title: 'Campos requeridos',
                                message: 'El correo electrónico y la contraseña son requeridos',
                                context: context,
                              );
                              return;
                            }
                            final loginRequest = LoginRequest(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );
                            // Loader.insertLoader(context, loader);
                            // // Dispatch the login event
                            context.read<AuthBloc>().add(UserLoginEvent(loginRequest: loginRequest));
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              const YMargin(20.0),
              CustomText(
                text: AppStrings.noAccount,
                fontColor: AppColors.primary,
                fontSize: 16.0,
                maxLines: 2,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w600,
              ).setText(),
              const YMargin(20.0),
              Row(
                children: [
                  PrimaryButton.secondaryIconbutton(
                    color: AppColors.secondary,
                    img: Image.asset(
                      Assets.personalInfo,
                      height: 20.0,
                      width: 20.0,
                      color: AppColors.white,
                    ),
                    text: AppStrings.user,
                    onpressed: () {
                      context.read<AuthBloc>().add(const AuthInitialEvent());
                      context.router.push(const routeFiles.UserRegistrationInfoRoute());
                    },
                  ),
                  const XMargin(10.0),
                  Expanded(
                    child: PrimaryButton.secondaryIconbutton(
                      color: AppColors.secondary,
                      img: Image.asset(
                        Assets.serviceProvider,
                        height: 20.0,
                        width: 20.0,
                        color: AppColors.white,
                      ),
                      text: AppStrings.serviceProvider,
                      onpressed: () {
                        context.read<AuthBloc>().add(const AuthInitialEvent());
                        context.router.push(const routeFiles.ServiceProviderRegistrationInfoRoute());
                      },
                    ),
                  ),
                ],
              ),
              const YMargin(10.0),
            ],
          ),
        ),
      ),
    );
  }

  void _showForgotPasswordDialog(BuildContext context) {
    final TextEditingController forgotEmailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          title: CustomText(
            text: 'Recuperar Contraseña',
            fontColor: AppColors.primary,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ).setText(),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: 'Ingresa tu correo electrónico para recibir instrucciones de recuperación',
                fontColor: AppColors.primary,
                fontSize: 16.0,
                textAlign: TextAlign.center,
              ).setText(),
              const YMargin(20.0),
              CustomTextFieldWidget(
                controller: forgotEmailController,
                maxLength: 40,
                isVisible: true,
                keyboardType: TextInputType.emailAddress,
                hintText: AppStrings.email,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: CustomText(
                text: 'Cancelar',
                fontColor: AppColors.secondary,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ).setText(),
            ),
            ElevatedButton(
              onPressed: () => _handleForgotPassword(context, forgotEmailController.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
              ),
              child: CustomText(
                text: 'Enviar',
                fontColor: AppColors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
              ).setText(),
            ),
          ],
        );
      },
    );
  }

  void _handleForgotPassword(BuildContext context, String email) async {
    if (email.isEmpty) {
      Utils.showAlert(
        title: 'Campo requerido',
        message: 'Por favor ingresa tu correo electrónico',
        context: context,
      );
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      Utils.showAlert(
        title: 'Email inválido',
        message: 'Por favor ingresa un correo electrónico válido',
        context: context,
      );
      return;
    }

    Navigator.of(context).pop(); // Close the dialog

    dynamic loader = Loader.getLoader(context);
    Loader.insertLoader(context, loader);

    try {
      final authRepo = AuthRepo();
      final forgotPasswordRequest = ForgotPasswordRequest(email: email.trim());
      final response = await authRepo.forgotPassword(forgotPasswordRequest);

      Loader.hideLoader(loader);

      if (response.data != null) {
        Utils.showAlert(
          title: 'Correo enviado',
          message: 'Se han enviado las instrucciones de recuperación a tu correo electrónico',
          context: context,
        );
      } else {
        Utils.showAlert(
          title: 'Error',
          message: response.errorMessage ?? 'Error al enviar el correo de recuperación',
          context: context,
        );
      }
    } catch (e) {
      Loader.hideLoader(loader);
      Utils.showAlert(
        title: 'Error',
        message: 'Error al procesar la solicitud',
        context: context,
      );
    }
  }
}
