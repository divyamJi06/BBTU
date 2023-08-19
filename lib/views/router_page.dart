import 'package:bbtu/views/qr.dart';
import 'package:flutter/material.dart';
import '../controller/storage_controller.dart';
import '../model/routers.dart';
import '../utils/contstants.dart';
import '../widgets/router_card.dart';
import 'connect_to_lock.dart';
import 'gallery_qr.dart';

class RouterPage extends StatelessWidget {
  RouterPage({super.key});
  final StorageController _storageController = StorageController();

  Future<List<RouterDetails>> fetchRouters() async {
    return _storageController.readRouters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: 70,
        width: 180,
        child: FloatingActionButton.large(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const QRView(type: "router"),
                      ));
                    },
                    icon: Icon(Icons.photo_camera)),
                // Container(),
                VerticalDivider(
                  color: whiteColour,
                  thickness: 2,
                  endIndent: 20,
                  indent: 20,
                ),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const GalleryQRPage(type: "router"),
                      ));
                    },
                    icon: Icon(Icons.photo)),
              ],
            ),
            onPressed: () {}),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          iconTheme: IconThemeData(color: appBarColour),
          backgroundColor: backGroundColour,
          automaticallyImplyLeading: false,
          title: Text(
            "Routers",
            style: TextStyle(
                color: appBarColour, fontSize: 40, fontWeight: FontWeight.bold),
          ),
          actions: [],
          centerTitle: true,
          elevation: 0,
        ),
      ),
      // bottomNavigationBar: MyNavigationBar(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            // mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                  future: fetchRouters(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) return const Text("ERROR");

                    return ListView.builder(
                        padding: const EdgeInsets.only(top: 10),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ConnectToLockWidget(
                                            IP: snapshot
                                                .data![index].iPAddress!,
                                            lockName:
                                                snapshot.data![index].name,
                                            lockID:
                                                snapshot.data![index].lockID,
                                            lockPassKey: snapshot
                                                .data![index].lockPasskey,
                                          )));
                            },
                            child: RouterCard(
                                routerDetails: snapshot.data![index]),
                          );
                        });
                  })
            ],
          ),
        ),
      ),
    );
  }
}
