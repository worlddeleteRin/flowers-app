import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myapp/src/models/app_model.dart';

Widget StockCard({
  required Function handleClick,
  required StockItem stock,
}) {

  Widget stockCardImage =
  GestureDetector(
    onTap: () { handleClick(stock); },
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0), 
          topRight: Radius.circular(10.0),
        ),
      ),
      height: 160,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0), 
          topRight: Radius.circular(10.0),
        ),
        child: Image(
          // height: 130,
          fit: BoxFit.cover,
          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Text("error while loading image");
          },
          image: CachedNetworkImageProvider(
            // "http://placehold.it/500x500",
            stock.imgsrc[0], 
          ),
        ),
      ),
    ),
  );

  Widget stockCardTitle = 
  Container(
    margin: EdgeInsets.symmetric(
      vertical: 10.0,
      horizontal: 10.0,
    ),
    child: Text(
      stock.title,
      maxLines: 3,
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      )
    )
  );

  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black,
          offset: Offset(0.0, 0.0),
          blurRadius: 14.0,
          spreadRadius: -13.0,
        )
      ],
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
    ),
    margin: EdgeInsets.all(0),  
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        stockCardImage,
        stockCardTitle,
      ]
    ),
  );
}
