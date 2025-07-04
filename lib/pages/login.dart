import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:weather_app/pages/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[700],
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //  Sun and Cloud with Rain
                Column(
                  children: [
                    Icon(Icons.wb_sunny, size: 48, color: Colors.yellowAccent),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.cloud, size: 80, color: Colors.white),
                        Positioned(
                          bottom: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.grain,
                                size: 16,
                                color: Colors.lightBlue[100],
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.grain,
                                size: 16,
                                color: Colors.lightBlue[100],
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.grain,
                                size: 16,
                                color: Colors.lightBlue[100],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                  ],
                ),

                // Login title
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 40),

                // Email
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Password
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Login Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900],
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    final email = emailController.text.trim();
                    final password = passwordController.text;
                    // correct credentials
                    const correctEmail = 'Osasu419@gmail.com';
                    const correctPassword = '001220';
                    if (email == correctEmail && password == correctPassword) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Incorrect Password or Email',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      );
                    }
                  },
                  child: Text('Login'),
                ),

                // Forgot Password Link
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // Add forgot password action here
                    log('Forgot password tapped');
                  },
                  child: Text(
                    'Forgot password?',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
