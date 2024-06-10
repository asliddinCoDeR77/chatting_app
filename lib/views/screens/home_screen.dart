import 'package:dars54_authentication/view_models/cars_viewmodel.dart';
import 'package:dars54_authentication/views/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final carsViewModel = CarsViewmodel();
  final nameController = TextEditingController();

  void addCar() async {
    await carsViewModel.addCar(nameController.text);
    nameController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bosh Sahifa"),
        actions: [
          IconButton(
            onPressed: () async {
              SharedPreferences sharedPreferences =
                  await SharedPreferences.getInstance();
              sharedPreferences.remove("userData");

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (ctx) {
                    return const LoginScreen();
                  },
                ),
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: "Mashina nomi",
                suffixIcon: IconButton(
                  onPressed: addCar,
                  icon: const Icon(Icons.add),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Mashinalarim",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: carsViewModel.cars,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final cars = snapshot.data;

                    return cars == null || cars.isEmpty
                        ? const Center(
                            child: Text("Mashinalar mavjud emas!"),
                          )
                        : ListView.builder(
                            itemCount: cars.length,
                            itemBuilder: (ctx, index) {
                              return Card(
                                color: Colors.amber,
                                child: ListTile(
                                  title: Text(cars[index].name),
                                ),
                              );
                            },
                          );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
