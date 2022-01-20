import 'package:dm_delights/auth/signin.dart';
import 'package:dm_delights/auth/signup.dart';
import 'package:dm_delights/shared/custom/indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/translations.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool isInnerBoxScrolled) {
              return <Widget>[
                const SliverAppBar(
                  pinned: false,
                  expandedHeight: 250.0,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Image(
                      image: AssetImage('assets/logo.png'),
                      width: 128,
                      height: 128,
                    ),
                    centerTitle: true,
                  ),
                  //collapsedHeight: 100,
                ),
                SliverPersistentHeader(
                  delegate: AuthTabBarPersistentHeaderDelegate(
                    TabBar(
                      indicator: const DotIndicator(color: Colors.pink),
                      tabs: [
                        Tab(
                          child: Text(Translations.of(context)!.button_signin),
                        ),
                        Tab(
                          child: Text(Translations.of(context)!.button_signup),
                        ),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: const TabBarView(
              children: [
                SignInFragment(),
                SignUpFragment(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AuthTabBarPersistentHeaderDelegate
    extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  AuthTabBarPersistentHeaderDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(AuthTabBarPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
