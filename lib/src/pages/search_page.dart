import 'package:flutter/material.dart';
import 'package:timezone_locations_app/src/providers/timezones_provider.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _queryController;
  List<String> itemList = [];
  List filteredItems = [];
  bool _isSearching = false;
// https://github.com/bitfumes/flutter-country-house/blob/master/lib/Screens/AllCountries.dart

  @override
  void initState() {
    _queryController = TextEditingController();
    timezoneProvider.loadTimezone().then((value) {
      setState(() {
        itemList = filteredItems = value;
      });
    });
    super.initState();
  }

  _filterList(value) {
    setState(() {
      filteredItems = itemList
          .where((timezone) =>
              timezone.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !_isSearching
            ? Text('All Timezones')
            : TextField(
                controller: _queryController,
                autofocus: true,
                decoration: InputDecoration(
                    hintText: 'Search Timezone', border: InputBorder.none),
                onChanged: (value) {
                  _filterList(value);
                },
              ),
        actions: <Widget>[
          _isSearching
              ? IconButton(
                  icon: Icon(Icons.cancel),
                  onPressed: () {
                    setState(() {
                      this._isSearching = false;
                      filteredItems = itemList;
                    });
                  },
                )
              : IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      this._isSearching = true;
                    });
                  },
                )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: filteredItems.length > 0
            ? ListView.builder(
                itemCount: filteredItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      // Navigator.of(context).pushNamed(Country.routeName,
                      //     arguments: filteredCountries[index]);
                    },
                    child: Card(
                      elevation: 10,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 8),
                        child: Text(
                          filteredItems[index],
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  );
                })
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
