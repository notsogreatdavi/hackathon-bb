import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({Key? key}) : super(key: key);

  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  List<Map<String, dynamic>> ranking = [];
  String? userId;
  Map<String, String> userNames = {}; // Para armazenar nomes de usuários
  Map<String, String> userPhotos = {}; // Para armazenar fotos dos usuários

  @override
  void initState() {
    super.initState();
    obterUsuarioAtual();
    carregarRanking();
  }

  Future<void> obterUsuarioAtual() async {
    final user = Supabase.instance.client.auth.currentUser;
    setState(() {
      userId = user?.id; // Armazena o ID do usuário autenticado
    });
  }

  Future<void> carregarRanking() async {
    try {
      // Consulta para obter id_usuario e pontos da tabela registros
      final response = await Supabase.instance.client
          .from('registros')
          .select('id-usuario, pontos');

      if (response == null) {
        throw Exception('Erro ao carregar dados: resposta vazia.');
      }

      final data = (response as List).cast<Map<String, dynamic>>();

      // Agrupar e somar pontos por usuário
      final Map<String, int> pontosPorUsuario = {};
      for (var item in data) {
        final idUsuario = item['id-usuario'] as String?;
        final pontos = item['pontos'] as int?;

        if (idUsuario != null && pontos != null) {
          pontosPorUsuario[idUsuario] = (pontosPorUsuario[idUsuario] ?? 0) + pontos;
        }
      }

      // Converte para lista e ordena por pontos (decrescente)
      ranking = pontosPorUsuario.entries
          .map((e) => {'id-usuario': e.key, 'pontos': e.value})
          .toList();
      ranking.sort((a, b) => b['pontos'].compareTo(a['pontos']));

      // Carregar os nomes e fotos dos usuários da tabela "usuarios"
      await carregarNomesUsuarios(pontosPorUsuario.keys.toList());

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar ranking: $e')),
      );
    }
  }

  Future<void> carregarNomesUsuarios(List<String> idsUsuarios) async {
    try {
      // Usando a condição "or" para filtrar múltiplos IDs
      final response = await Supabase.instance.client
          .from('usuarios')
          .select('id, "nome-completo", foto') // Agora estamos pegando também a foto
          .filter('id', 'in', idsUsuarios);

      if (response == null) {
        throw Exception('Erro ao carregar nomes dos usuários: resposta vazia.');
      }

      final data = (response as List).cast<Map<String, dynamic>>();

      // Armazenar nomes e fotos de usuários no map
      for (var item in data) {
        final idUsuario = item['id'] as String?;
        final nomeUsuario = item['nome-completo'] as String?;
        final fotoUsuario = item['foto'] as String?; // Foto do usuário

        if (idUsuario != null && nomeUsuario != null && fotoUsuario != null) {
          userNames[idUsuario] = nomeUsuario;
          userPhotos[idUsuario] = fotoUsuario; // Adicionando o link da foto no map
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar nomes de usuários: $e')),
      );
    }
  }

  // Método para construir o item de cada participante no ranking
  Widget buildRankingTile(int posicao, String nomeUsuario, int pontos, bool isUser, String fotoUrl) {
    return Card(
      color: isUser ? Colors.green[200] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(fotoUrl), // Usando a foto do usuário
        ),
        title: Text(
          '#$posicao - $nomeUsuario',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text('$pontos Reciclacoins'),
        trailing: isUser
            ? Icon(Icons.star, color: Colors.amber)
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF105D44),
      appBar: AppBar(
        backgroundColor: const Color(0xFF105D44),
        title: Text("Recollet"),
        titleTextStyle: TextStyle(
          fontSize: 19,
          color: Colors.white
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ranking de Reciclados',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Exibir o ranking completo
            Expanded(
              child: ListView.builder(
                itemCount: ranking.length,
                itemBuilder: (context, index) {
                  final posicao = index + 1;
                  final usuario = ranking[index];
                  final idUsuario = usuario['id-usuario'];
                  final nomeUsuario = userNames[idUsuario] ?? 'Usuário Desconhecido';
                  final pontos = usuario['pontos'];
                  final fotoUrl = userPhotos[idUsuario] ?? 'https://example.com/default-avatar.jpg'; // Foto padrão

                  final isUser = idUsuario == userId;

                  return buildRankingTile(posicao, nomeUsuario, pontos, isUser, fotoUrl);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}