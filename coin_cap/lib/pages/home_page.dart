import 'dart:convert';

import 'package:coin_cap/pages/details_page.dart';
import 'package:coin_cap/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  double? _deviceHeight, _deviceWidth;
  String? _selectedCoin = "bitcoin";
  HTTPService? _http;

  _HomePageState();

  @override
  void initState() {
    super.initState();
    _http = GetIt.instance.get<HTTPService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceWidth = MediaQuery.of(context).size.width;
    _deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _selectedCoinDropdown(),
              _dataWidgets(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectedCoinDropdown() {
    List<String> _coins = [
      "bitcoin",
      "ethereum",
      "tether",
      "cardano",
      "ripple",
    ];
    List<DropdownMenuItem<String>> _items = _coins
        .map(
          (e) => DropdownMenuItem(
            value: e,
            child: Text(
              e,
              style: TextStyle(
                color: Colors.white,
                fontSize: 40.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
        .toList();
    return DropdownButton(
      // value: _coins.first,
      value: _selectedCoin,
      items: _items,
      onChanged: (dynamic _value) {
        setState(() {
          _selectedCoin = _value;
        });
      },
      dropdownColor: const Color.fromRGBO(83, 88, 206, 1.0),
      iconSize: 30,
      icon: Icon(
        Icons.arrow_drop_down_sharp,
        color: Colors.white,
      ),
      underline: Container(),
    );
  }

  Widget _dataWidgets() {
    return FutureBuilder(
      // future: _http!.get("/coins/bitcoin"),
      future: _http!.get("/coins/${_selectedCoin.toString()}"),
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          Map _data = jsonDecode(
            _snapshot.data.toString(),
          );
          // num _usdPrice = _data["market_data"]["current_price"]["usd"];
          num _inrPrice = _data["market_data"]["current_price"]["inr"];
          num _change24h = _data["market_data"]["price_change_percentage_24h"];
          Map _exchangeRates = _data["market_data"]["current_price"];
          // debugPrint(_exchangeRates.toString());
          // return Text(_inrPrice.toString());
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              GestureDetector(
                onDoubleTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext _context) {
                        return DetailsPage(
                          rates: _exchangeRates,
                        );
                      },
                    ),
                  );
                },
                child: _coinImageWidget(
                  _data["image"]["large"],
                ),
              ),
              _currentPriceWidget(_inrPrice),
              _percentageChangeWidget(_change24h),
              _descritptionCardWidget(_data["description"]["en"]),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      },
    );
  }

  Widget _currentPriceWidget(num _rate) {
    return Text(
      "${_rate.toStringAsFixed(4)} INR",
      style: TextStyle(
        color: Colors.white,
        fontSize: 15.0,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _percentageChangeWidget(num _change) {
    return Text(
      "${_change.toString()} %",
      style: TextStyle(
        color: Colors.white,
        fontSize: 15.0,
        fontWeight: FontWeight.w300,
      ),
    );
  }

  Widget _coinImageWidget(String _imgURL) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: _deviceHeight! * 0.02,
      ),
      height: _deviceHeight! * 0.15,
      width: _deviceWidth! * 0.15,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(_imgURL),
        ),
      ),
    );
  }

  Widget _descritptionCardWidget(String _description) {
    return Container(
      height: _deviceHeight! * 0.45,
      width: _deviceWidth! * 0.90,
      margin: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.05),
      padding: EdgeInsets.symmetric(
        vertical: _deviceHeight! * 0.01,
        horizontal: _deviceHeight! * 0.01,
      ),
      color: Color.fromRGBO(
        83,
        88,
        206,
        0.5,
      ),
      child: Text(
        _description,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
