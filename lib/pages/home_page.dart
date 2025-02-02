import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:procal/pages/main_auth.dart';
import 'package:procal/services/delete_user_result.dart';
import 'package:procal/services/firebase_auth.dart';
import 'package:procal/widgets/auth_page_design.dart';
import 'package:procal/widgets/my_toast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final AuthService _auth = AuthService();
  final User? user = FirebaseAuth.instance.currentUser;
  final MyToast toast = MyToast();


  Future<void> deleteUser() async {
    if(user != null){
      DeleteUserResult? result = await _auth.deleteUserAccount();
      if(result != null) {
        toast.show(result.errorMessage!);
        if(result.isSuccessful == false) {
          // Navigate to re-login page
          Navigator.push(
            context, MaterialPageRoute(
              builder: (context) => const MainAuthPage(destination: AuthPages.reAuth)
            )
          );
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Home Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Welcome To PROCAL ! ${FirebaseAuth.instance.currentUser!.displayName}"),
              const SizedBox(height: 15),

              // Log out button
              ElevatedButton(
                onPressed: () {
                  _auth.signOut();
                  _auth.signOutGoogle();
                },
                child: const Text('Log Out')
              ),
              const SizedBox(height: 15),

              // Delete account button
              ElevatedButton(
                onPressed: () => deleteUser(),
                child: const Text('Delete Account')
              ),

              // Upgrade account button (in anon)
              // isAnon()
              // ? ElevatedButton(
              //   onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MainAuthPage(destination: AuthPages.upgrade))),
              //   child: const Text('Upgrade Account')
              // )
              // : const SizedBox(),

            ],
          ),
        ),
      ),
    );
  }

  bool isAnon() {
    if (user!.isAnonymous) {
      return true;
    }
    return false;
  }

  
}