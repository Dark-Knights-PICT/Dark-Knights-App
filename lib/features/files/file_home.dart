import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/file_picker_user.dart';

_launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

class FileHome extends StatefulWidget {
  const FileHome({Key? key}) : super(key: key);

  @override
  State<FileHome> createState() => _FileHomeState();
}

class _FileHomeState extends State<FileHome> {
  @override
  Widget build(BuildContext context) {
    final userUID = FirebaseAuth.instance.currentUser!.uid;
    bool showFab = true;

    Widget getFAB() {
      if (showFab) {
        return FloatingActionButton.extended(
          onPressed: () async {
            await selectFile();
            if (!mounted) return;
            await uploadFile(context, userUID);
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

    const List<Tab> tabs = <Tab>[
      Tab(
          child: Text(
        'My Documents',
        style: TextStyle(
          fontFamily: 'Lato',
        ),
      )),
      Tab(
        child: Text(
          'CA issued Documents',
          style: TextStyle(
            fontFamily: 'Lato',
          ),
        ),
      ),
    ];

    return DefaultTabController(
      length: tabs.length,
      child: Builder(builder: (BuildContext context) {
        TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {
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
            title: const Text(
              'Documents',
              style: TextStyle(
                  color: Color(0xff5ad0b5),
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
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
                        .doc(userUID)
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
                            child: document[index]['Type'] == 'UserDocument' &&
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
                                              ),
                                            ),
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
                                                'CADocument' &&
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
                                                      ),
                                                    ),
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
          floatingActionButton: tabController.index == 0 ? getFAB() : null,
        );
      }),
    );
  }
}
