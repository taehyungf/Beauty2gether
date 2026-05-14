import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  bool _isLoading = false;

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final product = ProductModel(
      id: 0,
      name: _nameCtrl.text,
      price: double.tryParse(_priceCtrl.text) ?? 0,
      description: _descCtrl.text,
      createdAt: '',
    );

    final ok = await ApiService.addProduct(product);
    setState(() => _isLoading = false);

    if (!mounted) return;
    if (ok) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil ditambahkan!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menambahkan produk')),
      );
    }
  }

  Widget _field(TextEditingController ctrl, String label, IconData icon,
      {bool isNumber = false, int maxLines = 1}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFFB08B7A)),
        prefixIcon: Icon(icon, color: const Color(0xFFD4826A)),
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
          borderSide: const BorderSide(color: Color(0xFFD4826A), width: 2),
        ),
      ),
      validator: (v) => (v == null || v.isEmpty) ? '$label wajib diisi' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD6CC),
        elevation: 0,
        title: const Text('Tambah Produk',
            style: TextStyle(
                color: Color(0xFF5C3D2E), fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Color(0xFF5C3D2E)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner ilustrasi
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD6CC),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.spa, size: 36, color: Color(0xFFD4826A)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Tambahkan produk skincare favoritmu ke katalog!',
                        style: TextStyle(color: Color(0xFF5C3D2E), fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _field(_nameCtrl, 'Nama Produk', Icons.spa_outlined),
              const SizedBox(height: 14),
              _field(_priceCtrl, 'Harga (Rp)', Icons.attach_money, isNumber: true),
              const SizedBox(height: 14),
              _field(_descCtrl, 'Deskripsi', Icons.description_outlined, maxLines: 4),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _isLoading ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFD4826A),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Simpan Produk',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}