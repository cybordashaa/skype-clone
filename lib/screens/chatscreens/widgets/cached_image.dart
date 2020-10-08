
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget{
  final String url;
  CachedImage({
    @required this.url
});
@override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      height: 60,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: CachedNetworkImage(
              imageUrl: url,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(),
              ),
            )
        )
    );
  }
}