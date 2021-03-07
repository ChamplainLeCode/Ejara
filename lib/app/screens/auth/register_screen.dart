import 'package:ejara/app/entities/user_entry.dart';
import 'package:ejara/app/entities/utils/response_entity.dart';
import 'package:ejara/app/entities/utils/style.dart';
import 'package:ejara/app/screens/auth/components/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:ejara/core/core.dart' show KareeRouter, Screen;
import 'package:string_validator/string_validator.dart' as StringValidator;

/// Generated Karee Screen
/// @email champlainmarius20@gmail.com
/// @github ChamplainLeCode
///
///
///
/// `RegisterScreen` is set as Screen with name `register`
@Screen("register", isInitial: true)
class RegisterScreen extends StatefulWidget {
  _RegisterState createState() => new _RegisterState();
}

class _RegisterState extends State<RegisterScreen> {
  GlobalKey<CountryPickerState> countryKey;
  GlobalKey<FormState> _formKey;
  GlobalKey<ScaffoldState> _scaffoldKey;
  FocusNode _phoneNode, _emailNode, _usernameNode;
  bool isLoading;
  UserEntry _user;

  void initState() {
    _scaffoldKey = GlobalKey();
    _user = UserEntry();
    isLoading = false;
    countryKey = GlobalKey();
    _formKey = GlobalKey();
    _phoneNode = FocusNode();
    _emailNode = FocusNode();
    _usernameNode = FocusNode();
    super.initState();
  }

  void dispose() {
    // add your custom code for disposing all objects
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
              height: size.height / 2,
              child: Stack(fit: StackFit.loose, children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/header.png"),
                        fit: BoxFit.cover),
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(height: 50),
                          Image(
                            image: AssetImage("images/logo.jpg"),
                            width: 100,
                            height: 120,
                          ),
                          SizedBox(height: 30),
                          Center(
                              child: Text("Create an Account",
                                  style: TextStyle(
                                      color: Style.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)))
                        ]))
              ])),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    focusNode: _usernameNode,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (_) {
                      _ = _.trim();
                      if (_.contains(' '))
                        return 'Username cannot contains spaces';
                      if (StringValidator.matches(_, r'[0-9a-zA-Z_]+')) {
                        return _.toLowerCase().contains('ejara')
                            ? 'Ejara is not allowed in username'
                            : _.length < 3
                                ? 'Username too short'
                                : _.length > 30
                                    ? 'Username too long'
                                    : null;
                      } else
                        return 'Only alphanumeric chars and _ are allowed';
                    },
                    onFieldSubmitted: (_) => _emailNode.requestFocus(),
                    onSaved: (_) => _user.username = _,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: fieldDecorationStyle,
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                    ),
                    style: fieldTextStyle,
                  ),
                  TextFormField(
                    focusNode: _emailNode,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => _phoneNode.requestFocus(),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSaved: (_) => _user.email = _,
                    validator: (_) {
                      return StringValidator.isEmail(_.trim())
                          ? null
                          : 'Invalid email address';
                    },
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: fieldDecorationStyle,
                      border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                    ),
                    style: fieldTextStyle,
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 40,
                      child: CountryPicker(
                        key: countryKey,
                        focusNode: _phoneNode,
                      )),
                  Container(
                    child: Text(
                      'A confirmation code will be sent to you',
                      style: TextStyle(fontSize: 10),
                    ),
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.centerLeft,
                  ),
                  StatefulBuilder(
                      builder: (_, st) => isLoading
                          ? Container(
                              margin: EdgeInsets.only(top: 30),
                              width: size.width,
                              height: 40,
                              padding: EdgeInsets.only(top: 5, bottom: 5),
                              child: Center(
                                  child: CircularProgressIndicator(
                                backgroundColor: Colors.white,
                              )),
                            )
                          : Container(
                              margin: EdgeInsets.only(top: 30, bottom: 30),
                              width: size.width,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Style.primaryColor),
                              child: FlatButton(
                                textColor: Style.whiteColor,
                                child: Text("Next"),
                                onPressed: () async {
                                  print('isloadin = $isLoading');
                                  if (_formKey.currentState.validate() &&
                                      countryKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    isLoading = true;
                                    st(() {});
                                    _user.phone =
                                        countryKey.currentState.countryPhone;
                                    _user.countryCode =
                                        countryKey.currentState.countryCode;
                                    ResponseEntity<String> response =
                                        await KareeRouter.goto(
                                            "/security/validate/register",
                                            parameter: _user);
                                    if (mounted) {
                                      st(() => isLoading = false);
                                      if (response.status) {
                                        _scaffoldKey.currentState.showSnackBar(
                                            SnackBar(
                                                duration: Duration(seconds: 10),
                                                content:
                                                    Text("Welcome on Ejara")));
                                        _formKey.currentState.reset();
                                        countryKey.currentState.reset();
                                      } else {
                                        _scaffoldKey.currentState.showSnackBar(
                                            SnackBar(
                                                duration: Duration(seconds: 10),
                                                content: Text(response.body)));
                                      }
                                    }
                                    // st(() => isLoading = true);
                                    // Future.delayed(Duration(seconds: 2),
                                    //     () => st(() => isLoading = false));
                                  } else {
                                    print('form invalid');
                                  }
                                },
                              )))
                ],
              ),
            ),
          )
        ])));
  }

  TextStyle get fieldTextStyle => TextStyle(fontSize: 12);
  TextStyle get fieldDecorationStyle =>
      TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w400);
}
