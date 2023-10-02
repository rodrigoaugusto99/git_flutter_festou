/*logo no build da aplicacao a gente ja vai buscar os dados.
nao tem estado inicial. o estado inicial ja eh a lista carregada */
enum HomeStateStatus { loaded, error }

class HomeState {
  final HomeStateStatus status;
  //final List<UserModel> employees;

  HomeState({
    required this.status,
    //required this.employees,
  });

  HomeState copyWith({
    HomeStateStatus? status,
    /*List<UserModel>? employees*/
  }) {
    return HomeState(
      status: status ?? this.status,
      //employees: employees ?? this.employees,
    );
  }
}
/*estado retorna um status E uma lista. */