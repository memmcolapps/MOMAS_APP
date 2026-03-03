import 'package:flutter/material.dart';
import 'package:momaspayplus/domain/data/response/user_model.dart';
import 'package:momaspayplus/screens/tab_views/customer/Homepage/widgets/main_balance.dart';
import 'package:momaspayplus/utils/colors.dart';
import 'package:momaspayplus/utils/shared_pref.dart';
import 'package:momaspayplus/utils/strings.dart';

class HomePageHeader extends StatefulWidget {

  const HomePageHeader({
    super.key,
    required this.safePadding,
  });

  final EdgeInsets safePadding;

  @override
  State<HomePageHeader> createState() => _HomePageHeaderState();
}

class _HomePageHeaderState extends State<HomePageHeader> {
  User? user;
  String name = "";

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    user = await SharedPreferenceHelper.getUser();
    getName(user);
  }

  getName(User? user) {
    var firstname = isEmpty(user?.firstName) ? "" : user?.firstName;
    var lastName = isEmpty(user?.lastName) ? "" : user?.lastName;
    name = "$firstname $lastName";
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            stops: const [0.5, 0.8],
            colors: [
              MoColors.mainColor,
              MoColors.mainColorII,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius:
              const BorderRadius.only(bottomRight: Radius.circular(50)),
        ),
        child: Padding(
          padding: EdgeInsetsGeometry.only(
              top: widget.safePadding.top + 12, left: 16, right: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi $name,",
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 20,
              ),
              MainBalance(),
              const SizedBox(
                height: 60,
              )
            ],
          ),
        ),
      ),
    );
  }
}
