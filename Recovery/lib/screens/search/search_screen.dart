import 'dart:async';
import 'dart:developer';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/resources/color_manager.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';
import 'package:recovery_app/screens/search/item_screen.dart';
import 'package:recovery_app/services/remote_sql_services.dart';
import 'package:recovery_app/services/utils.dart';
import 'package:recovery_app/storage/database_helper.dart';
import 'package:recovery_app/models/search_item_model.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SearchScreen1 extends StatefulWidget {
  const SearchScreen1({super.key});

  @override
  State<SearchScreen1> createState() => SearchScreen1State();
}

class SearchScreen1State extends State<SearchScreen1> {
  late Future<List<String>> futureTitles;
  bool _isSearchComplete = true;
  final TextEditingController _controller = TextEditingController();
  // final _streamController = StreamController<Map<String, dynamic>>();

  @override
  void initState() {
    super.initState();
  }

  CancelableOperation<List<SearchResultItem>>? operation;
  List<SearchResultItem> displayItems = [];
  List<SearchResultItem> items = [];
  List<SearchResultItem>? filteredItems;
  bool isContainerVisible = false;
  @override
  void dispose() {
    // _streamController.close();
    super.dispose();
  }

  bool isAllNumbers = false;
  bool isOnVehicle = true;
  bool isOnline = false;
  Future<List<SearchResultItem>> search(String searchTerm) async {
    log("search started");
    if (isOnline) {
      return await RemoteSqlServices.searchVehicles(
        searchTerm,
        context.read<HomeCubit>().state.user!.agencyId,
        isOnVehicle,
      );
    } else {
      return await DatabaseHelper.getResult(
        isOnVehicle ? Utils.removeHyphens(_controller.text) : _controller.text,
        isOnVehicle,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          if (isContainerVisible) {
            setState(() {
              isContainerVisible = false;
            });
          }
        },
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey
                              .withOpacity(0.5), // Color of the shadow
                          spreadRadius: 2, // Spread radius
                          blurRadius: 4, // Blur radius
                          offset: const Offset(0, 3), // Shadow offset
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 150,
                          child: TextField(
                            // keyboardType:
                            //     isOnVehicle ? TextInputType.phone : null,
                            inputFormatters: isOnVehicle
                                ? [
                                    LengthLimitingTextInputFormatter(4),
                                  ]
                                : null,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  isOnVehicle ? " eg: 1301" : "eg: MA123485",
                              prefixIcon: InkWell(
                                  onTap: () async {},
                                  child: const CircleAvatar(
                                      child: Icon(Icons.search))),
                              prefixIconConstraints:
                                  const BoxConstraints(minWidth: 50),
                            ),
                            controller: _controller,
                            onChanged: (value) async {
                              if (value.length == (isOnVehicle ? 4 : 17)) {
                                items = await search(
                                    isOnVehicle ? value : value.toUpperCase());
                                displayItems = items;
                                filteredItems = null;
                                _isSearchComplete = true;
                              } else {
                                _isSearchComplete = false;
                              }
                              setState(() {});
                            },
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isContainerVisible = true;
                            });
                          },
                          child: const Icon(
                            Icons.settings,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_isSearchComplete && _controller.text.length == 4) ...[
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey
                                .withOpacity(0.5), // Color of the shadow
                            spreadRadius: 2, // Spread radius
                            blurRadius: 4, // Blur radius
                            offset: const Offset(0, 3), // Shadow offset
                          ),
                        ],
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 100,
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "filter here eg: MH or RJ",
                            prefixIcon: InkWell(
                                onTap: () async {},
                                child: const CircleAvatar(
                                    child: Icon(Icons.search))),
                            prefixIconConstraints:
                                const BoxConstraints(minWidth: 50),
                          ),
                          onChanged: (value) async {
                            if (value.isNotEmpty) {
                              displayItems = items
                                  .where((element) => element.item
                                      .toUpperCase()
                                      .contains(value.toUpperCase()))
                                  .toList();
                            }
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(
                    height: 10,
                  ),
                  if (displayItems.isEmpty &&
                      _controller.text.isNotEmpty &&
                      _isSearchComplete) ...[
                    const SizedBox(
                      height: 100,
                    ),
                    Center(
                      child: Text("No search results for ${_controller.text}"),
                    )
                  ] else if (_isSearchComplete)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) {
                            return Divider(
                              indent: 20,
                              endIndent: 20,
                              color: Colors.grey[300],
                            );
                          },
                          itemCount: context
                                  .read<HomeCubit>()
                                  .state
                                  .searchSettings
                                  .isTwoColumnSearch
                              ? ((displayItems.length + 1) ~/ 2)
                              : displayItems.length,
                          itemBuilder: (context, index) {
                            if (context
                                .read<HomeCubit>()
                                .state
                                .searchSettings
                                .isTwoColumnSearch) {
                              return SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 40,
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: _itemListTile(
                                            context,
                                            index *
                                                2)), // First item in the row
                                    if (index * 2 + 1 <
                                        displayItems.length) ...[
                                      // Check if there is a second item
                                      VerticalDivider(
                                        color: Colors.grey[300],
                                      ),
                                      Expanded(
                                          child: _itemListTile(
                                              context,
                                              index * 2 +
                                                  1)) // Second item in the row
                                    ],
                                  ],
                                ),
                              );
                            }
                            return _itemListTile(context, index);
                          },
                        ),
                      ),
                    )
                  else if (_controller.text.length == 4)
                    Container(
                      height: 500,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    )
                  else if (!isOnVehicle)
                    Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Center(
                        child: InkWell(
                          onTap: () async {
                            items = await search(
                              isOnVehicle
                                  ? _controller.text
                                  : _controller.text.toUpperCase(),
                            );
                            displayItems = items;
                            filteredItems = null;
                            _isSearchComplete = true;
                            setState(() {});
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey
                                      .withOpacity(0.5), // Color of the shadow
                                  spreadRadius: 2, // Spread radius
                                  blurRadius: 4, // Blur radius
                                  offset: const Offset(0, 3), // Shadow offset
                                ),
                              ],
                            ),
                            height: 40,
                            width: 100,
                            child: Text(
                              "Search",
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    const SizedBox(),
                ],
              ),
              if (isContainerVisible)
                Positioned(
                  top: 20.0,
                  right: 20.0,
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    height: 200,
                    width: MediaQuery.of(context).size.width * 0.7,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey
                              .withOpacity(0.5), // Color of the shadow
                          spreadRadius: 2, // Spread radius
                          blurRadius: 4, // Blur radius
                          offset: const Offset(0, 3), // Shadow offset
                        ),
                      ],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Search with"),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isContainerVisible = false;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    'x',
                                    style: GoogleFonts.poppins(
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          ToggleSwitch(
                            minWidth: 90.0,
                            cornerRadius: 20.0,
                            activeBgColors: [
                              [ColorManager.primary],
                              [ColorManager.primary]
                            ],
                            activeFgColor: Colors.white,
                            inactiveBgColor:
                                const Color.fromARGB(255, 216, 221, 239),
                            inactiveFgColor: Colors.black54,
                            initialLabelIndex: isOnVehicle ? 0 : 1,
                            totalSwitches: 2,
                            labels: ['Vehicle', 'Chassi'],
                            radiusStyle: true,
                            onToggle: (index) {
                              setState(() {
                                isOnVehicle = index == 0;
                              });
                            },
                          ),
                          const Row(
                            children: [
                              Text("Search on"),
                            ],
                          ),
                          ToggleSwitch(
                            minWidth: 90.0,
                            cornerRadius: 20.0,
                            activeBgColors: [
                              [ColorManager.primary],
                              [ColorManager.primary]
                            ],
                            activeFgColor: Colors.white,
                            inactiveBgColor:
                                const Color.fromARGB(255, 216, 221, 239),
                            inactiveFgColor: Colors.black54,
                            initialLabelIndex: isOnline ? 0 : 1,
                            totalSwitches: 2,
                            labels: ['Online', 'Offline'],
                            radiusStyle: true,
                            onToggle: (index) {
                              setState(() {
                                isOnline = index == 0;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell _itemListTile(BuildContext context, int index) {
    return InkWell(
      onTap: () async {
        log(displayItems[index].toString());
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (c) => ItemScreen(
              detailsList: displayItems[index].rows,
              heroTag: displayItems[index].item.toUpperCase(),
            ),
          ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        // padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          displayItems[index].item.toUpperCase(),
          style: GoogleFonts.poppins(
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
