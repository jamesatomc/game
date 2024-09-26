import 'package:flutter/material.dart';

class Howtoplay2 extends StatefulWidget {
  final VoidCallback? onResumeMusic; // Add this property

  const Howtoplay2({Key? key, this.onResumeMusic}) : super(key: key);

  @override
  State<Howtoplay2> createState() => _Howtoplay2State();
}

class _Howtoplay2State extends State<Howtoplay2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/gamecard/bg_pixel2.png"), // Replace with your image path
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              color: const Color.fromARGB(255, 13, 13, 13),
                              iconSize: 30,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            Expanded(
                              child: Text(
                                'How to play',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // const SizedBox(width: 50),
                            Image.asset(
                              'assets/gamecard/bg_3.png', // ระบุเส้นทางของรูปภาพ
                              height: 150,
                              width: 150,
                            ),
                            // const SizedBox(width: 10),
                            Container(
                              height: 150,
                              width: 450,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(
                                    0.8), // Semi-transparent white background
                                borderRadius: BorderRadius.circular(60.0),
                              ),
                              child: Text(
                                "วิธีการเล่น\nเกมจับคู่มหาสนุก\n1. ผู้เล่นจะต้องจับคู่คำศัพท์ภาษาอังกฤษกับรูปภาพให้ถูกต้อง\n""2. ผู้เล่นต้องจับคู่ให้ถูกต้องครบทุกคู่ภายในเวลา 80 วินาที\n3.ผู้เล่นจะต้องจับคู่ให้มีคะแนนรวม 7 คะแนน จึงจะผ่านด่าน",
                                textAlign: TextAlign.start,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // const SizedBox(width: 150),
                            // const SizedBox(width: 10),
                            Container(
                              height: 300,
                              width: 450,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(
                                    0.8), // Semi-transparent white background
                                borderRadius: BorderRadius.circular(60.0),
                              ),
                              child: Text(
                                "วิธีการเล่น\nเกมหนูน้อยผจญภัย\n1. ผู้เล่นจะต้องตอบคำถามภาษาอังกฤษให้ถูกทั้งหมด 2 ข้อ  จึงจะเริ่มการผจญภัยได้ \n""2. การควบคุมการเดินไปซ้าย-ขวาตัวละครโดยจอยสติ๊ก\n3. ควบคุมการกระโดดของตัวละครโดยใช้ปุ่ม Jump\n4. จะต้องเก็บเหรียญในด่านให้ครบทุกเหรียญจึงจะปลดล็อคด่านถัดไป\n5. ตัวละครจะมีพลังชีวิตหัวใจ 3 ดวง\n6. เมื่อชนกับมอนสเตอร์หรืออุปสรรคต่างๆตัวละครจะกลับมาจุดเริ่มต้นใหม่ทุกครั้ง และพลังชีวิตจะลดลงทีละ 1 ใจ",
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontFamily: 'Itim-Regular',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Image.asset(
                              'assets/gamecard/bg_3.png', // ระบุเส้นทางของรูปภาพ
                              height: 150,
                              width: 150,
                            ),
                            
                          ],
                        ),
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
}
