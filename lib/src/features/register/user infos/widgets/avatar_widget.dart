import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/core/ui/constants.dart';

class AvatarWidget extends StatelessWidget {
  final bool hideUploadButton;
  const AvatarWidget({super.key, this.hideUploadButton = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      /*aumentamos a stack, entao o positioned 
      vai ultrapassar o container */
      height: 102,
      width: 102,
      child: Stack(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageConstants.avatar),
              ),
            ),
          ),
          Positioned(
            //se ficar negativo, fica pra fora, corta do stack
            bottom: 2,
            right: 2,
            child: Offstage(
              offstage: hideUploadButton,
              child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border:
                        Border.all(color: ColorsConstants.greyLight, width: 3)),
                child: const Icon(
                  Icons.add,
                  size: 20,
                  color: ColorsConstants.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
