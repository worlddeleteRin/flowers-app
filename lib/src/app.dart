import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:myapp/src/ui/components/common/PageLoadingCenter.dart';
import 'package:myapp/src/ui/pages/CartPage.dart';
import 'package:myapp/src/ui/pages/CataloguePage.dart';
import 'package:myapp/src/ui/pages/CategoryPage.dart';
import 'package:myapp/src/ui/theme/mainTheme.dart';
// local imports
import 'ui/pages/HomePage.dart';
import 'ui/pages/TestPage.dart';

//
import 'package:myapp/src/blocs/app_bloc.dart';
import 'package:myapp/src/blocs/cart_bloc.dart';

class App extends StatefulWidget {
  App({Key? key}): super(key: key); 

  @override
  _AppState createState() => _AppState();
}


class _AppState extends State<App> {
  final GlobalKey<NavigatorState> rootPageOne = 
  GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> rootPageTwo = 
  GlobalKey<NavigatorState>();

  int currentIndex = 0;

  Map<String,Widget Function(BuildContext)> appRoutes = {
    '/home': (context) => HomePage(),  
    '/cart': (context) => CartPage(),  
    '/catalogue': (context) => CataloguePage(),  
    '/test': (context) => TestPage(),  
  };

  initializeApp () async {
    print('start app initialization');
    // await Future.delayed(Duration(seconds: 1));
    await appBloc.checkGetSessionId(); 
    // await Future.delayed(Duration(seconds: 1));
    print('get cart');
    await cartBloc.fetchCart();
    // await Future.delayed(Duration(seconds: 1));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: mainTheme,
      // routes: appRoutes,
      home: Scaffold(
        body: FutureBuilder(
          future: initializeApp(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return MainTabScaffold(context: context);
            }
            if (snapshot.hasError) {
              return Center(
                child: Text("error occured")
              );
            }
            return PageLoadingCenter();
          }
        )
      ),
    );
  }

  Widget MainTabScaffold({
    required BuildContext context,
  }) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (currentIndex == index) {
            rootPageOne.currentState?.popUntil((r) => r.isFirst); 
          }
          currentIndex = index;
        },            
        items: BottomMainNavigationItems(),
      ),
      tabBuilder: (context, index) {
        return MainTabPages(
          context: context,
          index: index,
        );
      }
    );
  }

  Widget MainTabPages ({
    required BuildContext context,
    required int index,
  }) {
    return CupertinoTabView(
      routes: appRoutes,
      builder: (BuildContext context) {
        switch(index) {
          case 0:
            return CupertinoTabView(
              routes: appRoutes,
              navigatorKey: rootPageOne, 
              builder: (BuildContext context) {
                return HomePage();
              }
            );
          case 1:
            return CupertinoTabView(
              routes: appRoutes,
              navigatorKey: rootPageTwo, 
              builder: (BuildContext context) {
                return CataloguePage();
              }
            );
        }
        return TestPage();
      }
    );
  }

  List<BottomNavigationBarItem> BottomMainNavigationItems () {
    final bottomNavigationList = [
      {"icon": Icon(Icons.store), "label": "Главная"},
      {"icon": Icon(Icons.grid_view), "label": "Каталог"},
      {"icon": Icon(Icons.local_offer_rounded), "label": "Акции"},
      {"icon": Icon(Icons.account_circle_rounded), "label": "Профиль"},
    ];
    final bottomNavigationItems = bottomNavigationList.map<BottomNavigationBarItem>(
      (item) => BottomNavigationBarItem(
        icon: item["icon"] as Widget,
        label: item["label"] as String,
        backgroundColor: Colors.grey,
      )
    ).toList();
    return bottomNavigationItems;
    /*
    return BottomNavigationBar(
      showUnselectedLabels: true,
      items: bottomNavigationItems,
    );
    */
  }

}

