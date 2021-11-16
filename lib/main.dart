import 'package:country_directory/api.dart';
import 'package:country_directory/model.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Country Directory',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Country> countries = [];
  Country? selectedCountry;
  Future<List<Country>> future = getAllCountries();

  List<DropdownMenuItem<Country>> buildDropDownItem(List<Country> countries) {
    return countries
        .map((country) => DropdownMenuItem<Country>(
              child: Text(country.name),
              value: country,
            ))
        .toList();
  }

  Widget pickCountriesWidget(
      BuildContext context, AsyncSnapshot<List<Country>> snapshot) {
    var countries = snapshot.data;

    if (snapshot.connectionState == ConnectionState.done) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: DropdownButtonFormField(
          decoration: const InputDecoration(
            labelText: "Choose Country",
            border: OutlineInputBorder(),
          ),
          items: buildDropDownItem(countries!),
          value: selectedCountry,
          onChanged: (Country? country) {
            setState(() {
              selectedCountry = country;
            });
          },
        ),
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget countryDetailsWidget(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Padding(
        padding: EdgeInsets.only(top: 20),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    if (snapshot.hasError) {
      return const Center(
        child: Text("Unable to fetch country data"),
      );
    }
    Country country = snapshot.data;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Country Info",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        Card(
          color: Colors.grey.shade50,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Name"),
                    Text("Capital"),
                    Text("Country code"),
                    Text("Native"),
                    Text("Currency"),
                    Text("Phone Code"),
                    Text("Emoji"),
                  ],
                ),
                const Spacer(flex: 3),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(": ${country.name}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(": ${country.capital}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(": ${country.code}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(": ${country.native}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(": ${country.currency}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(": ${country.phone!}",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(": ${country.emoji}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        )),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: const Text("Country Directory"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: ListView(
          children: [
            const SizedBox(height: 50),
            FutureBuilder<List<Country>>(
              future: future,
              builder: (context, snapshot) {
                return pickCountriesWidget(context, snapshot);
              },
            ),
            const SizedBox(height: 20),
            if (selectedCountry != null)
              FutureBuilder<Country>(
                future: getCountry(selectedCountry!.code),
                builder: (context, snapshot) {
                  return countryDetailsWidget(context, snapshot);
                },
              ),
          ],
        ),
      ),
    );
  }
}
