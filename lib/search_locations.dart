import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http ;
class SearchLocation extends StatefulWidget {
  const SearchLocation({super.key});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  final searchCotroller = TextEditingController();
  var uuid = const Uuid();
  List<dynamic> places = [ ];
  String _sessiontoken = "123456";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchCotroller.addListener(() {

      onChanged();
     });
  getsuggestion(searchCotroller.text);
  
  }
void getsuggestion(String input)async{
String kPLACES_API_KEY = 'AIzaSyD_oHrVzqFOs5jGAOAH-w33x4I7_cZwl1I';
String baseURL ='https://maps.googleapis.com/maps/api/place/autocomplete/json';
String request = '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessiontoken';
var response = await http.get(Uri.parse(request));
print(response);
if(response.statusCode == 200){
setState(() {
  places = jsonDecode(response.body.toString());
});

}else{
  throw Exception('Failed to Load Places');
}
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Places"),),
      body: Column(children: [
        const SizedBox(height: 30), 
        TextFormField(
          controller: searchCotroller,
          decoration: const InputDecoration(
            hintText: "Search"

          ),
        )
      ],),
    );
  }
  
  void onChanged() {
    if(_sessiontoken == null){setState(() {
      
      _sessiontoken = uuid.v4();
    });
    }
  }

}