import 'package:flutter/material.dart';

BuildContext? _currentContext;

BuildContext? getCurrentContext() {
  return _currentContext;
}

void setCurrentContext(BuildContext context) {
  _currentContext = context;
}

void chooseFormGallery(Function() onCamera, Function onGallery) {
  showModalBottomSheet<void>(
    context: getCurrentContext()!,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Stack(children: [
        Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 5,
                        width: MediaQuery.sizeOf(context).width * 0.25,
                        decoration: BoxDecoration(
                            color: Colors.grey, borderRadius: BorderRadius.circular(10)),
                      ),
                      const SizedBox(height: 20),
                      const Text('Choose Image',
                          style: TextStyle(
                              fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () async {
                            Navigator.pop(context);
                            onCamera();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/ic_camera2.png',
                                  width: 30,
                                  height: 30,
                                ),
                                const SizedBox(width: 20),
                                const Text('camera', style: TextStyle(fontSize: 16))
                              ],
                            ),
                          ),
                        ),
                        const Divider(height: 2),
                        InkWell(
                          onTap: () async {
                            Navigator.pop(context);
                            onGallery();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/ic_gallery.png',
                                  width: 30,
                                  height: 30,
                                ),
                                const SizedBox(width: 20),
                                const Text('gallery', style: TextStyle(fontSize: 16))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
            right: 1,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.grey,
                    size: 28,
                  )),
            )),
      ]);
    },
  );
}
