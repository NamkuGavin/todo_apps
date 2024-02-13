import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomWidget {
  static SizedBox space(BuildContext context, double height, double width) =>
      SizedBox(
        height: MediaQuery.of(context).size.height * height,
        width: MediaQuery.of(context).size.width * width,
      );

  static Widget textField(
          BuildContext context,
          String hint,
          TextEditingController controller,
          TextInputAction? inputAction,
          int maxLines) =>
      TextField(
        controller: controller,
        maxLines: maxLines,
        textInputAction: inputAction,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(20.0)),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(20.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2.0,
            ),
          ),
        ),
      );

  static SvgPicture noData(BuildContext context, double width, double height) =>
      SvgPicture.asset("assets/icon/no_data_icon.svg",
          width: MediaQuery.of(context).size.width * width,
          height: MediaQuery.of(context).size.height * height);

  static SvgPicture uploadImg(
          BuildContext context, double width, double height) =>
      SvgPicture.asset("assets/icon/upload_img_icon.svg",
          width: MediaQuery.of(context).size.width * width,
          height: MediaQuery.of(context).size.height * height);
}
