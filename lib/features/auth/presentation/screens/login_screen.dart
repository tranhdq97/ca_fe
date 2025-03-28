import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/models/app_route.dart';
import '../../../../core/models/user_type.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../services/auth_service.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../../../shared/widgets/loading_indicator.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isStaffMode = false; // Toggle for staff mode
  bool isButtonEnabled = false; // Track button state

  final _formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  void initState() {
    super.initState();

    // Listen to changes in the input fields
    phoneController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      if (isStaffMode) {
        // Enable button only if both phone and password are filled in staff mode
        isButtonEnabled = phoneController.text.isNotEmpty &&
            passwordController.text.isNotEmpty;
      } else {
        // Enable button only if phone is filled in client mode
        isButtonEnabled = phoneController.text.isNotEmpty;
      }
    });
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final phone = phoneController.text.trim();
      final password = passwordController.text.trim();

      // Call login API
      final authController =
          Provider.of<AuthController>(context, listen: false);

      try {
        await AuthService.savePhoneNumber(phone); // Save phone number
        await AuthService.saveLoggedInStatus(true); // Save password
        if (isStaffMode) {
          // Staff mode login
          await authController.loginStore(phone, password);

          // Save logged-in status and user type
          await AuthService.saveUserType(
              UserType.staff); // Save user type as enum

          // Navigate to staff home
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.getRoute(AppRoute.staffHome),
          );
        } else {
          // Client mode login
          await authController.loginClient(phone);

          // Save logged-in status and user type
          await AuthService.saveUserType(
              UserType.client); // Save user type as enum

          // Navigate to client home
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.getRoute(AppRoute.clientHome),
          );
        }
      } catch (error) {
        // Handle login error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppStrings.loginFailed)), // Use centralized string
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.login), // Use centralized string
        backgroundColor: AppColors.primaryBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Toggle for Staff Mode
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          isStaffMode
                              ? AppStrings.staffMode
                              : AppStrings
                                  .clientMode, // Use centralized strings
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Switch(
                          value: isStaffMode,
                          activeColor: AppColors.primaryBlue,
                          onChanged: (value) {
                            setState(() {
                              isStaffMode = value;
                              _updateButtonState(); // Update button state when mode changes
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),

                    // Phone Number Field
                    AppTextField(
                      controller: phoneController,
                      hintText:
                          AppStrings.phoneNumber, // Use centralized string
                      prefixIcon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: Validators.validatePhoneNumber,
                    ),
                    SizedBox(height: 16.0),

                    // Password Field (Only for Staff Mode)
                    if (isStaffMode)
                      AppTextField(
                        controller: passwordController,
                        hintText: AppStrings.password, // Use centralized string
                        prefixIcon: Icons.lock,
                        obscureText: true,
                        validator: Validators.validatePassword,
                      ),
                    if (isStaffMode) SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),

            // Login Button
            AppButton(
              text: AppStrings.login, // Use centralized string
              backgroundColor: isButtonEnabled
                  ? AppColors.primaryBlue
                  : AppColors.grey, // Disable button color
              textColor: AppColors.white,
              onPressed: isButtonEnabled
                  ? _login
                  : () {}, // Provide a no-op function when disabled
            ),
            SizedBox(height: 16.0),

            // Loading Indicator (Optional)
            Consumer<AuthController>(
              builder: (context, authController, child) {
                if (authController.isLoading) {
                  return LoadingIndicator();
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
