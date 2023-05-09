import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:weather_app/models/forecast_weather.dart';
import 'package:weather_app/utils/ListPhotos.dart';
import 'package:weather_app/db/cityDb.dart';
import 'package:weather_app/services/meteo_service.dart';
import 'package:weather_app/services/db_service.dart';
import 'package:weather_app/widgets/next_day.dart';
import '../db/cityDb.dart';
import '../models/meteo.dart';
import '../utils/variable.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController cityController = TextEditingController();

  String date = ("00" + (DateTime.now().hour).toString())
          .substring(((DateTime.now().hour).toString()).length) +
      ":" +
      ("00" + (DateTime.now().minute).toString())
          .substring(((DateTime.now().minute).toString()).length);
  late DatabaseHandler handler;
  /**
   * GetActualWeather 
   * @return Meteo
   */
  Meteo? currentData;

  Future getWeatherData(cityController) async {
    currentData = await cityRequest(cityController);
    return currentData;
  }

  @override
  /**
   * Init projet
   * get sharedpref value 
   */
  void initState() {
    // TODO: implement initState
    super.initState();
    launchApp().then((value) {
      setState(() {
        CitySelected = value.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    handler = DatabaseHandler();
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/img/spring.jpeg"),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("MyWeatherApp"),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
        ),
        body: CitySelected == ""
            ? CircularProgressIndicator(
                backgroundColor: Colors.cyanAccent,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              )
            : ShowWeather(),
        drawer: DrawerCreation(),
      ),
    );
  }

  FutureBuilder<dynamic> ShowWeather() {
    return FutureBuilder(
        future: getWeatherData(CitySelected),
        builder: (context, snapshot) {
          /**
           * choose image by weather status on API
           */
          late String weatherImage;

          String _setImage() {
            String meteoStatus;
            if (snapshot.connectionState == ConnectionState.waiting)
              meteoStatus = "Clear";
            else
              meteoStatus = "${currentData?.weather?[0].main}";
            if (CitySelected == "Kiev" || CitySelected == "Moscou") {
              return weatherImage = photoPokemon[4].imagePath;
            } else {
              switch (meteoStatus) {
                case "Clear":
                  return weatherImage = photoPokemon[3].imagePath;
                case "Drizzle":
                  return weatherImage = photoPokemon[3].imagePath;
                case "Rain":
                  return weatherImage = photoPokemon[2].imagePath;
                case "Thunderstorm":
                  return weatherImage = photoPokemon[2].imagePath;
                case "Snow":
                  return weatherImage = photoPokemon[2].imagePath;
                case "Clouds":
                  return weatherImage = photoPokemon[0].imagePath;
                case "Mist":
                  return weatherImage = photoPokemon[2].imagePath;
                default:
                  return weatherImage = photoPokemon[3].imagePath;
              }
            }
          }
          // }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => Scaffold.of(context).openDrawer(),
                      child: Text(CitySelected),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                    ),
                    Text(
                      date.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Image(
                    width: 200,
                    image: AssetImage(_setImage()),
                    fit: BoxFit.cover,
                  ),
                ),
                Center(
                  child: Text(
                    "${currentData?.weather?[0].main}",
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                Center(
                  child: Text(
                    CitySelected,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.air,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "${currentData?.wind?.speed!} km/h", //vitesse du vent
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.opacity_outlined,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              "${currentData?.main?.humidity!} %", //humidité
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        // Row(
                        //   children: const [
                        //     Padding(
                        //       padding: EdgeInsets.all(8.0),
                        //       child: Icon(
                        //         Icons.light_mode_outlined,
                        //         color: Colors.black,
                        //       ),
                        //     ),
                        //     Text(
                        //       "1.5h",
                        //       style: TextStyle(
                        //         color: Colors.black,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                    Text(
                      "${currentData?.main?.temp!.toInt()}°C", //temperature
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 100,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            top: BorderSide(width: 1.0, color: Colors.white))),
                    child: nextDay(photoPokemon, CitySelected),
                  ),
                ),
              ],
            ),
          );
        });
  }
  /***
   * Drawer on left side
   */

  Drawer DrawerCreation() {
    return Drawer(
      child: FutureBuilder<List>(
          future: handler.allCities(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.cyanAccent,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                  itemCount: snapshot.data!.length + 1,
                  itemBuilder: (context, i) {
                    if (i == 0) {
                      return DrawerHeader(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage("assets/img/spring.jpeg"),
                            fit: BoxFit.cover,
                          )),
                          child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                CitySelected,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: ElevatedButton(
                                        child: const Text("Add a City"),
                                        onPressed: () {
                                          showDialog(
                                            /**
                                             * Dialog pop up 
                                             */
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                  child: Container(
                                                      constraints:
                                                          BoxConstraints(
                                                              maxHeight: 350),
                                                      child:
                                                          DefaultTabController(
                                                              length: 3,
                                                              child: Container(
                                                                height: 150,
                                                                color: Colors
                                                                    .white,
                                                                child: Center(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      children: <
                                                                          Widget>[
                                                                        TextField(
                                                                          controller:
                                                                              cityController,
                                                                          decoration:
                                                                              const InputDecoration(
                                                                            border:
                                                                                OutlineInputBorder(),
                                                                            hintText:
                                                                                'Quel ville ajouter ? ',
                                                                          ),
                                                                        ),
                                                                        Center(
                                                                          child:
                                                                              ElevatedButton(
                                                                            child:
                                                                                const Text('Add City'),
                                                                            onPressed:
                                                                                () {
                                                                              Cities cityObj = Cities(name: cityController.text.toString());
                                                                              setState(() {
                                                                                handler.insertCity(cityObj);
                                                                              });
                                                                              Navigator.pop(context);
                                                                            },
                                                                          ),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ))));
                                            },
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            )
                          ]));
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        child: ListTile(
                            title: Text(snapshot.data![i - 1].name),
                            onTap: () {
                              Navigator.of(context).pop();
                              setState(() {
                                CitySelected = snapshot.data![i - 1].name;
                                initTown(CitySelected);
                              });
                            },
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  handler
                                      .deleteCity(snapshot.data![i - 1].name);
                                });
                              },
                            )),
                      );
                    }
                  });
            } else {
              return const Text("An error occured.");
            }
          }),
    );
  }
}
