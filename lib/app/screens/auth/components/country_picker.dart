import 'dart:async';

import 'package:ejara/app/entities/utils/style.dart';
import 'package:ejara/app/entities/utils/tools.dart';
import 'package:ejara/core/core.dart' show KareeRouter;
import 'package:flutter/material.dart';

class CountryPicker extends StatefulWidget {
  final FocusNode focusNode;
  final String initialPhone;
  CountryPicker({Key key, this.focusNode, this.initialPhone}) : super(key: key);
  @override
  CountryPickerState createState() => CountryPickerState();
}

class CountryPickerState extends State<CountryPicker>
    with SingleTickerProviderStateMixin {
  String countryName = 'Cameroon';
  String countryCode = 'CM';
  String countryDial = '+237';
  String countryPhone = '';
  String countryFullPhone = '';

  Function state, dialCodeState, listState;

  List<Map> countries, copyCountries;

  StreamController<List<Map>> filteredCountries;

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final GlobalKey<FormState> formKey = GlobalKey();

  @override
  void initState() {
    filteredCountries = StreamController.broadcast();
    print(widget.initialPhone);
    if (widget.initialPhone?.startsWith('+') ?? false) {
      if (widget.initialPhone?.startsWith(countryDial) ?? false)
        countryPhone = widget.initialPhone.substring(4);
    } else {
      countryCode = 'CM';
      countryDial = '+237';
      countryPhone = widget.initialPhone;
      countryName = 'Cameroon';
    }
    super.initState();
  }

  void dispose() {
    filteredCountries.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> d;
    return FutureBuilder<Map<String, dynamic>>(
        initialData: d = {
          'code': countryCode ?? 'CM',
          'dial': countryDial ?? '+237',
          'name': countryName ?? 'Cameroon'
        },
        future:
            widget.initialPhone != null && widget.initialPhone.startsWith('+')
                ? Tools.countryEmoji.getCountryByFullPhone(widget.initialPhone)
                : Future.value(d),
        builder: (_, snap) {
          countryDial = snap.data != null ? snap.data['dial'] : countryDial;
          if (widget.initialPhone?.length ??
              0 > countryDial.length &&
                  widget.initialPhone.startsWith(countryDial))
            countryPhone =
                widget.initialPhone?.substring(countryDial?.length ?? 0) ?? '';
          else
            countryPhone =
                widget.initialPhone?.replaceAll(RegExp('[ +-]'), '') ?? '';
          countryCode = snap.data != null ? snap.data['code'] : countryCode;
          countryName = snap.data['name'];
          countryFullPhone =
              '$countryDial${countryPhone.replaceAll(RegExp('[ +-]'), '')}';

          return Container(
            //height: 40,
            decoration: BoxDecoration(
                // color: Colors.pink,
                ),
            child: Row(
              children: [
                GestureDetector(
                    onTap: () {
                      showBottomSheet(
                          elevation: 20,
                          context: context,
                          builder: (_) {
                            return Container(
                                height: MediaQuery.of(context).size.height,
                                child: Column(
                                  children: [
                                    Container(
                                        height:
                                            MediaQuery.of(context).padding.top,
                                        color: Style.primaryColor),
                                    AppBar(),
                                    Container(
                                        margin: EdgeInsets.only(
                                            top: 10, left: 10, right: 10),
                                        height: 50,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              // color: Colors.green,
                                              width: 0.5,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: TextField(
                                            controller:
                                                TextEditingController(text: ''),
                                            onChanged: (_) {
                                              _ = _.trim();
                                              if (_.isEmpty) {
                                                countries
                                                  ..clear()
                                                  ..addAll(copyCountries);
                                                listState?.call(() {});
                                              } else {
                                                countries = []
                                                  ..addAll(copyCountries
                                                      .where((country) =>
                                                          (country['name'] +
                                                                  country[
                                                                      'dial'])
                                                              .toString()
                                                              .toLowerCase()
                                                              .contains(_
                                                                  .toLowerCase()))
                                                      .toList());
                                                listState?.call(() {});
                                              }
                                            },
                                            decoration: InputDecoration(
                                                prefixIcon: Icon(Icons.search),
                                                border: InputBorder.none,
                                                labelText: 'Rechercher un pays',
                                                labelStyle:
                                                    TextStyle(fontSize: 12)))),
                                    Expanded(
                                        child: Container(
                                      height: MediaQuery.of(_).size.height,
                                      child: FutureBuilder<List<Map>>(
                                        future: countries == null
                                            ? Tools.countryEmoji
                                                .getAllCountries()
                                            : Future.value(countries),
                                        builder: (_, snap) {
                                          if (!snap.hasData)
                                            return Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          if (countries == null) {
                                            countries = snap.data;
                                            copyCountries = []
                                              ..addAll(countries);
                                          }

                                          return StatefulBuilder(
                                              builder: (_, sn) {
                                            listState = sn;
                                            return ListView.builder(
                                                itemCount: countries.length,
                                                itemBuilder: (ctns, index) {
                                                  var item;
                                                  try {
                                                    item = countries[index];
                                                  } catch (e) {
                                                    return Container(height: 0);
                                                  }
                                                  var displayedName =
                                                      '  (${item["dial"]}) ${item['name']}';
                                                  TextStyle textStyle =
                                                      TextStyle(fontSize: 12);

                                                  return Container(
                                                      height: 35,
                                                      decoration:
                                                          BoxDecoration(),
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      child: ListTile(
                                                          onTap: () {
                                                            this.countryCode =
                                                                item['code'];
                                                            this.countryName =
                                                                item['name'];
                                                            this.countryDial =
                                                                item['dial'];
                                                            KareeRouter.goBack(
                                                                context);
                                                            state?.call(() {});
                                                            dialCodeState
                                                                ?.call(() {});
                                                            return;
                                                          },
                                                          dense: true,
                                                          title: Row(children: [
                                                            Tools.countryEmoji
                                                                .countryCodeToEmoji(
                                                                    item[
                                                                        'code']),
                                                            Text(
                                                                displayedName.substring(
                                                                    0,
                                                                    displayedName.length >
                                                                            40
                                                                        ? 40
                                                                        : displayedName
                                                                            .length),
                                                                style:
                                                                    textStyle)
                                                          ])));
                                                });
                                          });
                                        },
                                      ),
                                    ))
                                  ],
                                ));
                          });
                    },
                    child: Container(
                        width: 50,
                        //height: 40,
                        decoration: BoxDecoration(
                            // border: Border.all(color: Colors.black87, width: 0.2)
                            ),
                        child: StatefulBuilder(builder: (_, st) {
                          state = st;
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Tools.countryEmoji
                                  .countryCodeToEmoji(countryCode),
                              Icon(Icons.keyboard_arrow_down_rounded,
                                  size: 20, color: Colors.black87)
                            ],
                          );
                        }))),
                Expanded(
                    child: Container(
                        padding: EdgeInsets.only(
                          left: 10,
                        ),
                        child: Form(
                            key: formKey,
                            child: TextFormField(
                              focusNode: widget.focusNode,
                              onChanged: (_) {
                                this.countryPhone = _
                                    .replaceAll(RegExp(r'[\s-_]'), '')
                                    .replaceAll(' ', '')
                                    .trim();
                                this.countryFullPhone =
                                    this.countryDial + this.countryPhone;
                              },
                              keyboardType: TextInputType.phone,
                              validator: (_) {
                                _ = _.replaceAll(RegExp(r'[\s-_]'), '');
                                return _.isEmpty
                                    ? 'Phone number is required'
                                    : _.length < 5
                                        ? 'Phone number too short'
                                        : null;
                              },
                              onSaved: (_) => this.countryPhone = _,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              style: TextStyle(fontSize: 12),
                              decoration: InputDecoration(
                                  prefixIcon: StatefulBuilder(builder: (_, sf) {
                                    dialCodeState = sf;
                                    return Container(
                                        width: 20,
                                        margin: EdgeInsets.only(top: 12),
                                        child: Text(
                                          countryDial,
                                          style: TextStyle(fontSize: 12),
                                        ));
                                  }),
                                  errorStyle: TextStyle(fontSize: 9),
                                  hintStyle: TextStyle(fontSize: 12),
                                  contentPadding:
                                      EdgeInsets.only(bottom: 5, top: 8),
                                  border: UnderlineInputBorder(),
                                  hintText: "Phone Number"),
                            ))))
              ],
            ),
          );
        });
  }

  Widget slideIt(
      BuildContext context, int index, Animation animation, List<Map> data) {
    var item;
    // Future.delayed(
    //     Duration(seconds: 2),
    //     () => listKey.currentState
    //         .insertItem(index, duration: Duration(seconds: 2)));
    try {
      item = countries[index];
    } catch (e) {
      print(index);
      return Container();
    }
    var displayedName = '  (${item["dial"]}) ${item['name']}';
    TextStyle textStyle = TextStyle(fontSize: 12);
    // listKey.currentState.insertItem(index, duration: Duration(seconds: 1));
    return SlideTransition(
      position: Tween<Offset>(begin: Offset(-100, 0), end: Offset(0, 0))
          .animate(CurvedAnimation(
              parent: animation,
              curve: Curves.bounceIn,
              reverseCurve: Curves.bounceOut)),
      child: Container(
          height: 35,
          decoration: BoxDecoration(),
          padding: EdgeInsets.only(left: 10),
          child: ListTile(
              onTap: () {
                this.countryCode = item['code'];
                this.countryName = item['name'];
                this.countryDial = item['dial'];
                KareeRouter.goBack(context);
                state?.call(() {});
                return;
              },
              dense: true,
              title: Row(children: [
                Tools.countryEmoji.countryCodeToEmoji(item['code']),
                Text(
                    displayedName.substring(0,
                        displayedName.length > 40 ? 40 : displayedName.length),
                    style: textStyle)
              ]))),
    );
  }

  bool validate() {
    formKey.currentState.validate();
    formKey.currentState.save();
    print("dial = $countryDial");
    print("phone = $countryPhone");
    print("full = $countryFullPhone");
    bool t = (this.countryDial.isNotEmpty &&
        this.countryPhone.isNotEmpty &&
        this.countryFullPhone.isNotEmpty);
    print('simple validation $t');
    return t;
  }

  void reset() {
    formKey.currentState.reset();
  }
}
