import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_app/Services/auth_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:food_app/Widgets/Provider_Auth.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// TODO move this to tone location
final primaryColor = const Color(0xFF7AA573);
const colorlightgreen = const Color(0xFFE0EFD9);
const colordarkgreen = const Color(0xFF7AA573);

enum AuthFormType { signIn, signUp, reset }

class SignUpView extends StatefulWidget {
  final AuthFormType authFormType;

  SignUpView({Key key, @required this.authFormType}) : super(key: key);

  @override
  _SignUpViewState createState() =>
      _SignUpViewState(authFormType: this.authFormType);
}

class _SignUpViewState extends State<SignUpView> {
  AuthFormType authFormType;

  _SignUpViewState({this.authFormType});

  final formKey = GlobalKey<FormState>();
  String _email, _password, _name, _warning;

  void switchFormState(String state) {
    formKey.currentState.reset();
    if (state == AppLocalizations.of(context).register) {
      setState(() {
        authFormType = AuthFormType.signUp;
      });
    } else {
      setState(() {
        authFormType = AuthFormType.signIn;
      });
    }
  }

  bool validate() {
    final form = formKey.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    if (validate()) {
      try {
        final auth = Provider.of(context).auth;
        if (authFormType == AuthFormType.signIn) {
          String uid = await auth.signInWithEmailAndPassword(_email, _password);
          print("Signed In with ID $uid");
          Navigator.of(context).pushReplacementNamed('/home');
        } else if (authFormType == AuthFormType.reset) {
          await auth.sendPasswordResetEmail(_email);
          print("Password reset email sent");
          _warning = "An email has been sent to $_email";
          setState(() {
            authFormType = AuthFormType.signIn;
          });
        } else {
          String uid = await auth.createUserWithEmailAndPassword(
              _email, _password, _name);
          print("Signed up with New ID $uid");
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } catch (e) {
        setState(() {
          _warning = e.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: [
            Container(
              // color: colorlightgreen,
              decoration: new BoxDecoration(
                image: new DecorationImage(
                  colorFilter: new ColorFilter.mode(
                      Colors.black.withOpacity(0.4), BlendMode.darken),
                  image: new AssetImage("assets/background.png"),
                  fit: BoxFit.cover,
                ),
              ),
              height: _height,
              width: _width,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () {
                    print('Clicked outside');
                    FocusScope.of(context).unfocus();
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: _height * 0.025),
                        showAlert(),
                        SizedBox(height: _height * 0.025),
                        buildHeaderText(),
                        SizedBox(height: _height * 0.05),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: buildInputs() + buildButtons(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showAlert() {
    if (_warning != null) {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: AutoSizeText(
                _warning,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _warning = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  AutoSizeText buildHeaderText() {
    String _headerText;
    if (authFormType == AuthFormType.signUp) {
      _headerText = AppLocalizations.of(context).starttext;
    } else if (authFormType == AuthFormType.reset) {
      _headerText = AppLocalizations.of(context).resetpassword;
    } else {
      _headerText = AppLocalizations.of(context).welcomeback;
    }
    return AutoSizeText(
      _headerText,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 35,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  List<Widget> buildInputs() {
    List<Widget> textFields = [];
// Input field for missing password email
    if (authFormType == AuthFormType.reset) {
      textFields.add(
        TextFormField(
          validator: EmailValidator.validate,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(fontSize: 22.0, color: Colors.black),
          decoration: buildSignUpInputDecoration("Email".trim()),
          onSaved: (value) => _email = value,
        ),
      );
      textFields.add(SizedBox(height: 20));
      return textFields;
    }

    // if were in the sign up state add name
    if (authFormType == AuthFormType.signUp) {
      textFields.add(
        TextFormField(
          validator: NameValidator.validate,
          style: TextStyle(fontSize: 22.0, color: Colors.black),
          decoration:
              buildSignUpInputDecoration(AppLocalizations.of(context).name),
          onSaved: (value) => _name = value,
        ),
      );
      textFields.add(SizedBox(height: 20));
    }

    // add email & password
    textFields.add(
      TextFormField(
        validator: EmailValidator.validate,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(fontSize: 22.0, color: Colors.black),
        decoration: buildSignUpInputDecoration("Email".trim()),
        onSaved: (value) => _email = value,
      ),
    );
    textFields.add(SizedBox(height: 20));
    textFields.add(
      TextFormField(
        validator: PasswordValidator.validate,
        style: TextStyle(fontSize: 22.0, color: Colors.black),
        decoration:
            buildSignUpInputDecoration(AppLocalizations.of(context).password),
        obscureText: true,
        onSaved: (value) => _password = value,
      ),
    );
    textFields.add(SizedBox(height: 20));

    return textFields;
  }

  InputDecoration buildSignUpInputDecoration(String hint) {
    return InputDecoration(
      hintStyle: TextStyle(fontSize: 20.0, color: Colors.grey),
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      focusColor: Colors.grey,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 0.0)),
      contentPadding:
          const EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0),
    );
  }

  List<Widget> buildButtons() {
    String _switchButtonText, _newFormState, _submitButtonText;
    bool _showForgotPassword = false;
    bool _showSocial = true;

    if (authFormType == AuthFormType.signIn) {
      _switchButtonText = AppLocalizations.of(context).noaccountyet;
      _newFormState = AppLocalizations.of(context).register;
      _submitButtonText = "Log in";
      _showForgotPassword = true;
    } else if (authFormType == AuthFormType.reset) {
      _switchButtonText = AppLocalizations.of(context).backtologin;
      _newFormState = "Log in";
      _submitButtonText = AppLocalizations.of(context).askemail;
      _showSocial = false;
    } else {
      _switchButtonText = AppLocalizations.of(context).alreadyaccount;
      _newFormState = "Log in";
      _submitButtonText = AppLocalizations.of(context).register;
    }

    return [
      Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: ElevatedButton(
          // shape:
          //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          // color: Colors.white,
          // textColor: primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _submitButtonText,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
            ),
          ),
          onPressed: submit,
        ),
      ),
      // showForgotPassword(_showForgotPassword),
      // TextButton(
      //   child: Text(
      //     _switchButtonText,
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   onPressed: () {
      //     switchFormState(_newFormState);
      //   },
      // ),
      buildSocialIcons(_showSocial),
    ];
  }

  Widget showForgotPassword(bool visible) {
    return Visibility(
      child: TextButton(
        child: Text(
          AppLocalizations.of(context).forgotpassword,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          setState(() {
            authFormType = AuthFormType.reset;
          });
        },
      ),
      visible: visible,
    );
  }

  Widget buildSocialIcons(bool visibility) {
    final _auth = Provider.of(context).auth;
    return Visibility(
      child: Column(
        children: <Widget>[
          Divider(
            color: Colors.white,
          ),
          SizedBox(height: 10),
        ],
      ),
      // visible: visible,
    );
  }
}
