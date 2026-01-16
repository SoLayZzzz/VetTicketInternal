import 'dart:convert';

ImageResponse imageResponseFromJson(String str) =>
    ImageResponse.fromJson(json.decode(str));

String imageResponseToJson(ImageResponse data) => json.encode(data.toJson());

class ImageResponse {
  String? img;

  ImageResponse({
    this.img,
  });

  factory ImageResponse.fromJson(Map<String, dynamic> json) => ImageResponse(
        img: json["img"],
      );

  Map<String, dynamic> toJson() => {
        "img": img,
      };
}
