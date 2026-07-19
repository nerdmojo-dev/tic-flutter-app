import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tic_task_app/core/riverpod/AuthNotifier.dart';
import 'package:tic_task_app/shared/AppColors.dart';
import 'package:tic_task_app/shared/AppOverlaySnackbar.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _hideCurrentPassword = true;
  bool _hideNewPassword = true;
  bool _hideConfirmPassword = true;
  final passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$',
  );

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _canSubmit = false;

  void _validateForm() {
    final canSubmit =
        _currentPasswordController.text.isNotEmpty &&
        _newPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _newPasswordController.text == _confirmPasswordController.text;

    if (_canSubmit != canSubmit) {
      setState(() {
        _canSubmit = canSubmit;
      });
    }
  }

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;
    
    // TODO: Call your API
    await ref
        .read(authProvider.notifier)
        .changePassword(
          currentPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
        );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    required bool obscure,
    required VoidCallback toggle,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      suffixIcon: IconButton(
        icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
        onPressed: toggle,
      ),
      filled: true,
      errorMaxLines: 3,
      fillColor: Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (previous?.isLoading == true) {
            AppOverlaySnackbar.showSuccess(
              context,
              message: "Password changed successfully",
            );

            Navigator.pop(context);
          }
        },
        error: (error, stackTrace) {
          AppOverlaySnackbar.showError(context, message: error.toString());
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsGeometry.only(left: 10),
                child: const Text(
                  "Change Password",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Current Password",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _currentPasswordController,
                        obscureText: _hideCurrentPassword,
                        decoration: _inputDecoration(
                          hint: "Current password",
                          icon: Icons.key,
                          obscure: _hideCurrentPassword,
                          toggle: () {
                            setState(() {
                              _hideCurrentPassword = !_hideCurrentPassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter current password";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "New Password",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _newPasswordController,
                        obscureText: _hideNewPassword,
                        onChanged: (_) => _validateForm(),

                        decoration: _inputDecoration(
                          hint: "New password",
                          icon: Icons.lock,

                          obscure: _hideNewPassword,
                          toggle: () {
                            setState(() {
                              _hideNewPassword = !_hideNewPassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.length < 8) {
                            return "Minimum 8 characters";
                          }

                          if (!passwordRegex.hasMatch(value)) {
                            return "Password must contain uppercase, lowercase, number and special character.";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Confirm Password",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _hideConfirmPassword,
                        onChanged: (_) => _validateForm(),

                        decoration: _inputDecoration(
                          hint: "Confirm new password",
                          icon: Icons.lock,
                          obscure: _hideConfirmPassword,
                          toggle: () {
                            setState(() {
                              _hideConfirmPassword = !_hideConfirmPassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value != _newPasswordController.text) {
                            return "Passwords do not match";
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 30),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _canSubmit ? _updatePassword : null,

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: const Color.fromARGB(
                              255,
                              117,
                              119,
                              124,
                            ).withOpacity(0.8),
                            disabledForegroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Update Password",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
