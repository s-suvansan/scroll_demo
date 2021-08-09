import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_demo/data.dart';
import 'package:scroll_demo/scroll_provider.dart';

class ScrollViewContent extends StatefulWidget {
  const ScrollViewContent({Key key}) : super(key: key);

  @override
  _ScrollViewContentState createState() => _ScrollViewContentState();
}

class _ScrollViewContentState extends State<ScrollViewContent> {
  GlobalKey _key = GlobalKey();
  // GlobalKey _keyCategoryContainer = GlobalKey();
  ScrollController _verticalScrollCtrl = ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  _afterLayout(_) {
    Offset _offset = getPositions(_key);
    prepareCategoryPositions(_offset.dy);
  }

  @override
  Widget build(BuildContext context) {
    final _value = Provider.of<ScrollProvider>(context, listen: false);
    _value.prepareVerticalCategoryKey();
    _value.setVerticalScrollCtrl = _verticalScrollCtrl;
    _value.scrollListener();
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              HorizontalScrollView(),
              SizedBox(height: 8.0),
              Expanded(
                child: ListView.separated(
                    key: _key,
                    controller: _value.verticalScrollCtrl,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    itemBuilder: (context, index) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        _value.prepareVerticalListPosition(index);
                      });
                      return (index != categories.length)
                          ? Column(
                              key: _value.verticalCategoryKey[index],
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    color: Colors.black12,
                                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                                    child: Text(
                                      categories[index].categoryName,
                                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                                    )),
                                SizedBox(height: 8.0), //FIXME if change height find "categoryHeightKey" and also change value
                                ProductListView(categoryIndex: index),
                              ],
                            )
                          : SizedBox(
                              // color: Colors.red,
                              height: getBottomHeight(context),
                            );
                    },
                    separatorBuilder: (__, _) => SizedBox(height: 8.0),
                    itemCount: categories.length + 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductListView extends StatelessWidget {
  final int categoryIndex;
  const ProductListView({Key key, this.categoryIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => Container(
        height: PRODUCT_CARD_HEIGHT,
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        color: Colors.black26,
        child: Text(categories[categoryIndex].products[index].productName),
      ),
      separatorBuilder: (__, _) => SizedBox(height: 8.0),
      itemCount: categories[categoryIndex].products.length,
    );
  }
}

class HorizontalScrollView extends StatelessWidget {
  HorizontalScrollView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ScrollProvider>(builder: (_ctx, value, _ch) {
      value.prepareHorizontalCategoryKey();
      return Container(
        color: Colors.black38,
        height: 50.0,
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: ListView.separated(
            controller: value.horizontalScrollCtrl,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                value.prepareHorizontalBarPosition(index);
              });
              return (index != categories.length)
                  ? Center(
                      key: value.horizontalCategoryKey[index],
                      child: GestureDetector(
                        onTap: () => value.navigateToPosition(index),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                          color: value.getSelectedIndex == index ? Colors.black26 : Colors.transparent,
                          child: Text(categories[index].categoryName),
                        ),
                      ),
                    )
                  : SizedBox(
                      width: value.getLastHorizontalSpaceWidth(context),
                    );
            },
            separatorBuilder: (__, _) => SizedBox(
                  width: 8.0,
                ),
            itemCount: categories.length + 1),
      );
    });
  }
}
