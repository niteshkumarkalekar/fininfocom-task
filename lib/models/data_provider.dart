import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fininfocom_task/models/profile.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// A provider class that handles data services and notify changes
// with [isLoading], [isInternetConnected], [isError]
class DataProvider<T> extends ChangeNotifier{
  bool isLoading = true;
  bool isInternetConnected = true;
  T? data;
  bool isError = false;

  // function that loads data from the backend or api
  final Future<T?> Function(http.Client) loadData;

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
      final result = await loadData(http.Client());
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

// The call that handles that loading data for dog images
class DogImageService{
  Future<String?> loadRandomDogImage(http.Client client)async{
    const url = "https://dog.ceo/api/breeds/image/random";
      final response = await client.get(Uri.parse(url));
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

// class that handles that loading data for profiles
class ProfileService{
  Future<Profile?> loadProfile(http.Client client)async{
    const url = "https://randomuser.me/api/";
    final response = await client.get(Uri.parse(url));
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