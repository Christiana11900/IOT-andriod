import 'package:breathcare/ui/util/responsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ButtonThem {
  const ButtonThem({Key? key});

  static buildButton(
      BuildContext context, {
        required String title,
        double btnHeight = 50,
        double txtSize = 14,
        double btnWidthRatio = 0.87,
        bool select = false,
        Color circular = const Color(0xff367367),
        double btnRadius = 53,
        bSide = BorderSide.none,
        required Function() onPress,
        bool isVisible = true,
        Color? color,
        Color? textColor,
        FontWeight fontWeight = FontWeight.w500,
      }) {
   // final themeChange = Provider.of<DarkThemeProvider>(context, listen: false);

    return Visibility(
      visible: isVisible,
      child: SizedBox(
        width: Responsive.width(100, context) * btnWidthRatio,
        child: MaterialButton(
          onPressed: onPress,
          height: btnHeight,
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            side:   bSide,//const BorderSide(width: 1.0,color: AppColors.onBoarding),
            borderRadius: BorderRadius.circular(btnRadius),
          ),
          color: color ?? Colors.blueAccent,
          child: select? CircularProgressIndicator(color:circular, strokeWidth: 2.0,)
              :Text(
            title,
            textAlign: TextAlign.center,
            style:  TextStyle(
              color: textColor ?? const Color(0xFF2D2D2D),
              fontSize: txtSize,
              fontFamily: 'inter',
              fontWeight: fontWeight,

            ),

          ),
        ),
      ),
    );
  }

  static buildTextFiledWithSuffixIcon(
      BuildContext context, {
        required String hintText,
        required TextEditingController controller,
        required Widget suffixIcon,
        String? Function(String?)? validator,
        TextInputType keyBoardType = TextInputType.text,
        bool obscureText = false,
        bool enable = true,
      }) {
    //final themeChange = Provider.of<DarkThemeProvider>(context);

    return TextFormField(
        controller: controller,
        textAlign: TextAlign.start,
        enabled: enable,
        validator: validator,

        keyboardType: keyBoardType,
        obscureText: obscureText,
        style: GoogleFonts.manrope(
            color: Colors.black),
        decoration: InputDecoration(
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.white,
            errorStyle: const TextStyle(
                color: Colors.redAccent),
            contentPadding: const EdgeInsets.only(left: 10, right: 10),
            disabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide:
              BorderSide(color: Color(0xffE7EBE6), width: 1),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide:
              BorderSide(color: Color(0xffE7EBE6), width: 1),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide:
              BorderSide(color: Color(0xffE7EBE6), width: 1),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide:
              BorderSide(color: Color(0xffE7EBE6), width: 1),
            ),
            hintText: hintText));
  }

  static buildTextFiled(
      BuildContext context, {
        required String hintText,
        required TextEditingController controller,
        TextInputType keyBoardType = TextInputType.text,
        ValueChanged<String>? onChanged,
        String? Function(String?)? validator,
        bool enable = true,
        int maxLine = 1,
        double? txtSize = 14,
        FontWeight? weight = FontWeight.w500,
        Color? txtColor = const Color(0xFF98A1B2),
        bool mRead = false,
        Color? body = Colors.white,
        String? Function(String?)? onSaved,
      }) {
   // final themeChange = Provider.of<DarkThemeProvider>(context, listen: false);

    return TextFormField(
        readOnly: mRead,
        validator: validator,
        controller: controller,
        onSaved: onSaved,
        textAlign: TextAlign.start,
        enabled: enable,
        keyboardType: keyBoardType,
        maxLines: maxLine,
        onChanged: onChanged,
        cursorColor: Colors.blue,
        contextMenuBuilder: (context, editableTextState) {
          final List<ContextMenuButtonItem> buttonItems =
              editableTextState.contextMenuButtonItems;
          buttonItems.removeWhere((ContextMenuButtonItem buttonItem) {
            return buttonItem.type == ContextMenuButtonType.cut;
          });
          return AdaptiveTextSelectionToolbar(
            anchors: editableTextState.contextMenuAnchors,
            //buttonItems: buttonItems,
            children: editableTextState.contextMenuButtonItems.map((ContextMenuButtonItem buttonItem) {
              return CupertinoButton(
                borderRadius: null,
                // color: Colors.blue, // Here you can change the background color
                // disabledColor: Colors.red,
                onPressed: buttonItem.onPressed,
                padding: const EdgeInsets.all(10.0),
                pressedOpacity: 0.7,
                child: SizedBox(
                  // width: 200.0,
                  child: Text(
                    style: const TextStyle(
                      color: Color(0xff0A0A0A),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.14,
                    ),
                    CupertinoTextSelectionToolbarButton.getButtonLabel(context, buttonItem),
                  ),
                ),
              );
            }).toList(),
          );
        },
        style: GoogleFonts.manrope(color: Colors.black),
        decoration: InputDecoration(
            filled: true,
            fillColor: body,
            errorStyle: const TextStyle(
                color: Colors.redAccent),
            contentPadding: EdgeInsets.only(
                left: 10, right: 10, top: maxLine == 1 ? 0 : 10),
            disabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide:
              BorderSide(color: Color(0xffE7EBE6), width: 1),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Color(0xffE7EBE6), width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              borderSide:
              BorderSide(color: Color(0xffE7EBE6), width: 1),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide:
              BorderSide(color: Color(0xffE7EBE6), width: 1),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide:
              BorderSide(color: Color(0xffE7EBE6), width: 1),
            ),
            hintStyle: TextStyle(
              color: txtColor,
              fontSize: txtSize,
              fontFamily: 'inter',
              fontWeight: weight,
              letterSpacing: 0.14,
            ),
            hintText: hintText));
  }




}