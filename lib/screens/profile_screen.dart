import 'package:fininfocom_task/models/data_provider.dart';
import 'package:flutter/material.dart';
import '../models/profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.provider});
  final DataProvider<Profile> provider;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

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
        title: const Text("Profile"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: widget.provider.isInternetConnected
            ? widget.provider.isLoading
          ? const Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            ),
          )
              : widget.provider.isError || widget.provider.data == null
          ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("No Data Found!",),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(onPressed: (){
                widget.provider.refresh();
              }, child: const Text("Retry"))
            ],
          )
              : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Image.network(
                        widget.provider.data?.image?.medium ??
                            widget.provider.data?.image?.large ??
                        widget.provider.data?.image?.thumbnail ??
                            "",
                        // loadingBuilder: (context, _, event) {
                        //   return const CircularProgressIndicator();
                        // },
                        errorBuilder: (context, _, st) {
                          return const Icon(Icons.error_outline);
                        },
                        fit: BoxFit.contain,
                      ),
                    ),
                    Expanded(
                        child: Column(
                          children: [
                            Text(
                              widget.provider.data?.name?.getFullName() ??
                                  "No Name Found!",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              widget.provider.data?.email ?? "Email: N/A",
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text("DOB: ${widget.provider.data?.dob?.dobString() ?? "N/A"}")
                          ],
                        ))
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.blueGrey)
                ),
                child: Column(
                  children: [
                    const Text("Address", style: TextStyle(fontWeight: FontWeight.bold),),
                    const Divider(color: Colors.black,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Street: ", style: TextStyle(color: Colors.grey),),
                        Expanded(child: Text(widget.provider.data?.location?.street?.streetString() ?? "N/A"))
                      ],
                    ),
                    const Divider(color: Color(0xffEEEEEE),),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("City: ", style: TextStyle(color: Colors.grey),),
                        Expanded(child: Text(widget.provider.data?.location?.city ?? "N/A"))
                      ],
                    ),
                    const Divider(color: Color(0xffEEEEEE),),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("State: ", style: TextStyle(color: Colors.grey),),
                        Expanded(child: Text(widget.provider.data?.location?.state ?? "N/A"))
                      ],
                    ),
                    const Divider(color: Color(0xffEEEEEE),),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Country: ", style: TextStyle(color: Colors.grey),),
                        Expanded(child: Text(widget.provider.data?.location?.country ?? "N/A"))
                      ],
                    ),
                    const Divider(color: Color(0xffEEEEEE),),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Postcode: ", style: TextStyle(color: Colors.grey),),
                        Expanded(child: Text(widget.provider.data?.location?.postcode.toString() ?? "N/A"))
                      ],
                    ),
                    const Divider(color: Color(0xffEEEEEE),),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Coordinates: ", style: TextStyle(color: Colors.grey),),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Latitude ${widget.provider.data?.location?.coordinates?.latitude.toString() ?? "N/A"}"),
                            const SizedBox(height: 5,),
                            Text("Longitude ${widget.provider.data?.location?.coordinates?.longitude.toString() ?? "N/A"}"),
                          ],
                        ))
                      ],
                    ),
                    const Divider(color: Color(0xffEEEEEE),),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Timezone: ", style: TextStyle(color: Colors.grey),),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Offset ${widget.provider.data?.location?.timezone?.offset.toString() ?? "N/A"}"),
                            const SizedBox(height: 5,),
                            Text("Description ${widget.provider.data?.location?.timezone?.description ?? "N/A"}"),
                          ],
                        ))
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.blueGrey)
                ),
                child: Column(
                  children: [
                    const Text("Number of days passed since registered", style: TextStyle(fontWeight: FontWeight.bold),),
                    const Divider(color: Colors.black,),
                    Text("${widget.provider.data?.registered?.numberOfDaysSinceRegistered() ?? "N/A"}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: (){
                widget.provider.refresh();
              }, child: const Text("Next Profile"))
            ],
          )
              : Column(
            children: [
              const Text("No Internet Connection Found! Please Check your internet connection.",),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(onPressed: (){
                widget.provider.refresh();
              }, child: const Text("Retry"))
            ],
          ),
        ),
      )
    );
  }
}
