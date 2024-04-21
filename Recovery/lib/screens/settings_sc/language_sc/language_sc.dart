import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../resources/color_manager.dart';

class LanguageScView extends StatefulWidget {
  const LanguageScView({super.key});

  @override
  State<LanguageScView> createState() => _LanguageScViewState();
}

class _LanguageScViewState extends State<LanguageScView> {
  List<String> _languageList() => ["English", "Arabic", "Spanish"];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const BackButton(),
        centerTitle: true,
        backgroundColor: ColorManager.primary,
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: ColorManager.primary,
          statusBarColor: ColorManager.primary,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
        title: const Text(
          "Language",
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 25),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: ListView.builder(
            itemCount: _languageList().length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return _getRow(title: _languageList()[index], index: index);
            }),
      ),
    );
  }

  Widget _getRow({required String title, required int index}) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
            _selectedIndex == index
                ? Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: ColorManager.primary, width: 2),
                        shape: BoxShape.circle),
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                          color: ColorManager.primary, shape: BoxShape.circle),
                    ),
                  )
                : Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: ColorManager.primary, width: 2),
                        shape: BoxShape.circle),
                  )
          ],
        ),
      ),
    );
  }
}
