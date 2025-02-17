import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:procal/pages/auth_pages/main_auth.dart';
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

  final User? user = FirebaseAuth.instance.currentUser;
  final AuthService _auth = AuthService();
  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(

      appBar: AppBar(
        title: const Text('Profile'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  user?.photoURL
                  ?? 'https://static-00.iconduck.com/assets.00/profile-circle-icon-512x512-zxne30hp.png',
                  fit: BoxFit.cover,
                  height: 130,
                  width: 130,
                  
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.account_circle);
                  },
                ),
              ),
            ),
            const Divider(height: 50),

            // Info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Username'),
                Text(user?.displayName ?? 'Empty'),

                const SizedBox(height: 10),
                
                const Text('Email'),
                Text(user?.email ?? 'Empty'),
                
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
                  onPressed: () {
                    deleteUser();
                    Navigator.pop(context);
                  },
                 child: const Text('Delete Account')
                ),
              ],
            )
          ],
        ),
      )
    );
  }

  Future<void> deleteUser() async {
    if(user != null){
      DeleteUserResult? result = await _auth.deleteUserAccount();
      if(result != null) {
        MyToast.show(result.errorMessage!);
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
}