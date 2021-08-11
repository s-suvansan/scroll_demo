import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scroll_demo/data.dart';

class ScrollProvider with ChangeNotifier {
  bool _restrictScroll = false;
  int _selectedIndex = 0;
  int get getSelectedIndex => _selectedIndex;

  ScrollController _horizontalScrollCtrl = ScrollController();
  ScrollController get horizontalScrollCtrl => _horizontalScrollCtrl;
  set setHorizontalScrollCtrl(ScrollController value) => _horizontalScrollCtrl = value;

  ScrollController _verticalScrollCtrl = ScrollController();
  ScrollController get verticalScrollCtrl => _verticalScrollCtrl;
  set setVerticalScrollCtrl(ScrollController value) => _verticalScrollCtrl = value;

  List<double> _horizontalPosition = [];
  List<double> get horizontalPosition => _horizontalPosition;

  List<double> _verticalPosition = [];
  List<double> get verticalPosition => _verticalPosition;

  List<GlobalKey> _horizontalCategoryKey = List<GlobalKey>();
  List<GlobalKey> get horizontalCategoryKey => _horizontalCategoryKey;

  void prepareHorizontalCategoryKey() {
    if (_horizontalCategoryKey.length < categories.length) {
      for (var i = 0; i < categories.length; i++) {
        _horizontalCategoryKey.add(getKey(i));
      }
    }
  }

  List<GlobalKey> _verticalCategoryKey = List<GlobalKey>();
  List<GlobalKey> get verticalCategoryKey => _verticalCategoryKey;

  void prepareVerticalCategoryKey() {
    if (_verticalCategoryKey.length < categories.length) {
      for (var i = 0; i < categories.length; i++) {
        _verticalCategoryKey.add(getKey(i));
      }
    }
  }

  void scrollListener() {
    _verticalScrollCtrl.addListener(() {
      if (!_restrictScroll) {
        int _index = _selectedIndex;
        if (_verticalScrollCtrl.position.userScrollDirection == ScrollDirection.forward) {
          if (!_index.isNegative && _verticalScrollCtrl.position.pixels < (positions[_index] - 90.0)) {
            // print("scroll up");
            _index--;
            _selectedIndex = _index;
            notifyListeners();
            _horizontalScrollCtrl.jumpTo(_horizontalPosition[_selectedIndex] - 8.0);
          }
        } else {
          if (_index < positions.length - 1 && _verticalScrollCtrl.position.pixels >= (positions[_index + 1] - 90.0)) {
            // print("scroll down");
            _index++;
            _selectedIndex = _index;
            notifyListeners();
            _horizontalScrollCtrl.jumpTo(_horizontalPosition[_selectedIndex] - 8.0);
          }
        }
      } else if (_verticalScrollCtrl.position.userScrollDirection == ScrollDirection.idle) {
        _restrictScroll = false;
      }
    });
  }

  void navigateToPosition(int index) {
    _restrictScroll = true;
    _selectedIndex = index;
    notifyListeners();
    _horizontalScrollCtrl.jumpTo(_horizontalPosition[_selectedIndex] - 8.0);
    // _verticalScrollCtrl.animateTo(positions[index] - 82.0, curve: Curves.linear, duration: Duration(milliseconds: 500));
    _verticalScrollCtrl.jumpTo(positions[index] - 82.0);
  }

  double _horizontalCategoryLast = 0.0;
  void prepareHorizontalBarPosition(int index) {
    if (_horizontalPosition.length < categories.length && index > _horizontalPosition.length - 1) {
      if (_horizontalPosition.isNotEmpty) {
        _horizontalPosition.add(_horizontalPosition.last + _horizontalCategoryLast + 8.0);
      } else {
        _horizontalPosition.add(8.0);
      }
      _horizontalCategoryLast = getSizes(_horizontalCategoryKey[index]).width;
      // print(_horizontalCategoryLast);
      // _horizontalPosition.add(getPositions(categoryKey).dx);
    }
  }

  double _verticalCategoryLast = 0.0;
  void prepareVerticalListPosition(int index) {
    if (_verticalPosition.length < categories.length && index > _verticalPosition.length - 1) {
      if (_verticalPosition.isNotEmpty) {
        _verticalPosition.add(_verticalPosition.last + _verticalCategoryLast + 8.0);
      } else {
        _verticalPosition.add(82.0);
      }
      _verticalCategoryLast = getSizes(_verticalCategoryKey[index]).height;
      print(_verticalCategoryLast);
    }
    // print(_verticalPosition);
  }

  double getLastHorizontalSpaceWidth(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    double _value = _screenWidth;
    try {
      double _lastCategoryWidth = _horizontalPosition[categories.length - 1] - _horizontalPosition[categories.length - 2];
      _value = _screenWidth - (_lastCategoryWidth + 38.0);
    } catch (e) {
      _value = _screenWidth;
    }
    return _value;
  }
}
