import 'package:flutter/material.dart';
import 'package:room/personal/edit.dart';

updateBottomSheet(
    BuildContext context, AsyncSnapshot<List<dynamic>> snapshot, int index) {
  return showModalBottomSheet(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15.0),
    ),
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: EditPersonal.withItemData(
          snapshot.data[index]['_id'],
          snapshot.data[index]['item'],
          snapshot.data[index]['price'].toString(),
        ),
      );
    },
  );
}
