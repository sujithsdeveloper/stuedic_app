import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stuedic_app/APIs/api_services.dart';
import 'package:stuedic_app/controller/API_controller.dart/homeFeed_Api_call_bloc/bloc/homefeed_data_fetch_state.dart';
import 'package:http/http.dart' as http;
import 'package:stuedic_app/model/home_feed_model.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/utils/refreshTocken.dart';
part 'homefeed_data_fetch_event.dart';

class HomefeedDataFetchBloc
    extends Bloc<HomefeedDataFetchEvent, HomefeedDataFetchState> {
  BuildContext context;
  int pageCount = 1;
  bool isMore = true;
  List<Response> resBlocList = [];
  bool isFetched = false;
  HomefeedDataFetchBloc({required this.context})
      : super(HomefeedDataFetchInitial()) {
    on<HomefeedDataFetchEvent>(_homedataFetchFromApi);
  }

  _homedataFetchFromApi(HomefeedDataFetchEvent event,
      Emitter<HomefeedDataFetchState> emit) async {
    log("\x1B[32m bloc called -------");
    isFetched = true;
    if (isMore && resBlocList.isEmpty) {
      emit(HomefeedDataFetchLoading());
    } else {
      emit(HomefeedDataFetchMore(response: resBlocList));
    }
    String? token = await AppUtils.getToken();
    try {
      var response = await http.get(
          Uri.parse(
              'https://api.stuedic.com/api/v1/Post/homeFeed?page=$pageCount&limit=3'),
          headers: ApiServices.getHeadersWithToken(token));

      if (response.statusCode == 200) {
        var newData =
            (homeFeedFromJson(response.body).response ?? []).cast<Response>();

        if (newData.isEmpty) {
          isMore = false;
        }
        resBlocList.addAll(newData);
        log('\x1B[32m ${resBlocList[0].collageName}');
        emit(HomefeedDataFetchSussess(response: resBlocList));
        pageCount++;
      } else if (response.statusCode == 401) {
        await refreshAccessToken(context: context);
        add(event);
      } else {
        log('Response: ${response.body} status code : ${response.statusCode}',
            name: '\x1B[37m Home FeedError API: ');
        emit(HomefeedDataFetchError(errorMessage: StringConstants.wrong));
      }
    } catch (e) {
      log(e.toString(), name: '\x1B[37m Home FeedError API: ');
      emit(HomefeedDataFetchError(errorMessage: StringConstants.wrong));
    } finally {
      isFetched = false;
    }
  }
}
