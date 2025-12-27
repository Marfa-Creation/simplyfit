import 'package:flutter/material.dart';

class ProgramRunView extends StatelessWidget {
  const ProgramRunView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                "Push up",
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xffc0caf5),
                borderRadius: BorderRadiusGeometry.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  Expanded(
                    flex: 5,
                    child: Stack(
                      children: [
                        Align(
                          alignment: .topRight,
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.more_time),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: .center,
                          children: [
                            Row(
                              mainAxisAlignment: .center,
                              children: [
                                Icon(Icons.close, weight: 80, size: 30),
                                Text(
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  "10",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: Size(250, 45)),
                    onPressed: () {},
                    child: Text(style: TextStyle(fontSize: 20), "Done"),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: .spaceBetween,
                      crossAxisAlignment: .end,
                      children: [
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(8),
                              ),
                            ),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: .center,
                              children: [
                                Icon(Icons.skip_previous),
                                Text(
                                  style: TextStyle(fontSize: 17),
                                  "Previous",
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(8),
                              ),
                            ),
                            onPressed: () {},
                            child: Row(
                              mainAxisAlignment: .center,
                              children: [
                                Icon(Icons.skip_next),
                                Text(style: TextStyle(fontSize: 17), "Next"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
