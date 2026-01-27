import '../app_image.dart';

class VehicleImageItem {
  final String id;
  final String image;

  const VehicleImageItem({
    required this.id,
    required this.image,
  });
}

class VehicleImageData {
  static const List<VehicleImageItem> covers = <VehicleImageItem>[
    VehicleImageItem(
      id: 'luxury_hotel_bus',
      image: AppImages.IM_LUXURY_HOTEL_BUS_Cover,
    ),
    VehicleImageItem(
      id: 'air_bus',
      image: AppImages.IM_AIR_BUS_Cover,
    ),
    VehicleImageItem(
      id: 'hotel_bus',
      image: AppImages.IM_HOTEL_BUS,
    ),
    VehicleImageItem(
      id: 'speedboat',
      image: AppImages.IM_SPEEDBOAT,
    ),
  ];

  static const Map<String, List<String>> insideImages = <String, List<String>>{
    'luxury_hotel_bus': <String>[
      AppImages.IM_LUXURY_HOTEL_BUS_Inside_1,
      AppImages.IM_LUXURY_HOTEL_BUS_Inside_2,
      AppImages.IM_LUXURY_HOTEL_BUS_Inside_3,
      AppImages.IM_LUXURY_HOTEL_BUS_Inside_4,
      AppImages.IM_LUXURY_HOTEL_BUS_Inside_5,
      AppImages.IM_LUXURY_HOTEL_BUS_Inside_6,
    ],
    'air_bus': <String>[
      AppImages.IM_AIR_BUS_Inside_1,
      AppImages.IM_AIR_BUS_Inside_2,
      AppImages.IM_AIR_BUS_Inside_3,
      AppImages.IM_AIR_BUS_Inside_4,
      AppImages.IM_AIR_BUS_Inside_5,
      AppImages.IM_AIR_BUS_Inside_6,
    ],
    'hotel_bus': <String>[
      AppImages.IM_HOTEL_BUS_INSIDE_1,
      AppImages.IM_HOTEL_BUS_INSIDE_2,
      AppImages.IM_HOTEL_BUS_INSIDE_3,
      AppImages.IM_HOTEL_BUS_INSIDE_4,
      AppImages.IM_HOTEL_BUS_INSIDE_5,
    ],
    'speedboat': <String>[
      AppImages.IM_SPEEDBOAT_INSIDE_1,
      AppImages.IM_SPEEDBOAT_INSIDE_2,
      AppImages.IM_SPEEDBOAT_INSIDE_3,
      AppImages.IM_SPEEDBOAT_INSIDE_4,
    ],
  };

  static List<String> getInsideImages(String id) {
    return insideImages[id] ?? const <String>[];
  }
}
