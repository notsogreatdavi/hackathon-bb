import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoricoScreen extends StatefulWidget {
  const HistoricoScreen({Key? key}) : super(key: key);

  @override
  _HistoricoScreenState createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen> {
  List<Map<String, dynamic>> pendentes = [];
  List<Map<String, dynamic>> entregues = [];
  bool mostrarQRCode = false;
  String? userId;

  @override
  void initState() {
    super.initState();
    obterUsuarioAtual(); // Obter o ID do usuário autenticado
  }

  // Função para obter o ID do usuário autenticado
  Future<void> obterUsuarioAtual() async {
    final user = Supabase.instance.client.auth.currentUser;
    setState(() {
      userId = user?.id; // Armazena o ID do usuário
    });
    if (userId != null) {
      await carregarHistorico(userId!); // Carregar histórico apenas do usuário atual
    }
  }

  Future<void> carregarHistorico(String userId) async {
    final response = await Supabase.instance.client
        .from('registros')
        .select()
        .eq('id-usuario', userId); // Filtra registros pelo ID do usuário

    if (response.error == null) {
      final data = (response as List).cast<Map<String, dynamic>>();

      setState(() {
        pendentes = data.where((item) => item['status'] == false).toList();
        entregues = data.where((item) => item['status'] == true).toList();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar histórico')),
      );
    }
  }

  // Função para mostrar o QR Code quando o botão "Entregar" é pressionado
  void gerarQRCode() {
    setState(() {
      mostrarQRCode = true;
    });
  }

  // Widget para exibir cada item com a imagem e descrição
  Widget buildItemTile(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: item['img-url'] != null
            ? Container(
                width: 60, // Largura máxima para a imagem
                height: 60, // Altura máxima para a imagem
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                clipBehavior: Clip.hardEdge,
                child: CachedNetworkImage(
                  imageUrl: item['img-url'],
                  fit: BoxFit.contain,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.broken_image, size: 50),
                ),
              )
            : Icon(Icons.device_unknown, size: 50),
        title: Text(
          item['nome-dispositivo'],
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        subtitle: Text(
          'Pontos: ${item['pontos']}',
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF105D44),
      appBar: AppBar(
        title: const Text('Recollet'),
        titleTextStyle: TextStyle(
          fontSize: 19,
          color: Colors.white
        ),
        backgroundColor: const Color(0xFF105D44),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título dos itens pendentes
            const Text(
              'Itens pendentes',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pendentes.length,
                itemBuilder: (context, index) {
                  final item = pendentes[index];
                  return buildItemTile(item);
                },
              ),
            ),
            const SizedBox(height: 20),

            // Botão Entregar
            Center(
              child: ElevatedButton(
                onPressed: pendentes.isNotEmpty ? gerarQRCode : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Entregar'),
              ),
            ),
            const SizedBox(height: 20),

            // Título dos itens entregues
            const Text(
              'Itens entregues',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: entregues.length,
                itemBuilder: (context, index) {
                  final item = entregues[index];
                  return buildItemTile(item);
                },
              ),
            ),
            const SizedBox(height: 20),

            // QR Code e Instruções
            if (mostrarQRCode && userId != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Recicle!',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Apresente esse Qrcode em um dos pontos de coleta indicados para descartar o produto e receber seus pontos',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  QrImageView(
                    data: '$userId', // Gera o link com o ID do usuário
                    version: QrVersions.auto,
                    size: 200.0,
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

extension on PostgrestList {
  get error => null;
}