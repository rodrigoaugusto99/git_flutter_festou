import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class SearchButton extends StatefulWidget {
  final Duration fadeInDuration;
  const SearchButton({required this.fadeInDuration, super.key});

  @override
  State<SearchButton> createState() => _SearchButtonState();
}

class _SearchButtonState extends State<SearchButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: FadeInDown(
        duration: widget.fadeInDuration,
        from: 24,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/home/search_page');
            },
            child: Ink(
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE8DFF8)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7C3AED).withOpacity(0.07),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      color: Color(0xFF7C3AED),
                      size: 22,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: Color(0xFF8A8096),
                          ),
                          children: [
                            TextSpan(text: 'Buscar no '),
                            TextSpan(
                              text: 'Festou',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1C1426),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Icon(
                      Icons.tune_rounded,
                      color: Color(0xFFB5A9C5),
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
