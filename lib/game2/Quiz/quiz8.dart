import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:game_somo/game2/Level/Jump8.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

import '../../components/game_button.dart';
import '../GameJump.dart';
import '../components/BackButtonOverlay.dart';

class Quiz8 extends StatefulWidget {
  final VoidCallback? onResumeMusic; // Add this property

  const Quiz8({Key? key, this.onResumeMusic}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _Quiz8State createState() => _Quiz8State();
}

class _Quiz8State extends State<Quiz8> {
  List<Question> questions = [
    // Add your questions here, following the same format as below:
      Question(
      "คำถาม\n My birthday’s ______ 16th.",
      ["April", "Friday", "Tuesday", "Monday"],
      0,
    ),
     Question(
      "คำถาม\n twenty-first + October = ________",
      ["It’s October 1st.", "It’s October 31st.", "It’s October 11th.", "It’s October 21st."],
      3,
    ),
     Question(
      "คำถาม\n ลําดับที่ 9",
      ["nine", "ninety", "ninth", "nineteen"],
      2,
    ),
     Question(
      "คำถาม\n Valentine’s Day is on ________.",
      ["February the fourth", "February the fortieth", "February the fourteen", "February the fourteenth"],
      3,
    ),
     Question(
      "คำถาม\n A : Where _______ Mr. Bancha at 11:00a.m.?\nB : He ________ on the bus.",
      ["is, was", "was, was", "were, was", "was, were"],
      1,
    ),
     Question(
      "คำถาม\n My sister _______ shop her clothes yesterday.",
      ["isn’t", "don’t", "didn’t", "doesn’t"],
      2,
    ),
     Question(
      "คำถาม\n My grandmother ________ in the pool.",
      ["is going to draw", "are going to draw", "is going to swim", "are going to swim"],
      2,
    ),
     Question(
      "คำถาม\nOur family _______ to Chiangmai.",
      ["is going to travel", "going to travel", "are going to travel", "going travel"],
      0,
    ),
     Question(
      "คำถาม\n Pannee and Pimrata are _____ home now.",
      ["going to come", "comes", "came", "going come"],
      0,
    ),
     Question(
      "คำถาม\n Cold season is in _______ in Thailand.",
      ["June", "May", "April", "December"],
      3,
    ),
    // More questions...
  ];

  late List<Question> remainingQuestions;
  late Question currentQuestion;
  int? selectedAnswerIndex;
  bool showAnswer = false;
  int incorrectAnswers = 0;
  int answeredQuestions = 0;
  int incorrectAnswers8 = 0;
  int answeredQuestions8 = 0;
  final int maxIncorrectAnswers = 2;
  final int totalQuestions = 2;
  final Random random = Random();
  final AudioPlayer audioPlayer = AudioPlayer();

   @override
  void initState() {
    super.initState();
    remainingQuestions = List.from(questions);
    _loadRandomQuestion();
    _loadAnswerCounts();
  }

  Future<void> _loadAnswerCounts() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      incorrectAnswers8 = prefs.getInt('incorrectAnswers8') ?? 0;
      answeredQuestions8 = prefs.getInt('answeredQuestions8') ?? 0;
    });
  }

  Future<void> _saveAnswerCounts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('incorrectAnswers8', incorrectAnswers8);
    await prefs.setInt('answeredQuestions8', answeredQuestions8);
  }

  void _loadRandomQuestion() {
    setState(() {
      if (remainingQuestions.isEmpty) {
        remainingQuestions = List.from(questions);
      }
      currentQuestion = remainingQuestions
          .removeAt(random.nextInt(remainingQuestions.length));
      selectedAnswerIndex = null;
      showAnswer = false;
    });
  }

  void _checkAnswer(int selectedIndex) {
    if (selectedAnswerIndex != null) return; // Prevent multiple presses

    setState(() {
      selectedAnswerIndex = selectedIndex;
      showAnswer = true;
      if (selectedIndex == currentQuestion.correctAnswerIndex) {
        _playCorrectAnswerSound();
        answeredQuestions++;
        answeredQuestions8++;        
      } else {
        _playIncorrectAnswerSound();
        incorrectAnswers++;
        incorrectAnswers8++;
      }
      _saveAnswerCounts();
    });



    // Delay to show the answer before loading the next question
    Future.delayed(const Duration(seconds: 2), () {
      if (answeredQuestions >= totalQuestions) {
        _showCompletionScreen();
      } else if (incorrectAnswers >= maxIncorrectAnswers) {
        // _resetQuiz();  //  <-- Remove this line
        _showFailScreen(); // <-- Add this line
      } else {
        _loadRandomQuestion();
      }
    });
  }

  void _playCorrectAnswerSound() async {
    await audioPlayer.play(AssetSource('sounds/correct.mp3'));
  }

  void _playIncorrectAnswerSound() async {
    await audioPlayer.play(AssetSource('sounds/wrong-buzzer.mp3'));
  }

  void _resetQuiz() {
    setState(() {
      incorrectAnswers = 0;
      answeredQuestions = 0;
      remainingQuestions = List.from(questions);
      _loadRandomQuestion();
    });
  }

  void _showCompletionScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => GameWidget(
          game: Jump8(),
          overlayBuilderMap: {
            'BackButton': (context, game) => BackButtonOverlay(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => GameJump()),
                    );
                  },
                  onResumeMusic: () {},
                ),
          },
        ),
      ),
    );
  }

void _showFailScreen() {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevent closing by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.black.withOpacity(0.7), // Semi-transparent black background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: Column(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 50,
            ),
            SizedBox(height: 10),
            Text(
              'เสียใจด้วย',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
        content: Text(
          'คุณต้องการลองอีกครั้งหรือไม่?',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white, // Ensure text is readable on dark background
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // ปิด AlertDialog
                Navigator.pop(context); // กลับไปหน้าหลัก
                widget.onResumeMusic?.call(); // Call the function to resume music
              },
              child: Text(
                'ออกจากเกม',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetQuiz();
              },
              child: Text(
                'ลองอีกครั้ง',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}

// void showExitDialog(BuildContext context, Function? onResumeMusic) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Exit the game'),
//           content: Text('Do you want to quit the game?'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // ปิด AlertDialog
//                 // ออกจากเกมส์โดยไม่ทำอะไร
//               },
//               child: Text('No'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(builder: (context) => GameJump()),
//                     );
//                     Navigator.of(context).pop();
//                 onResumeMusic?.call(); // Call the function to resume music
//               },
//               child: Text('Yes'),
//             ),
//           ],
//         );
//       },
//     );
//   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/images/01.png"), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),
                        Expanded(
                                child: Text(
                                  'Quiz',
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,color: const Color.fromARGB(255, 3, 232, 221))
                                  ),
                                ),
                              
                        Row(
                          children: [
                            const SizedBox(width: 30),
                            Image.asset(
                              'assets/gamecard/bg_3.png', // ระบุเส้นทางของรูปภาพ
                              height: 145,
                              width: 150,
                            ),
                            // const SizedBox(width: 10),
                            Container(
                              height: 100,
                              width: 500,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(
                                    0.8), // Semi-transparent white background
                                borderRadius: BorderRadius.circular(60.0),
                              ),
                              child: Text(
                                currentQuestion.text,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontFamily: 'Itim-Regular',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
                          child: Column(
                            children: [
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildAnswerButton(0),
                                  const SizedBox(
                                      width: 10), // Space between buttons
                                  _buildAnswerButton(1),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildAnswerButton(2),
                                  const SizedBox(
                                      width: 10), // Space between buttons
                                  _buildAnswerButton(3),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnswerButton(int index) {
    Color buttonColor;
    if (showAnswer) {
      if (index == currentQuestion.correctAnswerIndex) {
        buttonColor = Colors.green;
      } else if (index == selectedAnswerIndex) {
        buttonColor = Colors.red;
      } else {
        buttonColor = const Color.fromARGB(255, 216, 125, 7);
      }
    } else {
      buttonColor = const Color.fromARGB(255, 216, 125, 7);
    }

    return Expanded(
      child: PixelGameButton(
        height: 50,
        width: 120,
        text: currentQuestion.answers[index],
        onTap: () {
          _checkAnswer(index);
        },
        onTapUp: () {},
        onTapDown: () {},
        onTapCancel: () {},
        backgroundColor: buttonColor,
        textColor: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class Question {
  final String text;
  final List<String> answers;
  final int correctAnswerIndex;

  Question(this.text, this.answers, this.correctAnswerIndex);
}
