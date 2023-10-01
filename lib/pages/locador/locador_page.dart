import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:git_flutter_festou/pages/screens/reserva_page.dart';
import '../../old/helpers/card_functions.dart';
//usando top level functions, com alias
import '../../old/helpers/lcoador_page_functions.dart'
    as locador_page_functions;
import '../../old/model/my_card.dart';
import '../screens/create_card.dart';

class LocadorPage extends StatefulWidget {
  const LocadorPage({super.key});

  @override
  State<LocadorPage> createState() => _LocadorPageState();
}

class _LocadorPageState extends State<LocadorPage> {
  //no escopo do ESTADO pois são propriedades que precisam ser atualizadas
  List<MyCard> myCards = [];

  List<MyCard> filteredCards = [];

  bool isFiltered = false;

  /*----------------BOTÕES DO CARD------------*/

  //não precisam de int index pois cada card já significa filteredCards[index] ou myCards[index]

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        title: const Text('Meu Perfil Locador'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Meus espaços cadastrados',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400),
            ),
          ),

          //botao para abrir janela de criar card
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  //esperando o retorno do CreateCard para atribuir ao newCard
                  MyCard? newCard = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateCard(),
                    ),
                  );
                  //se não é null, adicione na  lista
                  if (newCard != null) {
                    setState(() {
                      myCards.add(newCard);
                    });
                  }
                },
                child: const Text('Criar card'),
              ),
              ElevatedButton(
                onPressed: () =>
                    locador_page_functions.showFilterAlertDialog(context, () {
                  setState(() {});
                }, filteredCards, myCards, isFiltered),
                child: const Text('filtrar'),
              ),
              ElevatedButton(
                onPressed: () {
                  locador_page_functions.clearFilter(isFiltered, () {
                    setState(() {});
                  });
                },
                child: const Text('Limpar Filtros'),
              ),
            ],
          ),
          Expanded(
            //EXPANDED PARA A LISTVIEW PEGAR O RESTANTE E N DAR OVERFLOW
            child: ListView.separated(
//listview terá o tamanho da lista de acordo com o BOOL
              itemCount: isFiltered ? filteredCards.length : myCards.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 10), // Espaço entre os itens da lista
              itemBuilder: (context, index) {
//cada card terá o index da respectiva lista de acordo com o BOOL
                MyCard card =
                    isFiltered ? filteredCards[index] : myCards[index];
/*agora, todos os cards que serão criados, ao construir cada elemento, como atributos e funcoes,
eles serao feitos usando o  CARD + atributo OU passando o CARD como parametro da função(verfotos, vermapa, etc) */
                return Card(
                  elevation: 10,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Column(
                    children: [
                      Container(
                        color: Colors.black87,
                        height: MediaQuery.of(context).size.height *
                            0.25, // Defina uma altura fixa para o Container
                        child: Swiper(
                          //esquema para o swiper exibir apenas as 4 primeiras imagens
                          //se o numero de imagens for maior q 4, o tamanho da lista é 4
                          itemCount:
                              card.images.length > 4 ? 4 : card.images.length,
                          autoplay: true,
                          pagination: const SwiperPagination(),
                          itemBuilder: (context, itemIndex) {
                            return Image.file(
                              card.images[itemIndex],
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //-----------test button----------
                                ElevatedButton(
                                  onPressed: () {
                                    print(
                                      card.feedbacks.map((feedback) {
                                        return Text(
                                            feedback.content.toString());
                                      }).toList(),
                                    );
                                  },
                                  child: const Icon(Icons.textsms_sharp),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    //esperando o retorno do CreateCard para atribuir ao newCard
                                    /*se eu esperasse um retorno, como a reserva, eu faria
                 Reserva newReserva = await Navigator.push...
                 e poderia usar esse  valor retornado(newReserva)
                 para adicionar à lista de Reservas do card
                 (( if (newReserva != null) {
                    setState(() {
                      card.reservas.add(newReserva);
                    });
                  }
                  - para a ReservaPage retornar o valor, passariamos como parametro 
                  atraves do Navigator.pop(context, NEWCARD)
                  - para a ReservaPage ter o poder de atribuir a reserva ao card lá mesmo,
                  precisamos criar um constutor na ReservaPage para ela receber um card,
                  e mandar esse card por parametro ao chamar a ResersaPage
                  -obviamente, se a reserva for instanciada nessa pagina, conforme
                  mostrado acima, não precisaria passar o card como argumento 
                  na chamada da ReservaPage, pois ela apenas seria usada pra retornar o
                  valor de newReserva.*/
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ReservaPage(card: card),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.blue, // Cor de fundo do botão
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                        horizontal: 18), // Espaçamento interno
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          10), // Borda arredondada do botão
                                    ),
                                    elevation: 4, // Elevação do botão
                                  ),
                                  child: const Text(
                                    'Fazer Reserva',
                                    style: TextStyle(
                                      fontSize: 18, // Tamanho da fonte do texto
                                      fontWeight: FontWeight.bold, // Negrito
                                      color: Colors.white, // Cor do texto
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () =>
                                      CardFunctions.openRatingDialog(
                                          card, context, () {
                                    setState(() {});
                                  }),
                                  child: const Text('Avalie'),
                                ),
                              ],
                            ),
                            //index do elemento de myCards, propriedade nome.
                            /*se myCards fosse uma lista de lista, seria myCards[index][0] 
            (como é no caso do myCards[index].images[itemIndex],)
            onde há images[], pois images é uma lista.*/
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Nome do espaço com fontsize maior
                                Text(
                                  card.nome,
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                                //mandar a lista correta com base no estado do filtro
                                ElevatedButton(
                                  onPressed: () =>
                                      CardFunctions.showDetails(card, context),
                                  child: const Text('Mais Detalhes'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Lugar do espaço com fontsize menor
                            Text(
                              card.lugar,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            // Descrição do espaço
                            Text(
                              'Descrição: ${card.descricao}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 16),
                            // Número de contato e e-mail no canto inferior direito
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text('Contato:'),
                                    Text(
                                      card.numero,
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(width: 16),
                                    Text(
                                      card.email,
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Botões estilizados para exibir fotos e localização no Google Maps
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // Implemente a função para exibir as fotos
                                    CardFunctions.showPhotos(card, context);
                                  },
                                  child: const Text('Ver Fotos'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Implemente a função para exibir as fotos
                                    CardFunctions.showPhotos2(card, context);
                                  },
                                  child: const Text('Ver Fotos'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Implemente a função para exibir a localização no Google Maps
                                    CardFunctions.showMap(card, context);
                                  },
                                  child: const Text('Ver Localização'),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    CardFunctions.openRatingDialog2(
                                        card, context);
                                  },
                                  child: const Text('Avalie'),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () =>
                                      CardFunctions.showComments(card, context),
                                  icon: const Icon(Icons.comment),
                                  label: const Text('Comments'),
                                ),
                              ],
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
