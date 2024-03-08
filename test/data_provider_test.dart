import 'package:fininfocom_task/models/data_provider.dart';
import 'package:fininfocom_task/models/profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'data_provider_test.mocks.dart';

@GenerateMocks([http.Client])
void main(){
  // Testing [DogImageService]
  group("DogImageService", () {
    test("Return dog image if api call completes successfully", () async {
      final client = MockClient();
      when(client.get(Uri.parse("https://dog.ceo/api/breeds/image/random")))
      .thenAnswer((_)async => http.Response('{"message":"https:\/\/images.dog.ceo\/breeds\/terrier-bedlington\/n02093647_1538.jpg","status":"success"}',200));
      final response = await DogImageService().loadRandomDogImage(client);
      printToConsole(response);
      expect(response, isA<String>());
    });

    test("Return null if api call fails", () async {
      final client = MockClient();
      when(client.get(Uri.parse("https://dog.ceo/api/breeds/image/random")))
          .thenAnswer((_)async => http.Response("Server Error",502));
      final response = await DogImageService().loadRandomDogImage(client);
      printToConsole(response);
      expect(response, isA<Null>());
    });

  });

  // Testing [ProfileService]
  group("ProfileService", () {
    test("Return Profile if api call completes successfully", () async {
      final client = MockClient();
      when(client.get(Uri.parse("https://randomuser.me/api/")))
          .thenAnswer((_)async => http.Response('{"results":[{"gender":"male","name":{"title":"Mr","first":"Chris","last":"Ferguson"},"location":{"street":{"number":250,"name":"Cork Street"},"city":"Dundalk","state":"Longford","country":"Ireland","postcode":61649,"coordinates":{"latitude":"-0.4847","longitude":"-47.5424"},"timezone":{"offset":"-10:00","description":"Hawaii"}},"email":"chris.ferguson@example.com","login":{"uuid":"23101599-1922-4d4f-b445-fc066b17a98c","username":"crazygoose966","password":"corndog","salt":"hLhkZp8S","md5":"7a8ddaf80a9e397b46940b078c8e8aff","sha1":"5e89b306e35c7c47ac3e6026afda7df74867be94","sha256":"22a6ed040de9858fdce1c96c47601f4b925da7a118027573a76d540dd6b3d858"},"dob":{"date":"1989-05-13T01:28:15.748Z","age":34},"registered":{"date":"2002-11-05T04:22:53.917Z","age":21},"phone":"031-714-6557","cell":"081-377-6172","id":{"name":"PPS","value":"9794987T"},"picture":{"large":"https://randomuser.me/api/portraits/men/39.jpg","medium":"https://randomuser.me/api/portraits/med/men/39.jpg","thumbnail":"https://randomuser.me/api/portraits/thumb/men/39.jpg"},"nat":"IE"}],"info":{"seed":"752d248312f8f8bf","results":1,"page":1,"version":"1.4"}}',200));
      final response = await ProfileService().loadProfile(client);
      printToConsole(response);
      expect(response, isA<Profile>());
    });

    test("Return null if api call fails", () async {
      final client = MockClient();
      when(client.get(Uri.parse("https://randomuser.me/api/")))
          .thenAnswer((_)async => http.Response("Server Error",502));
      final response = await ProfileService().loadProfile(client);
      printToConsole(response);
      expect(response, isA<Null>());
    });

  });
}