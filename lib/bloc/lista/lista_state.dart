part of 'lista_bloc.dart';

abstract class ListaState extends Equatable {
  const ListaState();
  @override
  List<Object> get props => [];
}

class ListaInitial extends ListaState {

  const ListaInitial();

  @override
  List<Object> get props => [];
}

class ListaFailure extends ListaState {
  final String errorMessage;

  const ListaFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];

  void get error => 'error';
}
class ListaInitialWithInfo extends ListaState {
  final String informacionChofer;

  const ListaInitialWithInfo(this.informacionChofer);

  // Override el método props para incluir la variable informacionChofer
  @override
  List<Object> get props => [informacionChofer];
}
