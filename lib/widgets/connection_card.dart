import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:miel_work_app/common/style.dart';

class ConnectionCard extends StatelessWidget {
  const ConnectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Connectivity().onConnectivityChanged,
      builder: (context, snapshot) {
        ConnectivityResult result = ConnectivityResult.none;
        if (snapshot.data != null) {
          result = snapshot.data!.first;
        }
        if (result == ConnectivityResult.none) {
          return Padding(
            padding: const EdgeInsets.only(
              left: 4,
              right: 4,
              bottom: 8,
            ),
            child: Material(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                title: const Text(
                  'ネットワークに接続されていません',
                  style: TextStyle(
                    color: kWhiteColor,
                    fontSize: 18,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                titleAlignment: ListTileTitleAlignment.center,
                tileColor: kRedColor,
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
