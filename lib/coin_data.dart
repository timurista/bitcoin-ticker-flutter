import 'dart:convert';

import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'USD',
  'GBP',
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const String coin_api_key = "F1EB0BB5-7EB6-4D0E-817F-DEF09626E121";
const int TLL_IN_MS = 1000 * 60 * 5; // 5 minutes

class CoinData {
  var _coinData = Map();
  Future<dynamic> getBTCExchangeRate(
      {cryptoCurrency = "BTC", currency = "USD"}) async {
    String rateKey = cryptoCurrency + '.' + currency;
    if (_coinData[rateKey] != null) {
      int currentTime = DateTime.now().toUtc().millisecondsSinceEpoch;
      if (currentTime > _coinData[rateKey]["ttl"]) {
        print('ttl expired');
        print(currentTime);
        print(_coinData[rateKey]["ttl"]);
      } else {
        print('cache hit');
        return _coinData[rateKey];
      }
    }
    String url =
        "https://rest.coinapi.io/v1/exchangerate/$cryptoCurrency/$currency";
    var res = await http.get(url, headers: {"X-CoinAPI-Key": coin_api_key});
    if (res.statusCode == 200) {
      var data = jsonDecode(res.body);
      data["ttl"] = DateTime.now()
          .add(Duration(minutes: 5))
          .toUtc()
          .millisecondsSinceEpoch;
      _coinData[rateKey] = data;
      return data;
    } else {
      print(res.body);
      return null;
    }
  }
}
