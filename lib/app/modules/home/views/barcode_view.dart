import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({Key? key}) : super(key: key);

  @override
  _BarcodeScannerState createState() => _BarcodeScannerState();
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  String _scannedBarcode = '';
  List<String> _barcodeHistory = [];
  final FocusNode _focusNode = FocusNode();
  String _buffer = '';
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    // Tự động focus khi widget được tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _processBarcode() {
    if (_buffer.isNotEmpty) {
      setState(() {
        _scannedBarcode = _buffer;
        _barcodeHistory.insert(0, '${DateTime.now()}: $_buffer');
        _buffer = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          // Reset debounce timer
          _debounceTimer?.cancel();

          if (event.logicalKey == LogicalKeyboardKey.enter) {
            _processBarcode();
          } else {
            // Thêm ký tự vào buffer
            if (event.character != null) {
              _buffer += event.character!;

              // Đặt debounce timer để xử lý trường hợp nhập tay
              _debounceTimer = Timer(const Duration(milliseconds: 100), () {
                if (_buffer.isNotEmpty) {
                  _processBarcode();
                }
              });
            }
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Barcode Scanner'),
        ),
        body: GestureDetector(
          // Giữ focus khi tap vào bất kỳ đâu trên màn hình
          onTap: () {
            FocusScope.of(context).requestFocus(_focusNode);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hiển thị barcode hiện tại
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Scanned Barcode:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _scannedBarcode.isEmpty
                            ? 'Waiting for scan...'
                            : _scannedBarcode,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Lịch sử quét
                const Text(
                  'Scan History:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: _barcodeHistory.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(_barcodeHistory[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.copy),
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(
                                  text: _barcodeHistory[index].split(': ')[1],
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Copied to clipboard'),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        // Hiển thị trạng thái focus
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _barcodeHistory.clear();
              _scannedBarcode = '';
            });
          },
          child: const Icon(Icons.clear_all),
          tooltip: 'Clear History',
        ),
      ),
    );
  }
}
