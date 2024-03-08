import 'package:fininfocom_task/models/data_provider.dart';
import 'package:fininfocom_task/models/profile.dart';
import 'package:fininfocom_task/screens/profile_screen.dart';
import 'package:fininfocom_task/screens/random_dog_images_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fininfocom_task/main.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Testing Buttons in Home Page', (WidgetTester tester) async {

    await tester.pumpWidget(const MyApp());

    final randomDogImageButton = find.byKey(const Key("randomDogImageButton"));
    final enableBluetoothButton = find.byKey(const Key("enableBluetoothButton"));
    final profileButton = find.byKey(const Key("profileButton"));

    expect(randomDogImageButton, findsOneWidget);
    expect(enableBluetoothButton, findsOneWidget);
    expect(profileButton, findsOneWidget);

  });
  
  testWidgets("Testing RandomDogImageScreen", (widgetTester) async{
    await widgetTester.pumpWidget(ChangeNotifierProvider(
        create: (context) => DataProvider<String>(loadData: DogImageService().loadRandomDogImage),
      child: MaterialApp(
        home: Consumer<DataProvider<String>>(
          builder: (context, provider,_) {
            return RandomDogImageScreen(provider: provider,);
          }
        ),
      ),
    ));

    final dogNetworkImage = find.byKey(const Key("dogNetworkImage"));
    final refreshDogImageButton = find.byKey(const Key("refreshDogImageButton"));
    expect(dogNetworkImage, findsOneWidget);
    expect(refreshDogImageButton, findsOneWidget);
  });

  testWidgets("Testing ProfileScreen", (widgetTester) async{
    await widgetTester.pumpWidget(ChangeNotifierProvider(
      create: (context) => DataProvider<Profile>(loadData: ProfileService().loadProfile),
      child: MaterialApp(
        home: Consumer<DataProvider<Profile>>(
            builder: (context, provider,_) {
              return ProfileScreen(provider: provider,);
            }
        ),
      ),
    ));

    expect(find.text("Profile"), findsOneWidget);
  });
}
