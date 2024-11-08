import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  Uint8List? _imageData;
  String? _imageUrl;
  String? _apiResult;
  bool _isUploading = false;
  List<dynamic> registros = [];

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _imageData = result.files.single.bytes;
        _imageUrl = null;
        _apiResult = null;
        _isUploading ? null : _uploadImage();
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
      final String fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.png';

      final response = await Supabase.instance.client.storage.from('dispositivos-bb').uploadBinary(fileName, _imageData!);

      final String url = Supabase.instance.client.storage.from('dispositivos-bb').getPublicUrl(fileName);
      
      setState(() {
        _imageUrl = url;
      });

      print("Imagem carregada com sucesso: $url");

      await _sendImageUrlToApi(url);
    } catch (e) {
      print('Erro ao fazer upload: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _sendImageUrlToApi(String imageUrl) async {
    try {
      final response = await http.post(
        Uri.parse('https://api-visaocomp.onrender.com/predict/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"image_url": imageUrl}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        setState(() {
          _apiResult = result.toString();
        });

        print("Resultado da API: $result");
      } else {
        print("Erro ao chamar a API: ${response.statusCode}");
      }
    } catch (e) {
      print("Erro na requisição para a API: $e");
    }
  }

  List<String> _parseDetectedDevices(Map<String, dynamic> apiResponse) {
    final detections = apiResponse['devices']['detections'] as List<dynamic>;
    final List<String> detectedDeviceNames = [];

    for (var detection in detections) {
      final category = detection['categories'][0]['category_name'];
      if (category != null) {
        detectedDeviceNames.add(category.toString().toLowerCase());
      }
    }
    return detectedDeviceNames;
  }

  Future<void> _fetchRegistros() async {
    try {
      final registros = await Supabase.instance.client.from('registros').select();

      print("Dados da tabela registros: $registros");

      //   if (response.error == null) {
      //     setState(() {
      //       registros = response.data as List<dynamic>;
      //     });
      //     print("Dados da tabela registros: $registros");
      //   } else {
      //     print("Erro ao buscar registros: ${response.error!.message}");
      //   }
    } catch (e) {
      print("Erro ao buscar registros: $e");
    }
  }

  List<String> _extractDeviceNames(Map<String, dynamic> apiResponse) {
    final devices = apiResponse['devices'] as List<dynamic>;
    return devices.map((device) => device[0].toString()).toList();
  }

  @override
  void initState() {
    super.initState();
    _fetchRegistros();
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
                                Text(
                                  _apiResult != null ? _apiResult!.substring(10) : 'Identificando...',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _apiResult != null
                                      ? 'Este dispositivo com defeito podem ser desmontados para aproveitar componentes de placas de circuito e outros itens valiosos.'
                                      : 'Identificando...',
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
                        : const Text("Sim", style: TextStyle(color: Colors.white)),
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
                        _apiResult = null;
                      });
                    },
                    child: const Text("Não", style: TextStyle(color: Colors.white)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      side: const BorderSide(color: Colors.green),
                    ),
                  ),
                ],
              )
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
