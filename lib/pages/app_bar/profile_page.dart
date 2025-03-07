import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:procal/pages/authentication/main_auth.dart';
import 'package:procal/models/delete_user_result.dart';
import 'package:procal/services/firebase_auth.dart';
import 'package:procal/services/firebase_firestore.dart';
import 'package:procal/models/auth_page_design.dart';
import 'package:procal/models/my_toast.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final AuthService _auth = AuthService();

  String? email;
  String? username;
  String? photoURL;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAllUserInfo();
  }

  void fetchAllUserInfo() {
    User user = FirebaseAuth.instance.currentUser!;
    // set state
    setState(() {
      email = user.email;
      username = user.displayName;
      photoURL = user.photoURL;

      isLoading = false;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: isLoading
      ? const Center(child: CircularProgressIndicator())
      : Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image(
                  image: NetworkImage(
                    photoURL!,
                  ),
                  fit: BoxFit.cover,
                  width: 130,
                  height: 130,
                  loadingBuilder: (context, child, loadingProgress) {
                    if(loadingProgress == null) {
                      return child;
                    }
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const CircularProgressIndicator();
                        // Maybe need to pop
                      },
                    );
                    return const SizedBox();
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Image(
                      image: AssetImage('assets/profile.png'),
                    );
                  },
                )
              ),
            ),
            const Divider(height: 50),

            // Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Username'),
                Text(username ?? 'Empty'),

                const SizedBox(height: 10),
                
                const Text('Email'),
                Text(email ?? 'Empty'),
                
                const Divider(height: 50),
              ],
            ),
            
            
            Column(
              children: [
              // Log out button
                ElevatedButton(
                  onPressed: () {
                    _auth.signOut();
                    _auth.signOutGoogle();
                    Navigator.pop(context);
                  },
                  child: const Text('Log Out')
                ),
                const SizedBox(height: 15),

                // Delete account button
                ElevatedButton(
                  onPressed: null,
                 child: const Text('Delete Account')
                ),
              ],
            )
          ],
        ),
      )
    );
  }

  // Future<void> deleteUser() async {
  //   if(user != null){
  //     var result = await _auth.deleteUserAccount();
  //     if(result != null) {

  //       //MyToast.show(result[1]);
  //       if(result[0] == false) { // didn't work
  //         Navigator.push(
  //           context, MaterialPageRoute(
  //             builder: (context) => const MainAuthPage(destination: AuthPages.reAuth)
  //           )
  //         );
  //       }
  //       else {

  //       }
  //     }
  //   }
  // }
}