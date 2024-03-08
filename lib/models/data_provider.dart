import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fininfocom_task/models/profile.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class DataProvider<T> extends ChangeNotifier{
  bool isLoading = true;
  bool isInternetConnected = true;
  T? data;
  bool isError = false;
  final Future<T?> Function() loadData;

  DataProvider({required this.loadData});

  Future<void> initialize()async{
    await getData();
    notifyListeners();
  }

  void notify(){
    notifyListeners();
  }

  Future<void> getData() async {

    // checks weather the device has any internet connectivity
    final connectivity  = await Connectivity().checkConnectivity();

    if(connectivity != ConnectivityResult.none) {
      final result = await loadData();
      printToConsole("Result: $result");
      if(result != null){
        data = result;
      }else{
        isError = true;
      }
    }else{
      isInternetConnected = false;
    }
    isLoading = false;
  }

  Future<void> refresh()async{
    isError = false;
    isLoading = true;
    isInternetConnected = true;
    notifyListeners();
    await getData();
    notifyListeners();
  }
}

class DogImageService{
  Future<String?> loadRandomDogImage()async{
    const url = "https://dog.ceo/api/breeds/image/random";
      final response = await http.get(Uri.parse(url));
      if(response.statusCode == 200){
        try {
          return (jsonDecode(response.body)["message"]).toString().replaceAll(r'\', "");
        } catch (e) {
          printToConsole("Exception while parsing dog image:${e.toString()}");
        }
      }
      return null;
  }
}

class ProfileService{
  Future<Profile?> loadProfile()async{
    const url = "https://randomuser.me/api/";
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      try {
        return Profile.fromJson(jsonDecode(response.body));
      } catch (e) {
        printToConsole("Exception while parsing Profile from payload: ${e.toString()}");
      }
    }
    return null;
  }
}