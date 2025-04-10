import 'package:flutter/material.dart';
import 'package:festou/src/models/post_model.dart';
import 'package:festou/src/services/post_service.dart';

class PostSinglePage extends StatefulWidget {
  final PostModel postModel;
  const PostSinglePage({super.key, required this.postModel});

  @override
  State<PostSinglePage> createState() => _PostSinglePageState();
}

class _PostSinglePageState extends State<PostSinglePage> {
  @override
  void initState() {
    super.initState();
    if (widget.postModel.id == null) return;
    PostService().setPostAsRead(widget.postModel.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white, // Caso a imagem tenha espaços vazios
          image: DecorationImage(
            image: AssetImage('lib/assets/images/background_confete.png'),
            fit: BoxFit.contain, // Mantém a repetição
            repeat: ImageRepeat.repeat, // Repete a imagem no fundo
          ),
        ),
        child: Stack(
          children: [
            // Fundo com gradiente no topo
            Container(
              height: 350,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xff4300B1),
                    Color.fromARGB(255, 255, 255, 255)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // Conteúdo da página
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),

                // Botão de voltar estilizado
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                          spreadRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),

                // Imagem do post em destaque
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      widget.postModel.imagens.first,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Área de texto (Centralizado com fundo)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.8), // Fundo semi-transparente
                      borderRadius:
                          BorderRadius.circular(12), // Bordas arredondadas
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          spreadRadius: 2,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            widget.postModel.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'NerkoOne',
                              fontSize: 24,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: Text(
                            widget.postModel.description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'Marcellus',
                              fontSize: 16,
                              color: Colors.black54,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Imagens extras em grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: widget.postModel.imagens.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhotoDetailScreen(
                                  photoUrls: widget.postModel.imagens,
                                  initialIndex: index,
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: widget.postModel.imagens[index],
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                widget.postModel.imagens[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PhotoDetailScreen extends StatefulWidget {
  final List<String> photoUrls;
  final int initialIndex;

  const PhotoDetailScreen({
    super.key,
    required this.photoUrls,
    required this.initialIndex,
  });

  @override
  // ignore: library_private_types_in_public_api
  _PhotoDetailScreenState createState() => _PhotoDetailScreenState();
}

class _PhotoDetailScreenState extends State<PhotoDetailScreen> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  void _previousImage() {
    setState(() {
      if (currentIndex == 0) {
        currentIndex = widget.photoUrls.length - 1;
      } else if (currentIndex > 0) {
        currentIndex--;
      }
    });
  }

  void _nextImage() {
    setState(() {
      if (currentIndex == widget.photoUrls.length - 1) {
        currentIndex = 0;
      } else if (currentIndex < widget.photoUrls.length - 1) {
        currentIndex++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 40,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            color: Colors.grey,
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2,
            child: Hero(
              tag: widget.photoUrls[currentIndex],
              child: Image.network(
                widget.photoUrls[currentIndex],
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.photoUrls.map((url) {
                int index = widget.photoUrls.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentIndex == index
                        ? const Color(0xff9747FF)
                        : Colors.grey.shade300,
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: _previousImage,
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: const Icon(
                      Icons.arrow_left,
                      size: 45,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _nextImage,
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: const Icon(
                      Icons.arrow_right,
                      size: 45,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
