import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryOptionWidget extends StatefulWidget {

  final void Function (String tag)tagChange;
  final String tag;

  CategoryOptionWidget({required this.tag, required this.tagChange});
  State<CategoryOptionWidget> createState(){
    return _CategoryOptionWidgetState();
  }
}


class _CategoryOptionWidgetState extends State<CategoryOptionWidget>{
  
  bool isSelected = false;
  
  void toggleSelected(){
    setState(() {
      isSelected = !isSelected;
    });
  }
  
  
  Widget build(BuildContext context){
    return TextButton(
      style: ButtonStyle(
          backgroundColor: isSelected?
      MaterialStatePropertyAll<Color>(Colors.black)
      : MaterialStatePropertyAll<Color>(Colors.red)),
      onPressed: (){
        widget.tagChange(widget.tag);
        toggleSelected();
      },
      child: Text(
          widget.tag,
        style: TextStyle(
            color: isSelected?
            Colors.white : Colors.black),
      ),
    );
  }
}