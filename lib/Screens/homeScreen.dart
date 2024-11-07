import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  List<dynamic> matchesData = [];
  bool isLoading = true;

 Future<void> _fetchMatchData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
    });
      setState(() {
        isLoading = false;
      });
    }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    await _fetchMatchData();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            child: Column(
              children: [
                
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}