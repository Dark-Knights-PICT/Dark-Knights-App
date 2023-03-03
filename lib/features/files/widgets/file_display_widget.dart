// ignore_for_file: deprecated_member_use, use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../models/select_client_details.dart';
import '../../../services/file_picker_user.dart';

_launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

// ignore: must_be_immutable
class AdminUserFiles extends StatefulWidget {
//  AdminUserFiles({Key? key, required this.username}) : super(key: key, username: username);
  AdminUserFiles({Key? key, required this.username}) : super(key: key);
  String username;
  @override
  State<AdminUserFiles> createState() => _AdminUserFilesState();
}

class _AdminUserFilesState extends State<AdminUserFiles> {
  @override
  Widget build(BuildContext context) {
    bool showFab = true;

    Widget _getFAB() {
      if (showFab) {
        return FloatingActionButton.extended(
          onPressed: () async {
            await selectFile();
            await uploadFile(context, documentOfUID!, type: "CADocument");
          },
          label: const Text(
            'Upload',
            style: TextStyle(
              fontFamily: 'Lato',
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          icon: const Icon(
            Icons.upload,
          ),
        );
      } else {
        return Container();
      }
    }

    // final deviceHeight = MediaQuery.of(context).size.height;
    //final deviceWidth = MediaQuery.of(context).size.width;

    const List<Tab> tabs = <Tab>[
      Tab(
          child: Text(
        'CA issued Documents',
        style: TextStyle(
          fontFamily: 'Lato',
        ),
      )),
      Tab(
          child: Text(
        'User Documents',
        style: TextStyle(
          fontFamily: 'Lato',
        ),
      ))
    ];

    // const List<String> _myDocs = [
    //   'Aadhar Card',
    //   'PAN Card',
    // ];
    // const List<String> _caDocs = [
    //   'Balance Sheet',
    //   'Loan Application',
    // ];

    return DefaultTabController(
      length: tabs.length,
      // The Builder widget is used to have a different BuildContext to access
      // closest DefaultTabController.
      child: Builder(builder: (BuildContext context) {
        TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          // Your code goes here.
          // To get index of current tab use tabController.index
          if (tabController.index == 0) {
            setState(() {
              showFab = true;
            });
          } else {
            setState(() {
              showFab = false;
            });
          }
        });
        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xff010413),
            title: Text(
              '${widget.username}\'s Documents',
              style: const TextStyle(
                  color: Color(0xff5ad0b5),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Lato'),
            ),
            bottom: const TabBar(
              tabs: tabs,
            ),
          ),
          body: TabBarView(
            children: tabs.map((Tab tab) {
              return Container(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                color: const Color(0xff010413),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .doc(documentOfUID)
                        .collection("Documents")
                        .snapshots(),
                    builder: (ctx, AsyncSnapshot documentSnapshots) {
                      if (documentSnapshots.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final document = documentSnapshots.data!.docs;
                      return ListView.builder(
                        itemCount: document.length,
                        itemBuilder: (ctx, index) {
                          return Container(
                            child: document[index]['Type'] == 'CADocument' &&
                                    tabController.index == 0
                                ? InkWell(
                                    onTap: () {
                                      _launchURL(document[index]['URL']);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 15,
                                      ),
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.15,
                                      decoration: const BoxDecoration(
                                        color: Color(0xff403ffc),
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Row(
                                        children: [
                                          //Image
                                          if (document[index]['Name']
                                                      .split(".")
                                                      .last ==
                                                  'jpg' ||
                                              document[index]['Name']
                                                      .split(".")
                                                      .last ==
                                                  'jepg')
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 4,
                                              ),
                                              child: Image.asset(
                                                'assets/images/jpg_icon.png',
                                                // fit: BoxFit.cover, //default
                                              ),
                                            ),
                                          if (document[index]['Name']
                                                  .split(".")
                                                  .last ==
                                              'doc')
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 4,
                                              ),
                                              padding: const EdgeInsets.only(
                                                right: 2,
                                              ),
                                              child: Image.asset(
                                                'assets/images/doc_icon.png',
                                                // fit: BoxFit.cover, //default
                                              ),
                                            ),
                                          if (document[index]['Name']
                                                  .split(".")
                                                  .last ==
                                              'pdf')
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 4,
                                              ),
                                              padding: const EdgeInsets.only(
                                                right: 2,
                                              ),
                                              child: Image.asset(
                                                'assets/images/pdf_icon.png',
                                                // fit: BoxFit.cover, //default
                                              ),
                                            ),
                                          if (document[index]['Name']
                                                  .split(".")
                                                  .last ==
                                              'docx')
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 4,
                                              ),
                                              padding: const EdgeInsets.only(
                                                right: 2,
                                              ),
                                              child: Image.asset(
                                                'assets/images/docx_icon.png',
                                                // fit: BoxFit.cover, //default
                                              ),
                                            ),
                                          if (document[index]['Name']
                                                  .split(".")
                                                  .last ==
                                              'xls')
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 4,
                                              ),
                                              child: Image.asset(
                                                'assets/images/xls_icon.png',
                                                // fit: BoxFit.cover, //default
                                              ),
                                            ),
                                          if (document[index]['Name']
                                                  .split(".")
                                                  .last ==
                                              'xlsx')
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 4,
                                              ),
                                              padding: const EdgeInsets.only(
                                                right: 2,
                                              ),
                                              child: Image.asset(
                                                'assets/images/xlsx_icon.png',
                                                // fit: BoxFit.cover, //default
                                              ),
                                            ),
                                          if (document[index]['Name']
                                                  .split(".")
                                                  .last ==
                                              'csv')
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 4,
                                              ),
                                              padding: const EdgeInsets.only(
                                                right: 2,
                                              ),
                                              child: Image.asset(
                                                'assets/images/csv_icon.png',
                                                // fit: BoxFit.cover, //default
                                              ),
                                            ),
                                          if (document[index]['Name']
                                                  .split(".")
                                                  .last ==
                                              'ppt')
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 4,
                                              ),
                                              padding: const EdgeInsets.only(
                                                right: 2,
                                              ),
                                              child: Image.asset(
                                                'assets/images/ppt_icon.png',
                                                // fit: BoxFit.cover, //default
                                              ),
                                            ),
                                          if (document[index]['Name']
                                                  .split(".")
                                                  .last ==
                                              'pptx')
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 4,
                                              ),
                                              padding: const EdgeInsets.only(
                                                right: 2,
                                              ),
                                              child: Image.asset(
                                                'assets/images/pptx_icon.png',
                                                // fit: BoxFit.cover, //default
                                              ),
                                            ),
                                          if (document[index]['Name']
                                                      .split(".")
                                                      .last !=
                                                  'jpg' &&
                                              document[index]['Name']
                                                      .split(".")
                                                      .last !=
                                                  'jepg' &&
                                              document[index]['Name']
                                                      .split(".")
                                                      .last !=
                                                  'pdf' &&
                                              document[index]['Name']
                                                      .split(".")
                                                      .last !=
                                                  'docx' &&
                                              document[index]['Name']
                                                      .split(".")
                                                      .last !=
                                                  'doc' &&
                                              document[index]['Name']
                                                      .split(".")
                                                      .last !=
                                                  'xls' &&
                                              document[index]['Name']
                                                      .split(".")
                                                      .last !=
                                                  'xlsx' &&
                                              document[index]['Name']
                                                      .split(".")
                                                      .last !=
                                                  'csv' &&
                                              document[index]['Name']
                                                      .split(".")
                                                      .last !=
                                                  'pptx' &&
                                              document[index]['Name']
                                                      .split(".")
                                                      .last !=
                                                  'ppt')
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 4,
                                              ),
                                              padding: const EdgeInsets.only(
                                                right: 2,
                                              ),
                                              child: Image.asset(
                                                'assets/images/file_icon.png',
                                                // fit: BoxFit.cover, //default
                                              ),
                                            ),

                                          //********** */
                                          //pdf, jpg, jepg, docx/doc, xlsx/csv/xls, ppt/pptx
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                FittedBox(
                                                  child: Text(
                                                    document[index]['Name']
                                                        .split(".")
                                                        .first,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Lato',
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  '.${document[index]['Name'].split(".").last} file',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Lato',
                                                    fontSize: 12.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(
                                    child: document[index]['Type'] ==
                                                'UserDocument' &&
                                            tabController.index == 1
                                        ? InkWell(
                                            onTap: () {
                                              _launchURL(
                                                  document[index]['URL']);
                                            },
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                vertical: 5,
                                                horizontal: 15,
                                              ),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.15,
                                              decoration: const BoxDecoration(
                                                color: Color(0xff403ffc),
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                              child: Row(
                                                children: [
                                                  //Image
                                                  if (document[index]['Name']
                                                              .split(".")
                                                              .last ==
                                                          'jpg' ||
                                                      document[index]['Name']
                                                              .split(".")
                                                              .last ==
                                                          'jepg')
                                                    Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 10,
                                                        vertical: 4,
                                                      ),
                                                      child: Image.asset(
                                                        'assets/images/jpg_icon.png',
                                                        // fit: BoxFit.cover, //default
                                                      ),
                                                    ),
                                                  if (document[index]['Name']
                                                          .split(".")
                                                          .last ==
                                                      'doc')
                                                    Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 10,
                                                        vertical: 4,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.only(
                                                        right: 2,
                                                      ),
                                                      child: Image.asset(
                                                        'assets/images/doc_icon.png',
                                                        // fit: BoxFit.cover, //default
                                                      ),
                                                    ),
                                                  if (document[index]['Name']
                                                          .split(".")
                                                          .last ==
                                                      'pdf')
                                                    Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 10,
                                                        vertical: 4,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.only(
                                                        right: 2,
                                                      ),
                                                      child: Image.asset(
                                                        'assets/images/pdf_icon.png',
                                                        // fit: BoxFit.cover, //default
                                                      ),
                                                    ),
                                                  if (document[index]['Name']
                                                          .split(".")
                                                          .last ==
                                                      'docx')
                                                    Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 10,
                                                        vertical: 4,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.only(
                                                        right: 2,
                                                      ),
                                                      child: Image.asset(
                                                        'assets/images/docx_icon.png',
                                                        // fit: BoxFit.cover, //default
                                                      ),
                                                    ),
                                                  if (document[index]['Name']
                                                          .split(".")
                                                          .last ==
                                                      'xls')
                                                    Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 10,
                                                        vertical: 4,
                                                      ),
                                                      child: Image.asset(
                                                        'assets/images/xls_icon.png',
                                                        // fit: BoxFit.cover, //default
                                                      ),
                                                    ),
                                                  if (document[index]['Name']
                                                          .split(".")
                                                          .last ==
                                                      'xlsx')
                                                    Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 10,
                                                        vertical: 4,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.only(
                                                        right: 2,
                                                      ),
                                                      child: Image.asset(
                                                        'assets/images/xlsx_icon.png',
                                                        // fit: BoxFit.cover, //default
                                                      ),
                                                    ),
                                                  if (document[index]['Name']
                                                          .split(".")
                                                          .last ==
                                                      'csv')
                                                    Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 10,
                                                        vertical: 4,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.only(
                                                        right: 2,
                                                      ),
                                                      child: Image.asset(
                                                        'assets/images/csv_icon.png',
                                                        // fit: BoxFit.cover, //default
                                                      ),
                                                    ),
                                                  if (document[index]['Name']
                                                          .split(".")
                                                          .last ==
                                                      'ppt')
                                                    Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 10,
                                                        vertical: 4,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.only(
                                                        right: 2,
                                                      ),
                                                      child: Image.asset(
                                                        'assets/images/ppt_icon.png',
                                                        // fit: BoxFit.cover, //default
                                                      ),
                                                    ),
                                                  if (document[index]['Name']
                                                          .split(".")
                                                          .last ==
                                                      'pptx')
                                                    Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 10,
                                                        vertical: 4,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.only(
                                                        right: 2,
                                                      ),
                                                      child: Image.asset(
                                                        'assets/images/pptx_icon.png',
                                                        // fit: BoxFit.cover, //default
                                                      ),
                                                    ),
                                                  if (document[index]['Name']
                                                              .split(".")
                                                              .last !=
                                                          'jpg' &&
                                                      document[index]['Name']
                                                              .split(".")
                                                              .last !=
                                                          'jepg' &&
                                                      document[index]['Name']
                                                              .split(".")
                                                              .last !=
                                                          'pdf' &&
                                                      document[index]['Name']
                                                              .split(".")
                                                              .last !=
                                                          'docx' &&
                                                      document[index]['Name']
                                                              .split(".")
                                                              .last !=
                                                          'doc' &&
                                                      document[index]['Name']
                                                              .split(".")
                                                              .last !=
                                                          'xls' &&
                                                      document[index]['Name']
                                                              .split(".")
                                                              .last !=
                                                          'xlsx' &&
                                                      document[index]['Name']
                                                              .split(".")
                                                              .last !=
                                                          'csv' &&
                                                      document[index]['Name']
                                                              .split(".")
                                                              .last !=
                                                          'pptx' &&
                                                      document[index]['Name']
                                                              .split(".")
                                                              .last !=
                                                          'ppt')
                                                    Container(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 10,
                                                        vertical: 4,
                                                      ),
                                                      padding:
                                                          const EdgeInsets.only(
                                                        right: 2,
                                                      ),
                                                      child: Image.asset(
                                                        'assets/images/file_icon.png',
                                                        // fit: BoxFit.cover, //default
                                                      ),
                                                    ),

                                                  //********** */
                                                  //pdf, jpg, jepg, docx/doc, xlsx/csv/xls, ppt/pptx
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        FittedBox(
                                                          child: Text(
                                                            document[index]
                                                                    ['Name']
                                                                .split(".")
                                                                .first,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  'Lato',
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ),
                                                        Text(
                                                          '.${document[index]['Name'].split(".").last} file',
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily: 'Lato',
                                                            fontSize: 12.5,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                          );
                        },
                      );
                    }),
              );
            }).toList(),
          ),
          floatingActionButton: tabController.index == 0 ? _getFAB() : null,
        );
      }),
    );
  }
}
