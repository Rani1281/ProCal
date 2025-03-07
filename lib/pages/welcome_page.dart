import 'package:flutter/material.dart';
import 'package:procal/pages/authentication/main_auth.dart';
import 'package:procal/models/auth_page_design.dart';
import 'package:procal/components/my_button.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            // Upper column
            const Column(
              children: [
                SizedBox(height: 75),
                Text(
                  'Welcome to PROCAL!',
                  style: TextStyle(
                    fontSize: 26,
                  ),
                ),
                
              ],
            ),

            // Bottom column
            Column(
              children: [
                const Text(
                  'Please choose one of theese sign in methods:'
                ),
                const SizedBox(height: 10),

                // Email & password button
                MyButton(
                  text: 'Email & Password',
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MainAuthPage(destination: AuthPages.signUp))),
                  icon: const Icon(Icons.key),
                ),

                const SizedBox(height: 8),

                MyButton(
                  text: 'Continue With Google',
                  onPressed: () {},
                  bgColor: Colors.purpleAccent,
                ),

                const SizedBox(height: 8),

                MyButton(
                  text: 'Sign In Anonimously',
                  onPressed: () {},
                  bgColor: Colors.grey[350],
                  icon: const Icon(Icons.person),
                ),

                // Continue with google button

                // Anonymous sign in

              ],
              
            ),
          ],
        ),
      ),


    );
  }
}