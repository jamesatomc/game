 import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:game_somo/game2/Level/Jump10.dart';
import 'dart:math';

import '../../components/game_button.dart';
import '../GameJump.dart';
import '../components/BackButtonOverlay.dart';

class Quiz10 extends StatefulWidget {
  final VoidCallback? onResumeMusic; // Add this property

  const Quiz10({Key? key, this.onResumeMusic}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _Quiz10State createState() => _Quiz10State();
}

class _Quiz10State extends State<Quiz10> {
  List<Question> questions = [
    // Add your questions here, following the same format as below
    Question(
      "คำถาม\nWhat is the fifth month of the year?",
      ["May", "June", "March", "December"],
      0,
    ),
    Question(
      "คำถาม\nมิถุนายน26th = _______.",
      ["July the twenty-six", "July the twentieth-six", "June the twenty-sixth", "June twenty-sixth"],
      2,
    ),
    Question(
      "คำถาม\nA : It’s _________________.\nB : Close your eyes. There is a lot of_______.",
      ["warm, water", "sunny, water", "windy, dust", "cloudy, dust"],
      2,
    ),
    Question(
      "คำถาม\n Yuri and her sister________ shop for clothes the day after tomorrow.",
      ["was going to", "going to", "isn’t going to", "aren’t going to"],
      3,
    ),
    Question(
      "คำถาม\nA : Were you at the subway station at 7:00?\nB :____________.",
      ["No, I don't.", "No, I weren't.", "No, I didn't.", "No, I wasn't."],
      3,
    ),
    Question(
      "คำถาม\nNatty and Tommy _______ this morning.",
      ["reads the books", "read the books", "rode the books", "to read the books"],
      1,
    ),
    Question(
      "คำถาม\nSura ______ go on vacation with his family today.",
      ["went", "is going", "is going to", "are going to"],
      2,
    ),
    Question(
      "คำถาม\nWe ______ meet some friends tomorrow.",
      ["are going to", "are going", "is going to", "went"],
      0,
    ),
    Question(
      "คำถาม\n My father and I ______ at home at 14:30.We______ fixing the hang glider.",
      ["was, were", "does, do", "do, was", "were, were"],
      3,
    ),
    Question(
      "คำถาม\n ________ your brother going to write his letters tonight?",
      ["Is", "Are", "Do", "Will"],
      0,
    ),
    // More questions...
  ];
    
      late List<Question> remainingQuestions;
  late Question currentQuestion;
  int? selectedAnswerIndex;
  bool showAnswer = false;
  int incorrectAnswers = 0;
  int answeredQuestions = 0;
  final int maxIncorrectAnswers = 2;
  final int totalQuestions = 2;
  final Random random = Random();
  final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    remainingQuestions = List.from(questions);
    _loadRandomQuestion();
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
      } else {
        _playIncorrectAnswerSound();
        incorrectAnswers++;
      }
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
          game: Jump10(),
          overlayBuilderMap: {
            'BackButton': (context, game) => BackButtonOverlay(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => GameJump()),
                    );
                  }, onResumeMusic: () {},
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
          title: const Text('เสียใจด้วย'),
          content: const Text('คุณต้องการลองอีกครั้งหรือไม่?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pop(context);
                widget.onResumeMusic?.call(); // Call the function to resume music
              },
              child: const Text('ออกจากเกม'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetQuiz();
              },
              child: const Text('ลองอีกครั้ง'),
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
