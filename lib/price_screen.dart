import 'package:flutter/material.dart';
import './coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

final CoinData coinData = CoinData();

class _PriceScreenState extends State<PriceScreen> {
  String selectedCoin = "USD";
  List<String> rates = cryptoList.map((crypto) => '1 $crypto = ? USD').toList();

  void setCurrentRate(currency) async {
    List<String> newRates = [];
    for (String crypto in cryptoList) {
      var data = await coinData.getBTCExchangeRate(
          cryptoCurrency: crypto, currency: selectedCoin);
      print(data);
      newRates.add(data != null
          ? '1 $crypto = ${data["rate"].round()} $selectedCoin'
          : '1 $crypto = ? $selectedCoin');
    }
    setState(() {
      this.rates.clear();
      this.rates.addAll(newRates);
    });
  }

  List<Widget> getChildren() {
    return rates
        .map((rateString) => Padding(
              padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
              child: Card(
                color: Colors.lightBlueAccent,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                  child: Column(
                    children: [
                      Text(
                        rateString,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: getChildren(),
          ),
          CoinSelectorButton(
            selectedValue: selectedCoin,
            onChanged: (value) {
              setState(() {
                selectedCoin = value;
                setCurrentRate(selectedCoin);
              });
            },
            onSelectedItemChanged: (index) {
              setState(() {
                selectedCoin = currenciesList[index];
                setCurrentRate(selectedCoin);
              });
            },
          ),
        ],
      ),
    );
  }
}

class CoinSelectorButton extends StatelessWidget {
  CoinSelectorButton(
      {this.selectedValue, this.onSelectedItemChanged, this.onChanged});
  final String selectedValue;
  final Function onChanged;
  final Function onSelectedItemChanged;

  DropdownButton<String> getAndroidDropdown() {
    return DropdownButton<String>(
      items: currenciesList
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(item),
              ))
          .toList(),
      value: selectedValue,
      onChanged: onChanged,
    );
  }

  CupertinoPicker getIOSPicker() {
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32,
      onSelectedItemChanged: onSelectedItemChanged,
      children: currenciesList
          .map((item) => Text(
                item,
                style: TextStyle(
                  color: Colors.white,
                ),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150.0,
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: 30.0),
      color: Colors.lightBlue,
      child: Platform.isIOS ? getIOSPicker() : getAndroidDropdown(),
    );
  }
}
