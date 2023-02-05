import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class SearchPlaces extends StatefulWidget {
  const SearchPlaces({Key? key}) : super(key: key);

  @override
  State<SearchPlaces> createState() => _SearchPlacesState();
}

class _SearchPlacesState extends State<SearchPlaces> {

  final String apiKey = 'AIzaSyDy-s0vjcrlBEpK9TxN0sICvkH8loDPCjw';

  List<dynamic> placesList = [];

  String? token;
  var uuid = const Uuid();

  TextEditingController controller = TextEditingController();
  void getPlacesRequest(){
    setState(() {
      token ??= uuid.v4();
    });

    getSuggestion(controller.text);
  }

  void getSuggestion(String text)async{

    debugPrint('the token is$token');
    String baseUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    var response = await http.get(Uri.parse('$baseUrl?input=$text&key=$apiKey&sessiontoken=$token'));
    print(response.body.toString());
    if(response.statusCode == 200){
      setState(() {
        placesList = jsonDecode(response.body.toString()) ['predictions'];
      });
    }
    else{
      debugPrint('response is ${response.statusCode}');
    }
  }

  @override
  void initState(){
    super.initState();
    controller.addListener(() {
      getPlacesRequest();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('google places search api'),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'enter place to search place',
            ) ,
          ),
        ],
      ),
    );
  }
}
