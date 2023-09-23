import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../styles/colors.dart';
import '../styles/icon_broken.dart';

String convertToAgo(DateTime input){
  Duration diff = DateTime.now().difference(input);
  if(diff.inDays >= 1){
    return '${diff.inDays} day ago';
  } else if(diff.inHours >= 1){
    return '${diff.inHours} hour ago';
  } else if(diff.inMinutes >= 1){
    return '${diff.inMinutes} minute ago';
  } else if (diff.inSeconds >= 1){
    return '${diff.inSeconds} second ago';
  } else {
    return 'just now';
  }
}


Widget defaultButton(
        {double width = double.infinity,
        Color background = defaultColor,
        bool isUpperCase = true,
        required String text,
        required function,
        double radius = 10.0}) =>
    Container(
      height: 40.0,
      width: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius), color: background),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  onSubmit,
  onChange,
  required label,
  required IconData prefix,
  bool isPassword = false,
  IconData? suffix,
  suffixPressed,
  required validate,
  onTap,
}) =>
    TextFormField(
      style: const TextStyle( color: Colors.black),
      onTap: onTap,
      controller: controller,
      keyboardType: type,
      onFieldSubmitted: onSubmit,
      obscureText: isPassword,
      onChanged: onChange,
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(onPressed: suffixPressed, icon: Icon(suffix))
            : null,
        border: const OutlineInputBorder(),
      ),
    );


Widget defaultTextButton({
  required  function,
  required String text,
}) =>
    TextButton(
      onPressed: function,
      child: Text(
        text.toUpperCase(),
      ),
    );




Widget myDivider() => Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 20.0,
  ),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
);



void navigateTo(context, widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);

void navigateAndFinish(
    context,
    widget,
    ) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
          (route)
      {
        return false;
      },
    );

void showToast({
  required String text,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

// enum
// ignore: constant_identifier_names
enum ToastStates {SUCCESS, ERROR, WARNING}

Color chooseToastColor(ToastStates state)
{
  Color color;

  switch(state)
  {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }

  return color;
}

Widget defaultAppBar({
  required BuildContext context,
  String? title,
  List<Widget>? actions,
}) => AppBar(
  leading: IconButton(
    onPressed: ()
    {
      Navigator.pop(context);
    },
    icon: const Icon(
      IconBroken.Arrow___Left_2,
    ),
  ),
  titleSpacing: 5.0,
  title: Text(
    title!,
  ),
  actions: actions,
);








