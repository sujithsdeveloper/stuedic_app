import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:stuedic_app/APIs/APIs.dart';
import 'package:stuedic_app/APIs/api_services.dart';
import 'package:stuedic_app/controller/API_controller.dart/reel_section_API_call_bloc/bloc/reel_data_fetch_state.dart';

import 'package:http/http.dart' as http;
import 'package:stuedic_app/model/get_shorts_model.dart';
import 'package:stuedic_app/utils/app_utils.dart';
import 'package:stuedic_app/utils/constants/string_constants.dart';
import 'package:stuedic_app/utils/refreshTocken.dart';

part 'reel_data_fetch_event.dart';

class ReelDataFetchBloc extends Bloc<ReelDataFetchEvent, ReelDataFetchState> {
  BuildContext context;
  bool isMore = true;
  int pageCount = 1;
  List<Response> blocResponse = [];
  ReelDataFetchBloc({required this.context}) : super(ReelDataFetchInitial()) {
    on<ReelDataFetchEvent>(reelFetchApiCall);
  }

  reelFetchApiCall(
      ReelDataFetchEvent event, Emitter<ReelDataFetchState> emit) async {
    log("\x1B[31m bloc called -------");
    String? token = await AppUtils.getToken();
    if (isMore && blocResponse.isEmpty) {
      emit(ReelDataFetchLoading());
    } else {
      emit(ReelDataFetchMore(response: blocResponse));
    }
    try {
      var response = await http.get(
          Uri.parse(
              'https://api.stuedic.com/api/v1/Post/homeFeed?page=$pageCount&limit=2&reelonly=true'),
          headers: ApiServices.getHeadersWithToken(token));

      if (response.statusCode == 200) {
        var newData = (getShortsModelFromJson(response.body).response ?? []);
        if (newData.isEmpty) {
          isMore = false;
        }
        blocResponse.addAll(newData);
        pageCount++;
        emit(ReelDataFetchSussess(response: blocResponse));
      } else if (response.statusCode == 401) {
        await refreshAccessToken(context: context);
        add(event);
      } else {
        log('Response: ${response.body} status code : ${response.statusCode}',
            name: '\x1B[31m Reel fetch Error API: ');
        ReelDataFetchError(errorMessage: StringConstants.wrong);
      }
    } catch (e) {
      log(e.toString(), name: '\x1B[31m Reel fetch Error API: ');
      ReelDataFetchError(errorMessage: StringConstants.wrong);
    }
  }
}
