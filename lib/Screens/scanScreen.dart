import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  Uint8List? _imageData;
  String? _imageUrl;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _imageData = result.files.single.bytes;
        _imageUrl = null; // Limpa a URL anterior ao selecionar nova imagem
      });
    } else {
      print("Nenhum arquivo selecionado.");
    }
  }

  Future<void> _uploadImage() async {
    if (_imageData == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      // Nome único para o arquivo
      final String fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.png';

      // Faz o upload da imagem para o Supabase
      final response = await Supabase.instance.client.storage.from('dispositivos-bb').uploadBinary(fileName, _imageData!);

      // if (response.error != null) {
      //   print('Erro ao fazer upload: ${response.error!.message}');
      //   setState(() {
      //     _isUploading = false;
      //   });
      //   return;
      // }

      // Obtém a URL pública da imagem
      final String url = Supabase.instance.client.storage.from('dispositivos-bb').getPublicUrl(fileName);

      setState(() {
        _imageUrl = url;
      });

      print("Imagem carregada com sucesso: $url");
    } catch (e) {
      print('Erro ao fazer upload: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D513B),
      appBar: AppBar(
        title: const Text('Identificação'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _imageData != null
                  ? Stack(
                      children: [
                        Positioned.fill(
                          child: Image.memory(
                            _imageData!,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.center,
                                colors: [
                                  Colors.black.withOpacity(0.5),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text(
                                  "Roteador Wifi",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "Roteadores Wi-Fi com defeito podem ser desmontados para aproveitar componentes como antenas, placas de circuito...",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: Text(
                        "Nenhuma imagem selecionada.",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text("Selecionar Imagem"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            if (_imageData != null) ...[
              const Text(
                "Está correto?",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _isUploading ? null : _uploadImage,
                    child: _isUploading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : const Text("Sim"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                  const SizedBox(width: 20),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _imageData = null;
                        _imageUrl = null;
                      });
                    },
                    child: const Text("Não"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      side: const BorderSide(color: Colors.green),
                      textStyle: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              if (_imageUrl != null) ...[
                const SizedBox(height: 20),
                Text(
                  "Imagem carregada com sucesso:",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  _imageUrl!,
                  style: TextStyle(color: Colors.blueAccent),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
