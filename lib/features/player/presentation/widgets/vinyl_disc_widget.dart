import 'package:flutter/material.dart';

class VinylDiscWidget extends StatelessWidget {
  final Animation<double> animation;
  final String imageUrl;

  const VinylDiscWidget({
    super.key,
    required this.animation,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: animation,
      child: Container(
        width: 280,
        height: 280,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
          border: Border.all(color: Colors.grey.shade900, width: 4),
        ),
        child: Center(
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade900,
              border: Border.all(color: Colors.black, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}
