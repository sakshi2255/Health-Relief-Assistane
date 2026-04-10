import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'main_shell.dart';
import '../services/auth_service.dart';
import '../services/translation_controller.dart';
import '../widgets/tr_text.dart'; // ✅ Added for translations

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isSignup = false;
  bool showPassword = false;
  final AuthService _authService = AuthService();
  String selectedLanguage = 'en';
  bool isLoading = false;
  bool isGoogleLoading = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // ✅ Requirement 1: Responsive width/height detection
    double screenWidth = MediaQuery.of(context).size.width;
    double horizontalPadding = screenWidth > 600 ? 80 : 24;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              const SizedBox(height: 80),

              // --- Header / Logo ---
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF4DB6AC), Color(0xFF00796B)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(LucideIcons.activity, color: Colors.white, size: 32),
                    ),
                    const SizedBox(height: 16),
                    // ✅ Requirement 2: Translated Headers
                    TrText(
                      isSignup ? "Create Account" : "Welcome Back",
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    TrText(
                      isSignup ? "Start your wellness journey" : "Continue your wellness journey",
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // --- Input Fields ---
              if (isSignup) ...[
                _buildTextField(
                  controller: nameController,
                  hint: "Full Name",
                  icon: LucideIcons.user,
                ),
                const SizedBox(height: 16),
              ],
              _buildTextField(
                controller: emailController,
                hint: "Email Address",
                icon: LucideIcons.mail,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: passwordController,
                hint: "Password",
                icon: LucideIcons.lock,
                isPassword: true,
                showPassword: showPassword,
                onTogglePassword: () {
                  setState(() => showPassword = !showPassword);
                },
              ),

              if (!isSignup)
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () async {
                      if (emailController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: TrText("Please enter email first.")),
                        );
                        return;
                      }
                      String? result = await _authService.resetPassword(email: emailController.text.trim());
                      if (result == "success") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: TrText("Reset link sent! Check your email.")),
                        );
                      }
                    },
                    child: const TrText("Forgot Password?",
                        style: TextStyle(color: Color(0xFF00796B), fontWeight: FontWeight.w600)),
                  ),
                ),

              const SizedBox(height: 16),

              // --- Language Selection (Signup Only) ---
              if (isSignup) ...[
                const TrText("Preferred Language / પસંદગીની ભાષા",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),),
                const SizedBox(height: 12),
                // ✅ Use Wrap for chips to prevent horizontal overflow on small screens
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _langChip("English", "en"),
                    _langChip("हिंदी", "hi"),
                    _langChip("ગુજરાતી", "gu"),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              const SizedBox(height: 24),

              // --- Main Action Button ---
              SizedBox(
                width: double.infinity,
                height: 54,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF4DB6AC), Color(0xFF00796B)]),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: TrText("Please fill all fields")),
                        );
                        return;
                      }

                      setState(() => isLoading = true);

                      String? result;
                      if (isSignup) {
                        result = await _authService.signUp(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          name: nameController.text.trim(),
                          preferredLanguage: selectedLanguage,
                        );
                      } else {
                        result = await _authService.logIn(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );
                      }

                      if (result == "success") {
                        await TranslationController.initializeLanguage();
                        if (!mounted) return;
                        setState(() => isLoading = false);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const MainShell()),
                        );
                      } else {
                        setState(() => isLoading = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(result ?? "An error occurred")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: isLoading
                        ? const SizedBox(
                      height: 20, width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                        : TrText(
                      isSignup ? "Sign Up" : "Log In",
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TrText("or", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 20),

              // --- Google Login ---
              OutlinedButton(
                onPressed: () async {
                  setState(() => isGoogleLoading = true);
                  String? result = await _authService.signInWithGoogle();

                  if (result == "success") {
                    await TranslationController.initializeLanguage();
                    if (!mounted) return;
                    setState(() => isGoogleLoading = false);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MainShell()),
                    );
                  } else {
                    setState(() => isGoogleLoading = false);
                    if (result != "User canceled") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result ?? "Google Sign-In Failed")),
                      );
                    }
                  }
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                child: isGoogleLoading
                    ? const SizedBox(
                  height: 20, width: 20,
                  child: CircularProgressIndicator(color: Colors.red, strokeWidth: 2),
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.chrome, size: 20, color: Colors.red),
                    const SizedBox(width: 10),
                    TrText("Continue with Google", style: TextStyle(color: Colors.grey.shade800, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              GestureDetector(
                onTap: () => setState(() => isSignup = !isSignup),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TrText(
                      isSignup ? "Already have an account? " : "Don't have an account? ",
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                    TrText(
                      isSignup ? "Log In" : "Sign Up",
                      style: const TextStyle(color: Color(0xFF00796B), fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _langChip(String label, String code) {
    bool isSelected = selectedLanguage == code;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) {
        if (val) setState(() => selectedLanguage = code);
      },
      selectedColor: const Color(0xFF4DB6AC),
      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 12),
      backgroundColor: Colors.grey.shade100,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool showPassword = false,
    VoidCallback? onTogglePassword,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !showPassword,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        // Note: Field Hints usually use standard Text, but you can wrap with TrText if needed
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        prefixIcon: Icon(icon, size: 18, color: Colors.grey.shade600),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(showPassword ? LucideIcons.eyeOff : LucideIcons.eye, size: 18),
          onPressed: onTogglePassword,
        )
            : null,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
    );
  }
}