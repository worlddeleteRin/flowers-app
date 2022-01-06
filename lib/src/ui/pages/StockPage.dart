import 'package:flutter/material.dart';
import 'package:myapp/src/blocs/app_bloc.dart';
import 'package:myapp/src/models/app_model.dart';
import 'package:myapp/src/ui/components/common/MainSliverRefreshControl.dart';
import 'package:myapp/src/ui/components/common/PageLoadingCenter.dart';
import 'package:myapp/src/ui/components/common/StocksList.dart';

class StockPage extends StatelessWidget {
  checkFetchStocks() {
    if (appBloc.stocksFetched) {
      return;
    }
    appBloc.fetchStocks();
  }

  refreshStocksPage () {
    appBloc.fetchStocks();
  }

  @override
  Widget build(BuildContext context) {

  checkFetchStocks();

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Акции"),
        ),
        body: StocksStreamBuilder(context: context),
      )
    );
  }

  Widget StocksStreamBuilder({
    required BuildContext context,
  }) {
    return StreamBuilder(
      stream: appBloc.stocks,
      builder: (BuildContext subContext, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text('Ошибка во время загрузки акций');
        }
        if (snapshot.hasData &
        (snapshot.data is List<StockItem>)) {
          List<StockItem> stocks = snapshot.data;
          return StocksPageContent(
            context: context,
            stocks: stocks,
          );
        }
        return PageLoadingCenter();
      }
    );
  }

  Widget StocksPageContent({
    required BuildContext context,
    required List<StockItem> stocks,
  }) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        MainSliverRefreshControl(
          handleOnRefresh: () => refreshStocksPage(),
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: 20.0),
        ),
        SliverToBoxAdapter(
          child: StocksList(
            context: context,
            stocks: stocks,
          ), 
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: 20.0),
        ),
      ]
    );
  }

}
