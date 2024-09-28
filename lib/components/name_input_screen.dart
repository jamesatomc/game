import 'package:flutter/material.dart';
import 'package:game_somo/manu_game.dart';


class NameInputScreen extends StatefulWidget {
  final Function(String) onSave;

  const NameInputScreen({required this.onSave, Key? key}) : super(key: key);

  @override
  State<NameInputScreen> createState() => NameInputScreenState();
}

class NameInputScreenState extends State<NameInputScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/gamecard/bg_pixel2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child:  SingleChildScrollView(
                child: Container(
                  height: 340,
                  width: 450,
                  // alignment: Alignment.center,
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 247, 248, 249)
                        .withOpacity(0.8), // Semi-transparent white background
                    borderRadius: BorderRadius.circular(60.0),
                  ),
                  child: Center(
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/gamecard/bg_3.png', // ระบุเส้นทางของรูปภาพ
                              height: 130,
                              width: 130,
                            ),
                            // const SizedBox(width: 10),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 50),
                            Container(
                              height: 50,
                              width: 280,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(
                                    0.8), // Semi-transparent white background
                                borderRadius:
                                    BorderRadius.circular(60), // Rounded corners
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Text(
                                "What's your name ?",
                                style: TextStyle(
                                  fontFamily: 'Itim-Regular',
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 50,
                              width: 280,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 113, 113, 113)
                                    .withOpacity(0.7), // Semi-transparent black
                                borderRadius:
                                    BorderRadius.circular(60), // Rounded corners
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: TextField(
                                controller: _nameController,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Itim-Regular',
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                                decoration: const InputDecoration(
                                  fillColor: Colors.transparent,
                                  border: InputBorder.none,
                                  hintText: 'Your Name',
                                  hintStyle: TextStyle(
                                    fontFamily: 'Itim-Regular',
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 221, 220, 220),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                if (_nameController.text.isNotEmpty) {
                                  widget.onSave(_nameController.text);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ManuGame(
                                          username: _nameController.text),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                "OK",
                                style: TextStyle(
                                  fontFamily: 'Itim-Regular',
                                  fontSize: 18,
                                  color: const Color.fromARGB(255, 250, 249, 249),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
