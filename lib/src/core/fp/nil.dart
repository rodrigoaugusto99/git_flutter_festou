/*classe para ser retornar quando for sucesso e nao precisar retornar nada 

metodo facilitador, metodo de niuvel superior get que é um nil que retornar uma instancia da classe nil - 
nao tem valor nenhum, mas nas programacoes funcionais precisam retornar alguma coisa, entao isso quebra o galho
*/

class Nil {
  @override
  String toString() {
    return 'Nil{}';
  }
}

Nil get nil => Nil();
