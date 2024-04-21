import 'package:flutter/material.dart';

class ColorManager{
  static Color primary = HexColor.fromHex("#2C65D8");
  static Color darkGrey = HexColor.fromHex("#393D3f");
  static Color grey = HexColor.fromHex("#737477");
  static Color lightGrey = HexColor.fromHex("#9E9E9E");
  static Color primaryOpacity70 = HexColor.fromHex("#7053EB");
  static Color background = HexColor.fromHex("#FBFBFE");
  static Color subtitle = HexColor.fromHex("#7B7B7B");
  static Color splashTitle = HexColor.fromHex("#671F1F");
  static Color tabBackground = HexColor.fromHex("#F5F5F5");
  static Color orText = HexColor.fromHex("#707070");
  static Color skipBack = HexColor.fromHex("#9A9A9A");
  static Color template1 = HexColor.fromHex("#896565");
  static Color loginScrBtn = HexColor.fromHex("#616161");
  static Color splashBackColor = HexColor.fromHex("#BBADF6");
  static Color promo2buttonColor = HexColor.fromHex("#4D4472");
  static Color promo1BgColor = HexColor.fromHex("#4D4472").withOpacity(1);
  static Color selectedPackageBorderColor = HexColor.fromHex("#E8E2FF").withOpacity(1);


  //New Colors

  static Color darkPrimary = HexColor.fromHex("#d17d11");
  static Color grey1 = HexColor.fromHex("#707070");
  static Color grey2 = HexColor.fromHex("#797979");
  static Color white = HexColor.fromHex("#FFFFFF");
  static Color lightBlue = HexColor.fromHex("#b7d7f7");
  static Color error = HexColor.fromHex("#e61f34"); //red color
  static Color statusbarColor = HexColor.fromHex("#FFFFFF");
  static Color searchBarBackColor = HexColor.fromHex("#76b5c5");
  static Color addBtnColor = HexColor.fromHex("#B2E5FF");
}

extension HexColor on Color{
  static Color fromHex(String hexColorString){
    hexColorString = hexColorString.replaceAll('#', '');
    if(hexColorString.length == 6){
      hexColorString = "FF" +hexColorString; //Appending characters for opacity of 100% at start of HexCode
    }
    return Color(int.parse(hexColorString, radix: 16));
  }
}