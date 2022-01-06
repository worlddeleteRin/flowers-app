import 'package:flutter/material.dart';
import 'package:myapp/src/models/app_model.dart';
import 'package:myapp/src/ui/components/common/DraggableStockCard.dart';
import 'package:myapp/src/ui/components/common/StockCard.dart';

Widget StocksList ({
  required BuildContext context,
  required List<StockItem> stocks,
}) {

  openStockSheet(StockItem stock) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      builder: (BuildContext context) {
        return DraggableStockCard(
          context: context,
          stock: stock,
        );
      }
    );
  }

  return GridView.builder(
    padding: EdgeInsets.symmetric(horizontal: 10.0),
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      mainAxisExtent: 255.0,
      crossAxisCount: 1,
      mainAxisSpacing: 17.0,
      crossAxisSpacing: 10.0,
    ),    
    itemCount: stocks.length,
    itemBuilder: (BuildContext context, int index) {
      return StockCard(
        handleClick: (StockItem stock) => openStockSheet(stock),
        stock: stocks[index],
      );
    },
  );
}
