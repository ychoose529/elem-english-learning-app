import 'package:flutter/material.dart';

void main() {
  runApp(const EnglishApp());
}

class EnglishApp extends StatelessWidget {
  const EnglishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '國小英文學習 App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Center(child: Text('👂 聽力練習 (TTS 朗讀)', style: TextStyle(fontSize: 24))),
    const Center(child: Text('🗣️ 口說挑戰 (語音辨識)', style: TextStyle(fontSize: 24))),
    const Center(child: Text('📖 單字閱讀與圖片', style: TextStyle(fontSize: 24))),
    const Center(child: Text('✍️ 筆順與拼寫練習', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('國小英文樂園 🎈'),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.volume_up), label: '聽'),
          BottomNavigationBarItem(icon: Icon(Icons.mic), label: '說'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: '讀'),
          BottomNavigationBarItem(icon: Icon(Icons.edit), label: '寫'),
        ],
      ),
    );
  }
}
