import 'package:fininfocom_task/models/data_provider.dart';
import 'package:fininfocom_task/models/profile.dart';
import 'package:fininfocom_task/screens/profile_screen.dart';
import 'package:fininfocom_task/screens/random_dog_images_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Task - FinInfoCom',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(
          title: 'Flutter Task With Android and IOS Native Code'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('com.example.fininfocom_task/bluetooth');
  String? response;
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  key: const Key("randomDogImageButton"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider<DataProvider<String>>(
                                create: (context) => DataProvider<String>(loadData: DogImageService().loadRandomDogImage),
                                child: Consumer<DataProvider<String>>(
                                  builder: (context,provider,_) {
                                    return RandomDogImageScreen(provider: provider);
                                  }
                                ),
                              )));
                    },
                    child: const Text("Random Dog Image")),
                const SizedBox(height: 20,),
                ElevatedButton(
                  key: const Key("enableBluetoothButton"),
                    onPressed: ()async{
                  response = null;
                  try {
                    final result = await platform.invokeMethod<String>('enableBluetooth');
                    setState(() {
                      response = result;
                    });
                  } on PlatformException catch (e) {
                    setState(() {
                      response = e.message;
                    });
                  }catch (e){
                    setState(() {
                      response = e.toString();
                    });
                  }
                }, child: const Text("Enable Bluetooth")),
                response != null
                ?Column(
                  children: [
                    const SizedBox(height: 5,),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(response ?? "", textAlign: TextAlign.center,)),
                  ],
                ): const SizedBox(),
                const SizedBox(height: 20,),
                ElevatedButton(
                  key: const Key("profileButton"),
                    onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider<DataProvider<Profile>>(
                              create: (context) => DataProvider<Profile>(loadData: ProfileService().loadProfile),
                            child: Consumer<DataProvider<Profile>>(
                                builder: (context,provider,_) {
                                  return ProfileScreen(provider: provider);
                                }
                            ),
                          )));
                }, child: const Text("Profile"))
              ],
            ),
          ),
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
