import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class GameOverOverlay extends StatelessWidget {
  final VoidCallback onRestart;

  const GameOverOverlay({Key? key, required this.onRestart}) : super(key: key);

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/01.png'), // ใช้พื้นหลังแบบพิกเซล
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Stack(
            children: [
              SizedBox(height: 10),
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 60),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                                'assets/gamecard/bg_3.png', // ระบุเส้นทางของรูปภาพ
                                height: 145,
                                width: 130,
                              ),
                          Container(
                            width: 500, // กำหนดความกว้าง
                            height: 90, // กำหนดความยาว
                  
                            padding: const EdgeInsets.all(
                                16), // เพิ่ม padding ภายใน Container
                            decoration: BoxDecoration(
                              color: Colors.white, // สีพื้นหลังที่โปร่งแสง
                              border: Border.all(
                                color: Colors.white, // สีของกรอบ
                                width: 2, // ความหนาของกรอบ
                              ),
                              borderRadius:
                                  BorderRadius.circular(20), // มุมโค้งของกรอบ
                            ),
                  
                            child: const Text(
                              'ใกล้แล้วเชียว! เดี๋ยวเอาใหม่!',
                              style: TextStyle(
                                fontFamily: 'Itim-Regular',
                                fontSize: 40,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                        width: 20,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 90,
                            ),
                            ElevatedButton(
                              onPressed: onRestart,
                              child: Text(
                                'ลองอีกครั้ง',
                                style: TextStyle(
                                  fontFamily: 'Itim-Regular',
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                FlameAudio.bgm.stop();
                                Navigator.of(context).pop();
                                // Navigator.pushReplacement(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => const GameJump()),
                                // );
                              },
                              child: Text(
                                'กลับหน้าหลัก',
                                style: TextStyle(
                                  fontFamily: 'Itim-Regular',
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
