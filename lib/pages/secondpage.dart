import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.blue[900],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Icon(Icons.menu, color: Colors.white),
          title: Row(
            children: [
              Text('Apapa', style: TextStyle(color: Colors.white)),
              Icon(Icons.location_on, color: Colors.white),
            ],
          ),
          actions: [Icon(Icons.search, color: Colors.white)],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 70),
                  Container(
                    height: 400,
                    width: 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.white,
                          const Color.fromARGB(255, 21, 100, 218),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 52, 100, 173),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'The probability',
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                  Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.white,
                          const Color.fromARGB(255, 21, 100, 218),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        height: 200,
                        width: 175,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.white,
                              const Color.fromARGB(255, 21, 100, 218),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        height: 200,
                        width: 175,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.white,
                              const Color.fromARGB(255, 21, 100, 218),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        height: 200,
                        width: 175,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.white,
                              const Color.fromARGB(255, 21, 100, 218),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        height: 200,
                        width: 175,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.white,
                              const Color.fromARGB(255, 21, 100, 218),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 50,
                    width: double.infinity,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.white,
                          const Color.fromARGB(255, 21, 100, 218),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
