import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import '../model/my_card.dart';
import 'calendar_page.dart';
import 'create_card.dart';

class TestePage extends StatefulWidget {
  const TestePage({super.key});

  @override
  State<TestePage> createState() => _TestePageState();
}

class _TestePageState extends State<TestePage> {
  //no escopo do ESTADO pois são propriedades que precisam ser atualizadas
  List<MyCard> myCards = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        title: const Text('Meu Perfil Locador'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Voltar'),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.blue[800],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Meus espaços cadastrados',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400),
                  ),
                ),

                //botao para abrir janela de criar card
                SizedBox(
                  height: 25, //feio
                  child: FloatingActionButton(
                    backgroundColor: Colors.green,
                    elevation: 0,
                    onPressed: () async {
                      // Abrir a página CreateCard e aguardar o retorno do objeto MyCard
                      MyCard? newCard = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateCard(),
                        ),
                      );

                      // Verificar se o objeto retornou e adicioná-lo à lista, caso seja diferente de null
                      if (newCard != null) {
                        setState(() {
                          myCards.add(newCard);
                        });
                      }
                    },
                    child: const Icon(
                      Icons.add,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            //EXPANDED PARA A LISTVIEW PEGAR O RESTANTE E N DAR OVERFLOW
            child: ListView.separated(
              // Lista geral - do tamanho da lista dos cards
              itemCount: myCards.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 10), // Espaço entre os itens da lista
              itemBuilder: (context, index) {
                return Card(
                  elevation: 10,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.25, // Defina uma altura fixa para o Container
                        child: Swiper(
                          //esquema para o swiper exibir apenas as 4 primeiras imagens
                          //se o numero de imagens for maior q 4, o tamanho da lista é 4
                          itemCount: myCards[index].images.length > 4
                              ? 4
                              : myCards[index].images.length,
                          autoplay: true,
                          pagination: const SwiperPagination(),
                          itemBuilder: (context, itemIndex) {
                            return Image.file(
                              myCards[index].images[itemIndex],
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      /*Image.asset(
                                //index do elemento de myCards, index da propriedade images
                                //[] lista das images da [] lista do mycards
                                myCards[index].images[itemIndex],
                                fit: BoxFit.contain,
                              );*/
                      Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //index do elemento de myCards, propriedade nome.
                            /*se myCards fosse uma lista de lista, seria myCards[index][0] 
            (como é no caso do myCards[index].images[itemIndex],)
            onde há images[], pois images é uma lista.*/
                            Text('Nome: ${myCards[index].nome}'),
                            const SizedBox(width: 10),
                            Text('Lugar: ${myCards[index].lugar}'),
                            const SizedBox(width: 10),
                            Text('Numero: ${myCards[index].numero}'),
                            const SizedBox(width: 10),

                            Text(
                              'Localização: ${myCards[index].selectedLocationName}',
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CalendarPage(),
                                  ),
                                );
                              },
                              child: const Text('Ver Calendário'),
                            ),
                            ElevatedButton(
                              onPressed: () => {},
                              child: const Text('Ver calendario 2'),
                            ),
                            /*ElevatedButton(
                              onPressed: () => verNoMapa(index),
                              child: const Text('Ver no mapa'),
                            ),
                            //botoes para ver as outras fotos selecionadas
                            //ver fotos
                            ElevatedButton(
                              onPressed: () => verFotos(index),
                              child: const Text('Ver mais fotos'),
                            ),
                            //ver fotos com zoom
                            ElevatedButton(
                              onPressed: () => verFotos2(index),
                              child: const Text('Ver mais fotos 2'),
                            ),*/
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('Editar'),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: const Text('serviços disponiveis'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
