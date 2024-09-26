import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

import '../../components/game_button.dart';
import '../GameJump.dart';
import '../Level/Jump1.dart';
import '../components/BackButtonOverlay.dart';

class Quiz1 extends StatefulWidget {
  final VoidCallback? onResumeMusic; // Add this property

  const Quiz1({Key? key, this.onResumeMusic}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _Quiz1State createState() => _Quiz1State();
}

class _Quiz1State extends State<Quiz1> {
  List<Question> questions = [
    // Add your questions here, following the same format as below:
    Question(
      'คำถาม\n___________is my favorite food.',
      ["Chicken ", "An elephant", "A wardrobe ", "A blue dress "],
      0,
    ),
    Question(
      'คำถาม\n______________is for taking photos',
      ["A radio ", "A recordt", "A camera ", "A computer "],
      2,
    ),
    Question(
      'คำถาม\nSam is my______________________friend.',
      ["best", "well", "most", "better than"],
      0,
    ),
    Question(
      'คำถาม\n Oranges, apples, pineapples are___________.',
      ["food", "fruits", "clothes", "vegetables"],
      1,
    ),
    Question(
      'คำถาม\n We are very happy today. We_________and  laugh.',
      ["cry ", "sleep", "smile", "bother"],
      2,
    ),
    Question(
      'คำถาม\n A : I failed my English test.\n B : Oh,___________________.',
      ["Thank you", "I am sorry to hear that","That’s good", "Congratulations"],
      1,
    ),
    Question(
      'คำถาม\n A : Give me the book,please?\n B :_________________.',
      ["It’s me", "Here it is", "You are here", "Here you are"],
      3,
    ),
    Question(
      'คำถาม\n A : Nice to meet you.\n B : ________.',
      ["Goodbye", "Nice to meet you ,too"," I’m OK.", "See you soon"],
      1,
    ),
    Question(
      'คำถาม\n  A : Sorry.I’m late.\n  B : ____________.',
      ["Sure", "All  right", "Of course", "That’s  OK"],
      3,
    ),
    Question(
      'คำถาม\n A : How much is it?\n B : It’s_______.',
      ["delicious", "very cheap", "not expensive", "25 baht,please."],
      3,
    ),
    
  ];

  late List<Question> remainingQuestions;
  late Question currentQuestion;
  int? selectedAnswerIndex;
  bool showAnswer = false;
  int incorrectAnswers = 0;
  int answeredQuestions = 0;
  final int maxIncorrectAnswers = 2;
  final int totalQuestions = 3;
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
      if (selectedIndex != currentQuestion.correctAnswerIndex) {
        incorrectAnswers++;
      }
      if (selectedIndex == currentQuestion.correctAnswerIndex) {
        _playCorrectAnswerSound();
      } else {
        _playIncorrectAnswerSound();
      }
      answeredQuestions++;
    });


    // Delay to show the answer before loading the next question
    Future.delayed(const Duration(seconds: 3), () {
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
          game: Jump1(),
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
          title: const Text('เสียใจด้วย'),
          content: const Text('คุณต้องการลองอีกครั้งหรือไม่?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context); // Go back to the previous screen
                widget.onResumeMusic
                    ?.call(); // Call the function to resume music
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 30),
                            Image.asset(
                              'assets/gamecard/bg_3.png', // ระบุเส้นทางของรูปภาพ
                              height: 145,
                              width: 130,
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
