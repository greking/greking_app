import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:my_app/loading.dart';
import 'package:my_app/question.dart';
import 'package:my_app/terms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'privacy.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Signup(),
    );
  }
}

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String _errorText = "";
  String _emailMessage = "";
  String _emaildupMessage = "";
  String _passwordMessage = "";
  String _passwordConfirmMessage = "";
  String _nicknameMessage = "";

  Color _emailMessageColor = Colors.red;
  Color _emaildupMessageColor = Colors.red;

  Color _passwordMessageColor = Colors.red;
  Color _passwordConfirmMessageColor = Colors.red;
  Color _nicknameMessageColor = Colors.black;

  Color _errorMessageColor = Color(0xfff74440);
  Color _successMessageColor = Color(0xff0d615c);

  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  final TextEditingController _nicknameController = TextEditingController();
  bool _obscureText = true;
  bool _isNicknameValid = false;
  bool _isEmailValid = false;
  bool _isFormValid = false;
  bool _ischeckValid = false;
  bool _isAgreed = false;
  bool _isPrivacyAgreed = false;
  final String _url = 'http://43.203.197.86:8080';
  final String _emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  void _validateForm() {
    setState(() {
      _isFormValid = _formKey.currentState!.validate() &&
          _isNicknameValid &&
          _isEmailValid;
    });
  }

  void _validatecheck() {
    setState(() {
      _ischeckValid = _isAgreed && _isPrivacyAgreed;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LoadingScreen();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Container(),
          backgroundColor: Colors.white.withOpacity(0.0),
          bottomOpacity: 0.0,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFF4F6F7),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 40.0),
                Text(
                  'Please create\nyour account',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Pretendard',
                  ),
                ),
                SizedBox(height: 40.0),
                _buildEmailField(),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    SizedBox(width: 8.0),
                    if (_emailMessageColor == _successMessageColor)
                      SvgPicture.asset('assets/check_circle.svg',
                          width: 16, height: 16),
                    if (_emailMessageColor == Color(0xfff74440))
                      SvgPicture.asset('assets/check_circle2.svg',
                          width: 16, height: 16),
                    Text(
                      _emailMessage,
                      style: TextStyle(color: _emailMessageColor, fontSize: 12),
                    ),
                    SizedBox(width: 16.0),
                    if (_emaildupMessageColor == _successMessageColor)
                      SvgPicture.asset('assets/check_circle.svg',
                          width: 16, height: 16),
                    if (_emaildupMessageColor == Color(0xfff74440))
                      SvgPicture.asset('assets/check_circle2.svg',
                          width: 16, height: 16),
                    Text(
                      _emaildupMessage,
                      style:
                          TextStyle(color: _emaildupMessageColor, fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(height: 24.0),
                _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: _obscureText,
                  onChanged: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        _passwordMessage = '    Please check your password';
                        _passwordMessageColor = Color(0xfff74440);
                      } else if (value.length < 8 || value.length > 16) {
                        _passwordMessage =
                            '    Password must be 8-16 characters';
                        _passwordMessageColor = Color(0xfff74440);
                      } else if (!RegExp(
                              r'^(?=.*?[0-9])(?=.*?[!@#$%^&*()_\-+=]).*$')
                          .hasMatch(value)) {
                        _passwordMessage =
                            '    Password must contain a number, special character';
                        _passwordMessageColor = Color(0xfff74440);
                      } else {
                        _passwordMessage = '    Password is valid';
                        _passwordMessageColor = _successMessageColor;
                      }
                    });
                  },
                ),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    SizedBox(width: 8.0),
                    if (_passwordMessageColor == _successMessageColor)
                      SvgPicture.asset('assets/check_circle.svg',
                          width: 16, height: 16),
                    if (_passwordMessageColor == Color(0xfff74440))
                      SvgPicture.asset('assets/check_circle2.svg',
                          width: 16, height: 16),
                    Text(
                      _passwordMessage,
                      style:
                          TextStyle(color: _passwordMessageColor, fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(height: 24.0),
                _buildTextField(
                  controller: _passwordConfirmController,
                  label: 'Confirm Password',
                  obscureText: _obscureText,
                  onChanged: (value) {
                    setState(() {
                      if (value.isEmpty) {
                        _passwordConfirmMessage =
                            '    Please check your password again';
                        _passwordConfirmMessageColor = Color(0xfff74440);
                      } else if (value != _passwordController.text) {
                        _passwordConfirmMessage = '    Passwords do not match';
                        _passwordConfirmMessageColor = Color(0xfff74440);
                      } else {
                        _passwordConfirmMessage = '    Successfully confirmed';
                        _passwordConfirmMessageColor = _successMessageColor;
                      }
                    });
                  },
                ),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    SizedBox(width: 8.0),
                    if (_passwordConfirmMessageColor == _successMessageColor)
                      SvgPicture.asset('assets/check_circle.svg',
                          width: 16, height: 16),
                    if (_passwordConfirmMessageColor == Color(0xfff74440))
                      SvgPicture.asset('assets/check_circle2.svg',
                          width: 16, height: 16),
                    Text(
                      _passwordConfirmMessage,
                      style: TextStyle(
                          color: _passwordConfirmMessageColor, fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(height: 24.0),
                _buildNicknameField(),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    SizedBox(width: 8.0),
                    if (_nicknameMessageColor == Color(0xff0d615c))
                      SvgPicture.asset('assets/check_circle.svg',
                          width: 16, height: 16),
                    if (_nicknameMessageColor == Colors.red)
                      SvgPicture.asset('assets/check_circle2.svg',
                          width: 16, height: 16),
                    Text(
                      _nicknameMessage,
                      style:
                          TextStyle(color: _nicknameMessageColor, fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                _buildAgreements(),
                SizedBox(height: 100.0),
                ElevatedButton(
                  onPressed: (_isFormValid &&
                          _ischeckValid &&
                          (_emailMessage == '    Email is valid') &&
                          (_passwordMessage == '    Password is valid') &&
                          (_passwordConfirmMessage ==
                              '    Successfully confirmed') &&
                          (_nicknameMessage == '    Nickname is available') &&
                          (_emaildupMessage == '    Email is available'))
                      ? _signUp
                      : null,
                  child: Text('Sign up',
                      style: TextStyle(color: Colors.white, fontSize: 16.0)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(352, 45),
                    backgroundColor: (_isFormValid && _ischeckValid)
                        ? const Color(0xFF1dbe92)
                        : Colors.grey,
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    textStyle: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pretendard',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required void Function(String) onChanged,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFECF0F2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildNicknameField() {
    return TextFormField(
      controller: _nicknameController,
      decoration: InputDecoration(
        labelText: 'Please create your nickname',
        labelStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFECF0F2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide.none,
        ),
        suffixIcon: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: _nicknameController.text.isEmpty
                ? Colors.grey
                : Color(0xff1dbe92),
          ),
          onPressed: _nicknameController.text.isEmpty ? null : _checkNickname,
          child: Text(
            'Check',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
      onChanged: (value) {
        if (value.isEmpty) {
          setState(() {
            _nicknameMessage = '';
          });
        }
        setState(() {
          _isFormValid = _nicknameController.text.isNotEmpty;
        });
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(color: Colors.grey),
        filled: true,
        fillColor: const Color(0xFFECF0F2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.0),
          borderSide: BorderSide.none,
        ),
        suffixIcon: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                _emailController.text.isEmpty ? Colors.grey : Color(0xff1dbe92),
          ),
          onPressed: _emailController.text.isEmpty ? null : _checkEmail,
          child: Text(
            'Check',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
      ),
      onChanged: (value) {
        final regex = RegExp(_emailPattern);
        setState(() {
          if (value.isEmpty || !regex.hasMatch(value)) {
            _emailMessage = '    Please check your email';
            _emailMessageColor = Color(0xfff74440);
          } else {
            _emailMessage = '    Email is valid';
            _emailMessageColor = _successMessageColor;
          }
        });

        if (value.isEmpty) {
          setState(() {
            _emaildupMessage = '';
          });
        }

        // 이메일이 비어있지 않으면 중복 체크 활성화
        setState(() {
          _isEmailValid = value.isNotEmpty && regex.hasMatch(value);
        });
      },
    );
  }

  Widget _buildAgreements() {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              value: _isAgreed,
              onChanged: (value) {
                setState(() {
                  _isAgreed = value!;

                  _validatecheck();
                });
              },
              activeColor: Color(0xff0d615c),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Privacy()));
              },
              child: Text(
                'Agree to Privacy Policy',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pretendard',
                  decoration: TextDecoration.underline,
                  color: Color(0xff0d615c),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Checkbox(
              value: _isPrivacyAgreed,
              onChanged: (value) {
                setState(() {
                  _isPrivacyAgreed = value!;

                  _validatecheck();
                });
              },
              activeColor: Color(0xff0d615c),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => TermsOfUse()));
              },
              child: Text(
                'Agree to Terms of Use',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pretendard',
                  decoration: TextDecoration.underline,
                  color: Color(0xff0d615c),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                elevation: 0,
                padding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _checkNickname() async {
    setState(() {
      isLoading = true;
    });

    var response = await http.get(
      Uri.parse(
          _url + '/api/users/validate/nickname/${_nicknameController.text}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        if (response.body == 'false') {
          _isNicknameValid = true;
          isLoading = false;
          _nicknameMessage = "    Nickname is available";
          _nicknameMessageColor = Color(0xff0d615c);
        } else {
          _isNicknameValid = false;
          isLoading = false;
          _nicknameMessage = "    This nickname is already taken";
          _nicknameMessageColor = Colors.red;
        }
      });
    } else {
      setState(() {
        isLoading = false;
        _nicknameMessage = "    Error occurred. Please try again.";
        _nicknameMessageColor = Colors.red;
      });
    }
  }

  Future<void> _checkEmail() async {
    setState(() {
      isLoading = true;
    });

    var response = await http.get(
      Uri.parse(_url + '/api/users/validate/email/${_emailController.text}'),
    ); // 수정

    if (response.statusCode == 200) {
      setState(() {
        if (response.body == "false") {
          _isEmailValid = true;
          isLoading = false;
          _emaildupMessage = "    Email is available";
          _emaildupMessageColor = Color(0xff0d615c);
        } else {
          _isEmailValid = false;
          isLoading = false;
          _emaildupMessage = "    This email is already taken";
          _emaildupMessageColor = Color(0xfff74440);
        }
      });
    } else {
      setState(() {
        isLoading = false;
        _emaildupMessage = "    Error occurred. Please try again.";
        _emaildupMessageColor = Color(0xfff74440);
      });
    }
  }

  Future<void> _signUp() async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate() && _isAgreed && _isPrivacyAgreed) {
      try {
        // Firebase로부터 인증 객체 가져오기
        FirebaseAuth auth = FirebaseAuth.instance;

        // UserCredential에서 user 객체를 가져와야 함
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        User? user = userCredential.user;

        if (user != null) {
          String userId = user!.uid;

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('uid', userId); // UID를 SharedPreferences에 저장
          prefs.setString('loginMethod', user.email!);

          // 서버로 UID 전송
          var response = await http.post(
            Uri.parse(_url + '/api/users/register'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({
              "email": _emailController.text,
              "userid": userId, // 서버에 UID 전송
              "password": _passwordController.text,
              "nickname": _nicknameController.text,
              "termsOfServiceAccepted": _isAgreed,
              "privacyPolicyAccepted": _isPrivacyAgreed,
              "grade": {
                "level": 1,
                "experience": 0,
              }
            }),
          );

          if (response.statusCode == 200) {
            setState(() {
              isLoading = false;
            });
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => QuestionScreen(uid: userId)));
          } else {
            setState(() {
              isLoading = false;
              _errorText = "Failed to Sign up. Please try again.";
            });
          }
        } else {
          setState(() {
            isLoading = false;
            _errorText = "No UID found. Please log in first.";
          });
        }
      } catch (e) {
        setState(() {
          isLoading = false;
          _errorText = "Error occurred. Please try again.";
        });
      }
    } else {
      setState(() {
        isLoading = false;
        _errorText = "Please agree to the terms and privacy policy.";
      });
    }
    setState(() {
      isLoading = false;
    });
  }
}
