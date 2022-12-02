import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wawa/utility/my_style.dart';


class ProductItemBox extends StatefulWidget {
  final String imageurl;
  final double width, height;
  ProductItemBox({required this.imageurl, required this.width, required this.height});
     
  @override
  _ProductItemBoxState createState() => _ProductItemBoxState();
}

class _ProductItemBoxState extends State<ProductItemBox> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child:
      Image.network(widget.imageurl,
        height: widget.height,
        width: widget.width,
      ),
      // CachedNetworkImage(
      //   // fit: BoxFit.cover,
      //   height: widget.height,
      //   width: widget.width,
      //   imageUrl: widget.imageurl,
      //   // imageUrl: "http://via.placeholder.com/350x150",
      //   placeholder: (context, url) => MyStyle().showProgress(),
      //  // placeholder: (context, url) => new CircularProgressIndicator(),
      //   errorWidget: (context, url, error) => Image.network(widget.imageurl),
      // ),
    );
  }
}
