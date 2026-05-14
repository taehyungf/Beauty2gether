import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service.dart';
import 'add_product_screen.dart';
import 'login_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<ProductModel>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = ApiService.getProducts();
  }

  void _refresh() {
    setState(() {
      _futureProducts = ApiService.getProducts();
    });
  }

  Future<void> _deleteProduct(int id) async {
    final ok = await ApiService.deleteProduct(id);
    if (ok) {
      _refresh();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk dihapus')),
      );
    }
  }

  void _showSubmitDialog() {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final githubCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFFFDF6F0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Submit Tugas',
            style: TextStyle(
                color: Color(0xFF5C3D2E), fontWeight: FontWeight.bold)),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _dialogField(nameCtrl, 'Nama Produk', Icons.spa_outlined),
                const SizedBox(height: 8),
                _dialogField(priceCtrl, 'Harga', Icons.attach_money,
                    isNumber: true),
                const SizedBox(height: 8),
                _dialogField(descCtrl, 'Deskripsi', Icons.description_outlined),
                const SizedBox(height: 8),
                _dialogField(githubCtrl, 'GitHub URL', Icons.link),
              ],
            ),
          ),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFD4826A)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Batal',
                style: TextStyle(color: Color(0xFFD4826A))),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFD4826A),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              Navigator.pop(ctx);
              final result = await ApiService.submitTugas(
                name: nameCtrl.text,
                price: int.tryParse(priceCtrl.text) ?? 0,
                description: descCtrl.text,
                githubUrl: githubCtrl.text,
              );
              if (!mounted) return;
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(result['message'] ?? 'Submit selesai')),
              );
            },
            child:
                const Text('Submit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _dialogField(
      TextEditingController ctrl, String label, IconData icon,
      {bool isNumber = false}) {
    return TextFormField(
      controller: ctrl,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFD4826A)),
        filled: true,
        fillColor: Colors.white,
        border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: (v) =>
          (v == null || v.isEmpty) ? '$label wajib diisi' : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFD6CC),
        elevation: 0,
        title: Row(
          children: const [
            Icon(Icons.spa, color: Color(0xFFD4826A)),
            SizedBox(width: 8),
            Text('Beauty 2gether',
                style: TextStyle(
                    color: Color(0xFF5C3D2E),
                    fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload_file, color: Color(0xFFD4826A)),
            tooltip: 'Submit Tugas',
            onPressed: _showSubmitDialog,
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFD4826A)),
            onPressed: () async {
              await ApiService.deleteToken();
              if (!mounted) return;
              // ignore: use_build_context_synchronously
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD4826A),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddProductScreen()),
          );
          _refresh();
        },
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFD4826A)),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Terjadi kesalahan: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red)),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.spa_outlined,
                      size: 60, color: Color(0xFFD4826A)),
                  SizedBox(height: 12),
                  Text(
                    'Belum ada produk.\nTambahkan produk skincare kamu!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFB08B7A)),
                  ),
                ],
              ),
            );
          }

          final products = snapshot.data!;
          return RefreshIndicator(
            color: const Color(0xFFD4826A),
            onRefresh: () async => _refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final p = products[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.withOpacity(0.07),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        //iconproduk
                        Container(
                          width: 90,
                          height: 90,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFD6CC),
                            borderRadius: BorderRadius.horizontal(
                                left: Radius.circular(16)),
                          ),
                          child: const Icon(
                            Icons.spa,
                            color: Color(0xFFD4826A),
                            size: 40,
                          ),
                        ),
                        //infoproduk
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF5C3D2E),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Rp ${p.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    color: Color(0xFFD4826A),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  p.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFFB08B7A),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        //tomboldelete
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap: () => _deleteProduct(p.id),
                            child: const Icon(
                              Icons.delete_outline,
                              color: Color(0xFFD4826A),
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}