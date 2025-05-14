import 'package:stuedic_app/model/home_feed_model.dart';

class HomefeedDataFetchState {}

final class HomefeedDataFetchInitial extends HomefeedDataFetchState {}

final class HomefeedDataFetchLoading extends HomefeedDataFetchState {}

final class HomefeedDataFetchSussess extends HomefeedDataFetchState {
  final List<Response>? response;

  HomefeedDataFetchSussess({required this.response});
}

final class HomefeedDataFetchMore extends HomefeedDataFetchState {
  final List<Response> response;

  HomefeedDataFetchMore({required this.response});
}

final class HomefeedDataFetchError extends HomefeedDataFetchState {
  final String errorMessage;

  HomefeedDataFetchError({required this.errorMessage});
}
