import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myapp/src/models/app_model.dart';

Widget DraggableStockCard({
  required BuildContext context,
  required StockItem stock,
}) {

  Widget imageBlock =
  Container(
    height: 300.0,
    width: double.infinity,
    child: ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15.0),
        topRight: Radius.circular(15.0),
      ),
      child: Image(
        fit: BoxFit.cover,
        image: CachedNetworkImageProvider(
          stock.imgsrc[0],
        ),
      ),
    ),
  );

  Widget titleBlock =
  Container(
    padding: EdgeInsets.symmetric(
      horizontal: 14.0,
    ),
    child: Text(
      stock.title,
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      )
    ),
  );

  Widget descriptionBlock =
  Container(
    padding: EdgeInsets.symmetric(
      horizontal: 14.0,
    ),
    child: Text(
      stock.description,
      style: TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      )
    ),
  );

  return DraggableScrollableSheet(
    initialChildSize: 0.7,
    minChildSize: 0.3,
    maxChildSize: 0.9,
    expand: false,
    builder: (context, ScrollController scrollController) {
      return SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [ 
            imageBlock,
            SizedBox(height: 15.0),
            titleBlock,
            SizedBox(height: 8.0),
            descriptionBlock,
          ]
        )
      );
    }
  );
}
