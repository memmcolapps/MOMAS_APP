import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:momaspayplus/utils/colors.dart';

class RatingStar extends StatelessWidget {
  const RatingStar({
    super.key,
    required this.rating,
  });

  final String rating;

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      rating: double.parse(rating),
      direction: Axis.horizontal,
      itemCount: 5,
      itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
      itemBuilder: (context, _) => Icon(
        Icons.star_rounded,
        color: Colors.green ,
      ),
      itemSize: 20,
    );
  }
}
