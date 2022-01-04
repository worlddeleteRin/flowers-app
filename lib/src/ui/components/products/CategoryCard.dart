import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/src/models/catalogue_model.dart';
import 'package:myapp/src/ui/pages/CategoryPage.dart';

Widget CategoryCard ({
  required BuildContext context,
  required Category category,
}) {

  goCategoryPage () {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (BuildContext context) {
          return CategoryPage(
            categoryId: category.id
          );
        }
      )
    );
  }

  Widget categoryImageBlock =
  Row(
    children: [
      Expanded(
        // flex: 2,
        child: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            child: Image.network(
              category.imgsrc[0],
              height: 100.0,
              // width: 200.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    ],
  );

  Widget categoryNameBlock = 
  Container(
    margin: EdgeInsets.symmetric(
      vertical: 5.0,
      horizontal: 2.0,
    ),
    child: Text(
      category.name,
      style: Theme.of(context).textTheme.subtitle1,
    ),
  );

  return GestureDetector(
    onTap: () => goCategoryPage(),
    child: Container( 
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [ 
          categoryImageBlock,
          categoryNameBlock,
        ]
      ),
    ),
  );

}
