import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

BuildContext? _currentContext;

BuildContext? getCurrentContext() {
  return _currentContext;
}

void setCurrentContext(BuildContext context) {
  _currentContext = context;
}

void onCallCenterClick() {
  showModalBottomSheet<void>(
    context: getCurrentContext()!,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Stack(children: [
        Container(
          height: 300,
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
                      const Text('Contact List'),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        hotLinePhoneCall('010 522 522', '010522522', false),
                        hotLinePhoneCall('081 911 911', '081911911', false),
                        hotLinePhoneCall('015 633 633', '015633633', true),
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

Column hotLinePhoneCall(String title, String phone, bool last) {
  return Column(
    children: [
      InkWell(
        onTap: () {
          Navigator.pop(getCurrentContext()!);
          final Uri launchUri = Uri(
            scheme: 'tel',
            path: phone,
          );
          launchUrl(launchUri);
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Text(title),
        ),
      ),
      if (!last) const Divider(),
    ],
  );
}
