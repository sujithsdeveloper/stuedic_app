import 'package:stuedic_app/model/get_shorts_model.dart';

class ReelDataFetchState {}

final class ReelDataFetchInitial extends ReelDataFetchState {}

final class ReelDataFetchLoading extends ReelDataFetchState {}

final class ReelDataFetchSussess extends ReelDataFetchState {
  List<Response> response;
  ReelDataFetchSussess({required this.response});
}

final class ReelDataFetchMore extends ReelDataFetchState {
  List<Response> response;
  ReelDataFetchMore({required this.response});
}

final class ReelDataFetchError extends ReelDataFetchState {
  String errorMessage;
  ReelDataFetchError({required this.errorMessage});
}
