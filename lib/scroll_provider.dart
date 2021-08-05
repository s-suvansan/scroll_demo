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

  void scrollListener() {
    _verticalScrollCtrl.addListener(() {
      if (!_restrictScroll) {
        int _index = _selectedIndex;
        if (_verticalScrollCtrl.position.userScrollDirection == ScrollDirection.forward) {
          if (!_index.isNegative && _verticalScrollCtrl.position.pixels < (positions[_index] - 90.0)) {
            // print("scroll up");
            _index--;
            _selectedIndex = _index;
            _horizontalScrollCtrl.jumpTo(_horizontalPosition[_selectedIndex] - 8.0);
          }
        } else {
          if (_index < positions.length - 1 && _verticalScrollCtrl.position.pixels >= (positions[_index + 1] - 90.0)) {
            // print("scroll down");
            _index++;
            _selectedIndex = _index;
            _horizontalScrollCtrl.jumpTo(_horizontalPosition[_selectedIndex] - 8.0);
          }
        }
        notifyListeners();
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
    _verticalScrollCtrl.jumpTo(positions[index] - 82.0);
  }

  void prepareHorizontalBarPosition(GlobalKey categoryKey) {
    if (_horizontalPosition.length < categories.length) {
      _horizontalPosition.add(getPositions(categoryKey).dx);
    }
  }
}
