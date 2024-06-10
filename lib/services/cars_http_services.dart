import 'dart:convert';

import 'package:dars54_authentication/models/car.dart';
import 'package:dars54_authentication/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CarsHttpServices {
  Future<List<Car>> getCars() async {
    String userId = await getUserId();

    Uri url = Uri.parse(
        'https://lesson50-efebe-default-rtdb.asia-southeast1.firebasedatabase.app/cars.json?orderBy="creatorId"&equalTo="${userId}"');

    final response = await http.get(url);
    final data = jsonDecode(response.body);
    List<Car> cars = [];

    if (data != null) {
      data.forEach((key, value) {
        cars.add(
          Car(
            id: key,
            name: value['name'],
            creatorId: value['creatorId'],
          ),
        );
      });
    }

    return cars;
  }

  Future<void> addCar(String name) async {
    Uri url = Uri.parse(
        "https://lesson50-efebe-default-rtdb.asia-southeast1.firebasedatabase.app/cars.json");
    String userId = await getUserId();
    final response = await http.post(
      url,
      body: jsonEncode(
        {
          "name": name,
          "creatorId": userId,
        },
      ),
    );

    print(response.body);
  }

  Future<String> getUserId() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final userData = sharedPreferences.getString("userData");
    final user = User.fromMap(jsonDecode(userData!));

    return user.id;
  }
}
