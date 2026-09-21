import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

void main() {
  runApp(const ElementaryEnglishApp());
}

class ElementaryEnglishApp extends StatelessWidget {
  const ElementaryEnglishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '國小英文聽說讀寫樂園',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFFFFF9E6),
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
    );
  }
}

class LearningCard {
  final String word;
  final String translation;
  final String sentence;
  final String imageUrl;

  LearningCard({
    required this.word,
    required this.translation,
    required this.sentence,
    required this.imageUrl,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final TextEditingController _writingController = TextEditingController();

  int _currentIndex = 0;
  bool _isListening = false;
  String _spokenText = "";
  String _feedbackMessage = "";

  final List<LearningCard> _cards = [
    LearningCard(
      word: "Apple",
      translation: "蘋果",
      sentence: "I eat a red apple every day.",
      imageUrl: "https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=500",
    ),
    LearningCard(
      word: "Dog",
      translation: "小狗",
      sentence: "The dog is barking happily.",
      imageUrl: "https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=500",
    ),
    LearningCard(
      word: "Cat",
      translation: "小貓",
      sentence: "The cat is sleeping on the chair.",
      imageUrl: "https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=500",
    ),
    LearningCard(
      word: "Elephant",
      translation: "大象",
      sentence: "An elephant has a long nose.",
      imageUrl: "https://images.unsplash.com/photo-1557050543-4d5f4e07ef46?w=500",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initTts();
  }

  void _initTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.4);
  }

  void _speak(String text) async {
    await _flutterTts.speak(text);
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) {
            setState(() {
              _spokenText = val.recognizedWords;
              if (_spokenText.toLowerCase().contains(_cards[_currentIndex].word.toLowerCase())) {
                _feedbackMessage = "🎉 太棒了！發音非常標準！";
              } else {
                _feedbackMessage = "💪 再試一次喔！加油！";
              }
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void _checkWriting() {
    setState(() {
      if (_writingController.text.trim().toLowerCase() == _cards[_currentIndex].word.toLowerCase()) {
        _feedbackMessage = "🌟 拼字完全正確！太厲害了！";
      } else {
        _feedbackMessage = "❌ 拼錯囉，再仔細看一次圖片下的單字！";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentCard = _cards[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("🎈 國小英文聽說讀寫樂園", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.network(
                        currentCard.imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      currentCard.word,
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                    ),
                    Text(
                      currentCard.translation,
                      style: const TextStyle(fontSize: 22, color: Colors.grey),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "📖 閱讀句型：",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _speak(currentCard.word),
                  icon: const Icon(Icons.volume_up, size: 28),
                  label: const Text("聽發音", style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _listen,
                  icon: Icon(_isListening ? Icons.mic : Icons.mic_none, size: 28),
                  label: Text(_isListening ? "聆聽中..." : "練習說", style: const TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isListening ? Colors.redAccent : Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                ),
              ],
            ),
            if (_spokenText.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text("你說的是：", style: const TextStyle(fontSize: 16, color: Colors.blueGrey)),
              ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _writingController,
                        decoration: const InputDecoration(
                          hintText: "✍️ 練習拼寫這個單字...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.check_circle, color: Colors.orange, size: 32),
                      onPressed: _checkWriting,
                    )
                  ],
                ),
              ),
            ),
            if (_feedbackMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  _feedbackMessage,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                ),
              ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _currentIndex > 0
                      ? () => setState(() {
                            _currentIndex--;
                            _feedbackMessage = "";
                            _spokenText = "";
                            _writingController.clear();
                          })
                      : null,
                  child: const Text("⬅️ 上一個"),
                ),
                ElevatedButton(
                  onPressed: _currentIndex < _cards.length - 1
                      ? () => setState(() {
                            _currentIndex++;
                            _feedbackMessage = "";
                            _spokenText = "";
                            _writingController.clear();
                          })
                      : null,
                  child: const Text("下一關 ➡️"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}