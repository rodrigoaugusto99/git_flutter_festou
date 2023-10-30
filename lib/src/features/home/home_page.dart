import 'package:flutter/material.dart';
import 'package:git_flutter_festou/src/features/home/widgets/app_bar_home.dart';
import 'package:git_flutter_festou/src/features/home/widgets/menu_space_types.dart';
import 'package:git_flutter_festou/src/features/home/widgets/search_button.dart';
import 'package:git_flutter_festou/src/features/home/widgets/space_buttons.dart';

class HomePage extends StatefulWidget {
  final String? previousRoute;

  const HomePage({this.previousRoute, Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final fadeInDuration = (widget.previousRoute == '/home/search_page')
        ? const Duration(milliseconds: 400)
        : Duration.zero;
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.brown,
        onPressed: () {
          Navigator.of(context).pushNamed('/register/space');
        },
        child: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          const AppBarHome(),
          const SliverToBoxAdapter(
            child: MenuSpaceTypes(),
          ),
          SliverToBoxAdapter(
            child: SearchButton(fadeInDuration: fadeInDuration),
          ),
          const SliverToBoxAdapter(
            child: SpaceButtons(),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Vistos recentemente'),
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.grey,
                          width: 200,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Espaços perto de você'),
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.grey,
                          width: 300,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('gifs'),
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.grey,
                          width: 300,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
