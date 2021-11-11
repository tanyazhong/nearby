

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///Holds the values that are updated in this page and sent back to the
class FilterValues {
  double radius = 5;
  bool gridView = true;
}

///Filter Page that allows user to change radius and switch between grid view and list view
class FilterPage extends StatefulWidget{
  final FilterValues filterValues;
  final ValueChanged<FilterValues> onChanged;
  const FilterPage({Key? key, required this.filterValues, required this.onChanged}): super(key: key);

  @override
  ///Creates mutable state for Song at a given location in the tree
  _FilterPageState createState()=> _FilterPageState( filterValues: filterValues, onChanged: onChanged);

}
///Class that holds the state of [FilterPage] and displays the filter page
class _FilterPageState extends State <FilterPage>{
  double radius;
  bool gridView;
  FilterValues filterValues;
  ValueChanged<FilterValues> onChanged;
  _FilterPageState({ required this.filterValues,  required this.onChanged}): radius = filterValues.radius, gridView = filterValues.gridView;

  @override
  ///Dispalys the page and handles callback to parent widget on user input
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: TextButton(onPressed: () {
          Navigator.of(context).pop();
        },
          child: Text('Back', style: TextStyle(color: Colors.white)))
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:[
            Container(
              child: Column(
                children: [
                  Text("See music selection of people up to $radius meters away"),
                  Slider(value: radius,
                    onChanged: (double value){
                        setState(() {
                          radius = value.truncateToDouble();
                        });
                        filterValues.radius = radius;
                        onChanged(filterValues);
                        },
                    min: 1,
                    max: 50,
                    label:radius.truncateToDouble().toString() ,
                    divisions: 10,)
            ]),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(onPressed: () {
                  setState(() {
                    gridView = true;
                  });
                  filterValues.gridView = gridView;
                  onChanged(filterValues);
                  },
                    style: TextButton.styleFrom(backgroundColor: gridView? Color.fromRGBO(93, 176, 117, 1):Color.fromRGBO(93, 176, 117, .6),
                      fixedSize: const Size(170, 40)),
                  child: Text('Grid view', style: TextStyle(color: Colors.white))),
                TextButton(onPressed: () {
                  setState(() {
                    gridView = false;
                  });
                  filterValues.gridView = gridView;
                  onChanged(filterValues);
                  },
                    style: TextButton.styleFrom(backgroundColor: !gridView? Color.fromRGBO(93, 176, 117, 1):Color.fromRGBO(93, 176, 117, .6),
                      fixedSize: const Size(170, 40)),
                    child: Text('List view', style: TextStyle(color: Colors.white))),
              ]
            )
          ]
        )
      )
    );
  }
}