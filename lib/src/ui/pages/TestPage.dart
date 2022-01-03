import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


import 'package:myapp/src/blocs/catalogue_bloc.dart';

class TestPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('test page is here'),
      ),
      body: Column(
        children: [
          Text('some text is here'),
          ElevatedButton(
            onPressed: () {catalogueBloc.removeCategories();},
            child: Text('remove categories'),
          ),
          ElevatedButton(
            onPressed: () {catalogueBloc.fetchCategories();},
            child: Text('fetch categories'),
          ),
          StreamBuilder(
            stream: catalogueBloc.allCategories,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.toString());
              }
              if (snapshot.hasError) {
                return Text('error?');
              }
              return Text('loading...');
            },
          ),
        ]
      )
    );
  }
}

