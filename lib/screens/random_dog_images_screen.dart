import 'package:fininfocom_task/models/data_provider.dart';
import 'package:flutter/material.dart';

class RandomDogImageScreen extends StatefulWidget {
  const RandomDogImageScreen({super.key, required this.provider});
  final DataProvider<String> provider;

  @override
  State<RandomDogImageScreen> createState() => _RandomDogImageScreenState();
}

class _RandomDogImageScreenState extends State<RandomDogImageScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.provider.initialize();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Random Dog Image"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.blue.shade50),
              height: 200,
              child: Center(
                key: const Key("dogNetworkImage"),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    widget.provider.isInternetConnected
                        ? widget.provider.isLoading
                        ? const SizedBox(height: 50, width:50,
                        child: CircularProgressIndicator())
                        : widget.provider.isError
                        ? const Text("Error!",
                        style: TextStyle(
                            fontSize: 18, color: Colors.red))
                        : widget.provider.data != null
                        ? SizedBox( height: 200,
                      child: Image.network(
                        widget.provider.data!,
                        fit: BoxFit.contain,
                        loadingBuilder: (_, child, loadingProgress){
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, e, _) {
                          widget.provider.isError = true;
                          widget.provider.notify();
                          return const Icon(
                            Icons.error_outline,
                            size: 50,
                          );
                        },
                      ),
                    )
                        : const Text(
                      "No Image",
                      style: TextStyle(
                          fontSize: 14, color: Colors.black),
                    )
                        : const Icon(Icons.signal_cellular_connected_no_internet_0_bar),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            !widget.provider.isInternetConnected
                ? Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  color: Colors.red.shade50),
              child: const Column(
                children: [
                  Text(
                    "No Internet connection!",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                      "Please check your internet connection and try again.",
                      style: TextStyle(fontSize: 14))
                ],
              ),
            )
                : const SizedBox(),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              key: const Key("refreshDogImageButton"),
                onPressed: widget.provider.isLoading ? null
                  : () {
                  widget.provider.refresh();
                },
                child: Text(widget.provider.isError
                    ? "Retry"
                    : widget.provider.data == null
                    ? "Load Random Image"
                    : "Refresh"))
          ],
        ),
      ),
    );
  }
}
