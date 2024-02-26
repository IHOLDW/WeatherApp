import "dart:convert";
import "dart:ui";

import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:weather_app/additional_info_icon.dart";
import "package:weather_app/api.dart";
import "package:weather_app/weatherCard.dart";
import 'package:http/http.dart' as http;

class Frspg extends StatefulWidget {
  const Frspg({super.key});

  @override
  State<Frspg> createState() => _FrspgState();
}

class _FrspgState extends State<Frspg> {
  late Future weather;
  final TextEditingController cnt = TextEditingController();
  String city = "Kanpur";
  Future dataCollect() async {
    try {
      final res = await http.get(
        Uri.parse(
            "http://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=$apiKey"),
      );
      final data = jsonDecode(res.body);
      if (data["cod"] != "200") {
        throw data["message"];
      }
      return data;
      // tmp = (data["list"][0]["main"]["temp"]);
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = dataCollect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Text(
            "Weather",
            style: TextStyle(
              fontSize: 25,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                city = cnt.text;
              });
            },
            child: const Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.refresh),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: Colors.white,
                strokeWidth: 4,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final data = snapshot.data;
          final curentTemp = data["list"][0]["main"]["temp"] - 270;
          final weatherMain = data["list"][0]["weather"][0]["main"];
          final tmp = curentTemp.toStringAsFixed(2);
          final humidity = data["list"][0]["main"]["humidity"];
          final windSpeed = data["list"][0]["wind"]["speed"];
          final pressure = data["list"][0]["main"]["pressure"];
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 50,
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 15),
                  child: TextField(
                    controller: cnt,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search_outlined),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          width: 2,
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          width: 2,
                          color: Colors.grey,
                        ),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(500, 10, 0, 0),
                      hintText: "Location",
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                //main card
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  width: double.infinity,
                  height: 230,
                  // margin: EdgeInsets.fromLTRB(left, top, right, bottom),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25)),
                      elevation: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  "$tmp",
                                  style: const TextStyle(
                                    fontSize: 35,
                                    // backgroundColor: Color.fromARGB(11, 8, 1, 1),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Icon(
                                  weatherMain == "Clouds" ||
                                          weatherMain == "Clear"
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  size: 64,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "$weatherMain",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                  child: Text(
                    "Weather forecast",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                // const SizedBox(
                //   height: 4,
                // ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: [
                //       const Padding(
                //         padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                //       ),
                //       for (int i = 1; i <= 5; i++)
                //         WthrCard(
                //             ic: Icons.cloud,
                //             temp: (data["list"][i]["main"]["temp"] - 270)
                //                 .toStringAsFixed(2),
                //             time: "9:00"),
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, idx) {
                        final tme =
                            DateTime.parse(data["list"][idx + 1]["dt_txt"]);
                        return WthrCard(
                            ic: data["list"][idx + 1]["weather"][0]["main"] ==
                                        "Clear" ||
                                    data["list"][idx + 1]["weather"][0]
                                            ["main"] ==
                                        "Clouds"
                                ? Icons.sunny
                                : Icons.cloud,
                            time: DateFormat.j().format(tme),
                            temp: (data["list"][idx + 1]["main"]["temp"] - 270)
                                .toStringAsFixed(2));
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    "Additional Information",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceAround, //does automatically padding
                  children: [
                    AddiotionalIcon(
                      icn: Icons.cloud,
                      label: "Humidity",
                      data: humidity,
                    ),
                    AddiotionalIcon(
                        icn: Icons.wind_power,
                        label: "Wind Speed",
                        data: windSpeed),
                    AddiotionalIcon(
                        icn: Icons.umbrella_rounded,
                        label: "Pressure",
                        data: pressure),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
