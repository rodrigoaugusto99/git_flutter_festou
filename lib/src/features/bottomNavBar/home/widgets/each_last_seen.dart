import 'package:festou/src/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:festou/src/features/space%20card/widgets/new_card_info.dart';
import 'package:festou/src/models/space_model.dart';

class EachLastSeen extends StatefulWidget {
  final SpaceModel space;
  const EachLastSeen({
    super.key,
    required this.space,
  });

  @override
  State<EachLastSeen> createState() => _EachLastSeenState();
}

class _EachLastSeenState extends State<EachLastSeen> {
  double get _rating => double.tryParse(widget.space.averageRating) ?? 0;

  @override
  Widget build(BuildContext context) {
    final ratingColor = _getColor(_rating);

    return GestureDetector(
      onTap: () {
        UserService().updateLastSeen(widget.space.spaceId);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewCardInfo(spaceId: widget.space.spaceId),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 20),
        height: 150,
        width: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (widget.space.imagesUrl.isNotEmpty)
                Image.network(
                  widget.space.imagesUrl[0],
                  fit: BoxFit.cover,
                )
              else
                Container(color: Colors.grey.shade300),

              // Soft fade on the right so the strip reads better
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 72,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Colors.black.withOpacity(0),
                        Colors.black.withOpacity(0.28),
                      ],
                    ),
                  ),
                ),
              ),

              // Vertical strip: rating only, clean and readable
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 46,
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.88),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.65),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: ratingColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: ratingColor.withOpacity(0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 12,
                              color: Colors.white,
                            ),
                            Text(
                              _rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: Container(
                          width: 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(99),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                ratingColor.withOpacity(0.85),
                                ratingColor.withOpacity(0.1),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Icon(
                        Icons.visibility_rounded,
                        size: 16,
                        color: ratingColor.withOpacity(0.85),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color _getColor(double averageRating) {
  if (averageRating >= 4) {
    return const Color(0xFF22A06B);
  } else if (averageRating >= 2 && averageRating < 4) {
    return const Color(0xFFE67E22);
  } else {
    return const Color(0xFFE74C3C);
  }
}
