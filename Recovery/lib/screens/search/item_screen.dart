// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recovery_app/screens/HomePage/cubit/home_cubit.dart';
import 'package:recovery_app/screens/search/widgets/single_item.dart';
import 'package:recovery_app/storage/database_helper.dart';

class ItemScreen extends StatefulWidget {
  final List<Map<String, String>> detailsList;
  final String heroTag;
  const ItemScreen({
    Key? key,
    required this.detailsList,
    required this.heroTag,
  }) : super(key: key);

  @override
  State<ItemScreen> createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen> {
  final PageController controller = PageController();
  int currentIndex = 1;
  late Future<List<String>> futureBranches;
  int? itemCount;
  late Map<String, String> currentDetails;
  @override
  void initState() {
    controller.addListener(() {
      var index = controller.page!.round() + 1;
      if (index != currentIndex) {
        setState(() {
          currentIndex = index;
        });
      }
    });
    if (context.read<HomeCubit>().state.user!.isStaff) {
      show();
    }
    currentDetails = widget.detailsList[0];
    print(currentDetails);
    super.initState();
  }

  void show() async {
    var nullebleBranches = await DatabaseHelper.getBranches(widget.detailsList);
    // List<BankBranch> branches = nullebleBranches.where((e) {}).toList();
    if (context.mounted) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          if (nullebleBranches.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Found in Branches",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const Text("No branches detected"),
                ],
              ),
            );
          }
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Found in Branches",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue,
                    ),
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          currentDetails = widget.detailsList.elementAt(index);
                        });
                        print(currentDetails);
                        Navigator.of(context).pop();
                      },
                      child: ListTile(
                        trailing: Container(
                          alignment: Alignment.centerRight,
                          width: MediaQuery.of(context).size.width / 3,
                          child: Text(
                            nullebleBranches[index].fileName,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        title: Text(
                          nullebleBranches[index].bank,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          nullebleBranches[index].branch,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider();
                  },
                  itemCount: nullebleBranches.length,
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleItemScreen(
            details: currentDetails,
            heroTag: widget.heroTag,
          ),
        ),
      ),
    );
  }
}
