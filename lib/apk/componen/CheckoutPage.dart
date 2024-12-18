import 'package:flutter/material.dart';

class CheckoutPage extends StatefulWidget {
  final List selectedProducts;

  const CheckoutPage({Key? key, required this.selectedProducts}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _selectedPaymentMethod = 'Pengiriman'; // Default method
  String _selectedPaymentOption = ''; // Default empty payment option
  bool _isBNISelected = false;
  bool _isDanaSelected = false;
  bool _isQRISSelected = false;

  @override
  Widget build(BuildContext context) {
    if (widget.selectedProducts.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Checkout'),
        ),
        body: const Center(
          child: Text('No products selected for checkout'),
        ),
      );
    }

    // Menghitung total harga produk yang dipilih
    double totalPrice = widget.selectedProducts.fold(0.0, (total, product) {
      final productPrice = double.tryParse(product["product_price"]?.toString() ?? '0') ?? 0.0;
      final quantity = product["quantity"] ?? 0;
      return total + (productPrice * quantity);
    });

    // Menambahkan biaya pengiriman dan pajak (contoh)
    double shippingFee = 5000.0; // Misalnya biaya pengiriman tetap
    double tax = totalPrice * 0.1; // 10% pajak

    // Menghitung total akhir
    double finalTotal = totalPrice + shippingFee + tax;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: [
          // Menampilkan rincian produk yang dipilih
          Column(
            children: widget.selectedProducts.map((product) {
              final imageUrl = product["image_url"] ?? '';
              final productName = product["product_name"] ?? "Produk";
              final productPrice = double.tryParse(product["product_price"]?.toString() ?? '0') ?? 0.0;
              final quantity = product["quantity"] ?? 0;

              final fullImageUrl = 'http://10.0.2.2:5000$imageUrl';

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                child: Row(
                  children: [
                    // Product Image
                    Image.network(
                      fullImageUrl,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 70);
                      },
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Name
                          Text(
                            productName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          // Quantity and Price Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Qty: $quantity',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                "Rp ${productPrice.toStringAsFixed(0)}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          // Rincian pembayaran dalam Container yang lebih estetis
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,  // Latar belakang yang lebih terang
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header untuk rincian pembayaran
                Text(
                  'Payment Summary',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade700,
                  ),
                ),
                const SizedBox(height: 12),

                // Total Price
                _buildPaymentDetail('Total Price', totalPrice),

                // Shipping Fee
                _buildPaymentDetail('Shipping Fee', shippingFee),

                // Tax
                _buildPaymentDetail('Tax (10%)', tax),

                // Final Total
                _buildPaymentDetail('Total Payment', finalTotal),
              ],
            ),
          ),

          // Semua dalam satu Container untuk Payment Method
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Teks "Select Payment Method"
                Text(
                  'Select Payment Method',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade700,
                  ),
                ),
                const SizedBox(height: 8),

                // Pilihan Pengiriman
                ExpansionTile(
                  title: const Text('Pengiriman'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16), // Tanda panah '>'
                  children: [
                    ListTile(
                      leading: Checkbox(
                        value: _isBNISelected,
                        onChanged: (bool? value) {
                          setState(() {
                            _isBNISelected = value ?? false;
                            if (_isBNISelected) {
                              _selectedPaymentOption = 'BNI';
                            }
                          });
                        },
                      ),
                      title: const Text('BNI'),
                    ),
                    ListTile(
                      leading: Checkbox(
                        value: _isDanaSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            _isDanaSelected = value ?? false;
                            if (_isDanaSelected) {
                              _selectedPaymentOption = 'Dana';
                            }
                          });
                        },
                      ),
                      title: const Text('Dana'),
                    ),
                    ListTile(
                      leading: Checkbox(
                        value: _isQRISSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            _isQRISSelected = value ?? false;
                            if (_isQRISSelected) {
                              _selectedPaymentOption = 'QRIS';
                            }
                          });
                        },
                      ),
                      title: const Text('QRIS'),
                    ),
                  ],
                ),

                // Pilihan Ambil di Toko
                ListTile(
                  title: const Text('Ambil di Toko'),
                  trailing: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPaymentMethod = 'Ambil di Toko';
                        _selectedPaymentOption = ''; // Reset payment option
                      });
                    },
                    child: const Text('Change', style: TextStyle(color: Colors.blue)),
                  ),
                  onTap: () {
                    setState(() {
                      _selectedPaymentMethod = 'Ambil di Toko';
                      _selectedPaymentOption = ''; // No shipping method needed
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            // Logic for proceeding with the payment
            print('Proceeding with checkout for selected products');
            print('Selected payment method: $_selectedPaymentMethod');
            print('Selected payment option: $_selectedPaymentOption');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 52.0),
            textStyle: const TextStyle(fontSize: 18),
            foregroundColor: Colors.white,
          ),
          child: const Text('Proceed to Payment'),
        ),
      ),
    );
  }

  // Widget untuk detail pembayaran
  Widget _buildPaymentDetail(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            "Rp ${amount.toStringAsFixed(0)}",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
