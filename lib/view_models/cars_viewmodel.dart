import 'package:dars54_authentication/models/car.dart';
import 'package:dars54_authentication/services/cars_http_services.dart';

class CarsViewmodel {
  List<Car> _cars = [];

  final carsHttpServices = CarsHttpServices();

  Future<List<Car>> get cars async {
    _cars = await carsHttpServices.getCars();
    return [..._cars];
  }

  Future<void> addCar(String name) async {
    await carsHttpServices.addCar(name);
  }
}
