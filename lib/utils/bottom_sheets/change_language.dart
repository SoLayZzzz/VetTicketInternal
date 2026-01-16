import 'package:flutter/material.dart';

BuildContext? _currentContext;

BuildContext? getCurrentContext() {
  return _currentContext;
}

void setCurrentContext(BuildContext context) {
  _currentContext = context;
}

void onChangeLanguageClick() {
  showModalBottomSheet<void>(
    context: getCurrentContext()!,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Stack(children: [
        Container(
          height: 260,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Change Language',
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "Assets.imageKhmerFlag",
                              width: 32,
                              height: 32,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text('ភាសាខ្មែរ')
                          ],
                        ),
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "Assets.imageEnglishFlag",
                              width: 32,
                              height: 32,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text('English')
                          ],
                        ),
                      ),
                    )
                  ],
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
