
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vet_internal_ticket/app_icons.dart';
import 'package:vet_internal_ticket/app_image.dart';
import 'package:vet_internal_ticket/components/text.dart';
import 'package:vet_internal_ticket/theme/app_padding.dart';
import 'package:vet_internal_ticket/utils/colors.dart';
import 'package:vet_internal_ticket/view/auth/presentation/controller/auth_controller.dart';
import '../../../../utils/bottom_sheets/button.dart';
import '../../../../utils/global.dart';
import '../../../../utils/style.dart';

// ignore: must_be_immutable
class LoginScreen extends GetView<AuthController> {
  LoginScreen({super.key});
  final _formKey = GlobalKey<FormState>();
  FocusNode usernameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.large),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildLogo(),
                  _buildUserName(context),
                  _buildPassword(),
                  SizedBox(
                    height: 20,
                  ),
                  _buildButtonLogin(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildButtonLogin() {
    return Obx(() {
      final isLoading = controller.uiState.value.isLoading;
      return Button(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.primaryColor,
          onTap: isLoading ? null : () => controller.onTapLogin(_formKey),
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text(
                  "ចូលប្រើប្រាស់",
                  style: TextStyle(color: Colors.white),
                ));
    });
  }

  _buildLogo() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.bigger),
      child: Align(
        alignment: Alignment.topCenter,
        child: Image.asset(AppImages.IM_VET_Ticket, width: 150, height: 150),
      ),
    );
  }

  _buildUserName(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextExtraMedium(text: "គណនី"),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: TextFormField(
            controller: controller.userController,
            focusNode: usernameFocusNode,
            autofocus: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            style: const TextStyle(fontSize: 15),
            validator: (String? value) {
              return checkLength(
                  value!, 4, 'Username Required', 'Username Incorrect');
            },
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(passwordFocusNode);
            },
            decoration: InputDecoration(
              isDense: true,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12),
                child: Image(
                  image: AssetImage(AppIcons.IC_person),
                  width: 5,
                ),
              ),
              hintText: 'ឈ្មោះអ្នកប្រើប្រាស់',
              enabledBorder: outlineInputBorder(),
              border: outlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppPadding.bigger),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextExtraMedium(text: "ពាក្យសម្ងាត់"),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Obx(() {
              final isPass = controller.uiState.value.isPass;
              return TextFormField(
                controller: controller.passwordController,
                focusNode: passwordFocusNode,
                obscureText: isPass,
                autofocus: false,
                obscuringCharacter: '*',
                autovalidateMode: AutovalidateMode.onUserInteraction,
                style: const TextStyle(fontSize: 15),
                validator: (String? value) {
                  return checkLength(
                      value!, 1, 'Password Request', 'Password Incorrect');
                },
                decoration: InputDecoration(
                  fillColor: Colors.amber,
                  isDense: true,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Image(
                      image: AssetImage(AppIcons.IC_key_lock),
                      width: 5,
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      controller.uiState.update((val) {
                        val?.isPass = !val.isPass;
                      });
                    },
                    icon: Icon(
                        isPass ? Icons.visibility : Icons.visibility_off_sharp),
                  ),
                  hintText: 'ពាក្យសម្ងាត់',
                  enabledBorder: outlineInputBorder(),
                  border: outlineInputBorder(),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
