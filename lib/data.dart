import 'package:flutter/material.dart';

List<CategoryModel> categories = [
  CategoryModel(
    "Fruites",
    products: [
      ProductModel("Apple"),
      ProductModel("Mango"),
      ProductModel("Bannana"),
      ProductModel("Pine Apple"),
    ],
  ),
  CategoryModel(
    "Vegies",
    products: [
      ProductModel("Tomato"),
      ProductModel("Potato"),
      ProductModel("Onion"),
    ],
  ),
  CategoryModel(
    "Meats",
    products: [
      ProductModel("Beef"),
      ProductModel("Chicken"),
      ProductModel("Pork"),
      ProductModel("Mutton"),
    ],
  ),
  CategoryModel(
    "Rices",
    products: [
      ProductModel("Samba"),
      ProductModel("Basmati"),
    ],
  ),
  CategoryModel(
    "Nuts",
    products: [
      ProductModel("Peanuts"),
      ProductModel("Kasunuts"),
      ProductModel("Pathaam"),
      ProductModel("Pistha"),
      ProductModel("Sunflower Seed"),
    ],
  ),
  CategoryModel(
    "Noodles",
    products: [
      ProductModel("Hot and spicy"),
      ProductModel("Chicken Noodles"),
      ProductModel("Pasta"),
    ],
  ),
  CategoryModel(
    "Pizza",
    products: [
      ProductModel("Veg Pizza"),
      ProductModel("Chicken Pizza"),
    ],
  ),
  CategoryModel(
    "Burger",
    products: [
      ProductModel("Chess Burger"),
      ProductModel("Jumbo Burger"),
      ProductModel("Steak Burger"),
    ],
  ),
  CategoryModel(
    "Spicies",
    products: [
      ProductModel("Karam Masala"),
      ProductModel("Chilli Masala"),
      ProductModel("Briyani Masala"),
      ProductModel("Kasmiri Masala"),
    ],
  ),
  CategoryModel(
    "Fast Foods",
    products: [
      ProductModel("Pizza"),
      ProductModel("Burger"),
      ProductModel("Shawarma"),
      ProductModel("Krilled Chicken"),
      ProductModel("Briyani"),
      ProductModel("Fried Rice"),
      ProductModel("Masala Chicken"),
    ],
  ),
];

class CategoryModel {
  final String categoryName;
  final List<ProductModel> products;

  CategoryModel(this.categoryName, {this.products});
}

class ProductModel {
  final String productName;

  ProductModel(this.productName);
}

const double PRODUCT_CARD_HEIGHT = 100.0;

Size getSizes(GlobalKey _key) {
  if (_key?.currentContext != null) {
    final RenderBox renderBox = _key.currentContext.findRenderObject();
    final size = renderBox.size;
    print("SIZE of Red: $size");
    return size;
  } else {
    return Size(0.0, 0.0);
  }
}

Offset getPositions(GlobalKey _key) {
  if (_key?.currentContext != null) {
    final RenderBox renderBox = _key.currentContext.findRenderObject();
    final position = renderBox.localToGlobal(Offset.zero);
    // print("POSITION of Red: $position");
    return position;
  } else {
    return Offset(0.0, 0.0);
  }
}

double categoryNameHeight = 20.0 + 16.0 + 3.0; // 20.0 -> font size , 16.0 -> vertical padding of the widget
List<double> _positions = List<double>();
List<double> get positions => _positions;

prepareCategoryPositions(double initPosition) {
  double _lastPreparedPosition = initPosition;
  _positions.add(_lastPreparedPosition);
  for (var i = 0; i < categories.length - 1; i++) {
    double _position = _lastPreparedPosition +
        categoryNameHeight +
        (categories[i].products.length * PRODUCT_CARD_HEIGHT) + // product length * product card size
        ((categories[i].products.length) * 8.0) + // space size between product cards
        8.0; //FIXME categoryHeightKey
    _lastPreparedPosition = _position;
    _positions.add(_lastPreparedPosition);
  }
  print(_positions);
}

double _lastListSize = categoryNameHeight +
    (categories[categories.length - 1].products.length * PRODUCT_CARD_HEIGHT) + // product length * product card size
    ((categories[categories.length - 1].products.length) * 8.0) + // space size between product cards
    8.0 + //FIXME categoryHeightKey
    86.0;

double getBottomHeight(BuildContext context) {
  double _screenSize = MediaQuery.of(context).size.height;
  double _bottomHeight = _lastListSize >= _screenSize ? 0.0 : (_screenSize - _lastListSize);
  return _bottomHeight;
}

GlobalKey getKey(index) {
  GlobalKey index = new GlobalKey();
  return index;
}
