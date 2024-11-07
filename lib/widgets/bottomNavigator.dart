import 'package:flutter/material.dart';
import 'package:hackathon/Screens/rankingScreen.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../Screens/scanScreen.dart';
import '../Screens/historicoScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onTabChange(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: const [
          ScanScreen(), // Tela de Jogos
          HistoricoScreen(), // Tela de Canhotos
          RankingScreen(), // Tela de Insights
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onTabChange: _onTabChange,
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChange;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onTabChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff0f1821),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
        child: GNav(
          backgroundColor: const Color(0xff0f1821),
          color: Colors.white,
          activeColor: Colors.white,
          tabBackgroundColor: Color(0xFF0D513B),
          gap: 10,
          padding: const EdgeInsets.all(14),
          tabs: const [
            GButton(
              icon: FeatherIcons.maximize,
              text: 'Scan',
            ),
            GButton(
              icon: FeatherIcons.clock,
              text: 'Histórico',
            ),
            GButton(
              icon: FeatherIcons.barChart2,
              text: 'Ranking',
            ),
          ],
          selectedIndex: selectedIndex,
          onTabChange: onTabChange,
        ),
      ),
    );
  }
}