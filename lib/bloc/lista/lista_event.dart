part of 'lista_bloc.dart';

abstract class ListaEvent extends Equatable {
  const ListaEvent();

  @override
  List<Object> get props => [];
}

class ListaEstudiantesEvent extends ListaEvent {
  const ListaEstudiantesEvent();

  @override
  List<Object> get props => [];
}

class LlamarListaEvent extends ListaEvent {
  final List<bool> estadosChecklist;
  const LlamarListaEvent({required this.estadosChecklist});

  @override
  List<Object> get props => [estadosChecklist];
}
