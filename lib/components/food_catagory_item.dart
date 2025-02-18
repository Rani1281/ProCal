import 'package:flutter/material.dart';

class FoodCatagoryItem extends StatelessWidget {
  const FoodCatagoryItem({super.key, required this.imgPath, required this.text,});

  final String imgPath;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Image.asset(
              imgPath,
              fit: BoxFit.cover, // This will scale and crop the image to fill the space
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.5),
              colorBlendMode: BlendMode.darken,
            ),
            Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ] 
        ),
      ),
    );
  }
}