import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'product_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nimController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final result = await ApiService.login(_nimController.text.trim());
      if (!mounted) return;
      if (result['success'] == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProductListScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Login gagal!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F0),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD6CC),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(Icons.spa, size: 52, color: Color(0xFFD4826A)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Center(
                    child: Text(
                      'Beauty 2gether',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5C3D2E),
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      'Your skincare catalog app',
                      style: TextStyle(color: Color(0xFFB08B7A), fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 40),

                  //NIM
                  const Text('NIM',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Color(0xFF5C3D2E))),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nimController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Masukkan NIM kamu',
                      prefixIcon: const Icon(Icons.person_outline,
                          color: Color(0xFFD4826A)),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFEDD5C8)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFEDD5C8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                            color: Color(0xFFD4826A), width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'NIM tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  //password
                  const Text('Password',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Color(0xFF5C3D2E))),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Masukkan password kamu',
                      prefixIcon: const Icon(Icons.lock_outline,
                          color: Color(0xFFD4826A)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: const Color(0xFFD4826A),
                        ),
                        onPressed: () =>
                            setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFEDD5C8)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFEDD5C8)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                            color: Color(0xFFD4826A), width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 28),

                  //loginButton
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      onPressed: _isLoading ? null : _login,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFD4826A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Masuk',
                              style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}