import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences_example/helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Helper.initSharedPreferences();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shared Preferences Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Colors.red.withGreen(150).withBlue(100);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Shared Preferences Example"),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          spacing: 15,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StoreData(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
                child: Text(
                  "Store Data",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: size.width,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GetData(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                ),
                child: Text(
                  "Get Data",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GetData extends StatefulWidget {
  const GetData({super.key});

  @override
  State<GetData> createState() => _GetDataState();
}

class _GetDataState extends State<GetData> {
  Color primaryColor = Colors.red.withGreen(150).withBlue(100);
  var name;
  var interest;
  var age;
  var isGraduated;
  var favouriteSubjects = {};

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    name = Helper.getName() ?? "Empty";
    interest = Helper.getInterest() ?? "Empty";
    age = Helper.getAge() ?? "Empty";
    isGraduated = Helper.getGraduatedStatus() ?? "Empty";
    var favouriteSubjectsMap = Helper.getFavouriteSubjects();
    if (favouriteSubjectsMap != null) {
      favouriteSubjects = jsonDecode(favouriteSubjectsMap);
    } else {
      favouriteSubjects = {};
    }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Get Stored Data"),
        backgroundColor: primaryColor,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputFieldTitle(title: "Your Name: "),
                SizedBox(height: 5),
                Text(name),
                SizedBox(height: 10),
                InputFieldTitle(title: "Your Interest: "),
                SizedBox(height: 5),
                Text(interest),
                SizedBox(height: 10),
                InputFieldTitle(title: "Your Age: "),
                SizedBox(height: 5),
                Text(age.toString()),
                SizedBox(height: 10),
                InputFieldTitle(title: "Is Graduated: "),
                SizedBox(height: 5),
                Text(isGraduated.toString()),
                SizedBox(height: 10),
                InputFieldTitle(title: "Your favourite subjects: "),
                SizedBox(height: 5),
                favouriteSubjects.isEmpty
                    ? Text("Empty")
                    : Wrap(
                        children: favouriteSubjects.entries.map((entry) {
                          return SizedBox(
                            width: size.width / 2.2,
                            child: Row(
                              children: [
                                Checkbox(
                                  value: entry.value,
                                  activeColor: primaryColor,
                                  onChanged: (value) {},
                                ),
                                Text(
                                  entry.key,
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                SizedBox(height: 25),
                SizedBox(
                  width: size.width,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Helper.clearSharedPreferences();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    child: Text(
                      "Remove Data",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StoreData extends StatefulWidget {
  const StoreData({super.key});

  @override
  State<StoreData> createState() => _StoreDataState();
}

class _StoreDataState extends State<StoreData> {
  TextEditingController nameController = TextEditingController();
  TextEditingController interestController = TextEditingController();
  Color primaryColor = Colors.red.withGreen(150).withBlue(100);
  int selectedAge = 20;
  bool isGraduated = false;
  bool isLoading = false;
  Map<String, bool> favouriteSubjects = {
    "Business": false,
    "IT": false,
    "Front-end": false,
    "Backend": false,
    "Full stack": false,
    "Mobile app": false,
    "HR": false,
    "Digital Marketing": false,
    "Robotics": false,
    "Cloud Computing": false,
    "Artificial Intelligence": false,
  };
  TextStyle textStyle = TextStyle(
    fontSize: 14,
    color: Colors.red,
    fontWeight: FontWeight.bold,
  );
  TextStyle hintTextStyle = TextStyle(
    fontSize: 14,
    color: Colors.grey,
    fontWeight: FontWeight.normal,
  );

  storeData() async {
    setState(() {
      isLoading = true;
    });
    await Helper.storeName(name: nameController.text);
    await Helper.storeInterest(interest: interestController.text);
    await Helper.storeAge(age: selectedAge);
    await Helper.storeGraduationStatus(value: isGraduated);
    await Helper.storeFavouriteSubjects(
        stringMapData: jsonEncode(favouriteSubjects));
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Store Data"),
        backgroundColor: primaryColor,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InputFieldTitle(title: "Name: "),
                SizedBox(height: 5),
                TextFormField(
                  controller: nameController,
                  style: textStyle,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                InputFieldTitle(title: "Interest: "),
                SizedBox(height: 5),
                TextFormField(
                  controller: interestController,
                  maxLines: 4,
                  minLines: 1,
                  style: textStyle,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                InputFieldTitle(title: "What's your age?"),
                SizedBox(height: 5),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 8,
                    children: List.generate(
                      20,
                      (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedAge = index + 20;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            decoration: BoxDecoration(
                              color: index + 20 == selectedAge
                                  ? primaryColor
                                  : Colors.grey.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "${index + 20}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: index + 20 == selectedAge
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InputFieldTitle(title: "Are you graduated?"),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: isGraduated,
                        padding: EdgeInsets.zero,
                        activeColor: primaryColor,
                        onChanged: (value) {
                          setState(() {
                            isGraduated = !isGraduated;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                InputFieldTitle(title: "Your favourite subjects?"),
                SizedBox(height: 5),
                Wrap(
                  children: favouriteSubjects.entries.map((entry) {
                    return SizedBox(
                      width: size.width / 2.2,
                      child: Row(
                        children: [
                          Checkbox(
                              value: entry.value,
                              activeColor: primaryColor,
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() {
                                  favouriteSubjects[entry.key] = value;
                                });
                              }),
                          Text(
                            entry.key,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 25),
                SizedBox(
                  width: size.width,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: storeData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    child: isLoading
                        ? Center(
                            child: Transform.scale(
                              scale: 0.7,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            "Store Data",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InputFieldTitle extends StatelessWidget {
  final String title;
  const InputFieldTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
