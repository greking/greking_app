import 'dart:convert'; // JSON 인코딩을 위해 필요
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_app/loading.dart';
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences 추가
import 'package:http/http.dart' as http; // HTTP 요청을 위해 추가
import 'signup.dart';
import 'question.dart';
import 'main.dart'; // 로그인 성공 후 메인 화면으로 이동하기 위해 추가

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false; // 로딩 상태를 저장할 변수
  String _errorText = ""; // 오류 메시지를 저장할 변수
  final _formKey = GlobalKey<FormState>(); // 폼 키
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true; // 비밀번호 숨김 여부

  final String _emailPattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'; // 이메일 정규식

  // 이메일/비밀번호 로그인 (Spring Boot API)
  Future<void> _signInWithEmail() async {
    if (_formKey.currentState!.validate()) {
      try {
        String email = _emailController.text;
        String password = _passwordController.text;
        isLoading = true; // 로딩 상태 변경
        // API 요청 보내기
        var response = await http.post(
          Uri.parse('http://localhost:8080/api/users/login'), // 서버 URL
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            'email': email,
            'password': password,
            'uid': 'some-unique-id', // Firebase UID가 없을 경우 고유 식별자 생성 필요
          }),
        );

        if (response.statusCode == 200) {
          var responseData = jsonDecode(response.body);
          isLoading = false; // 로딩 상태 변경
          // 로그인 성공 시 로그인 상태 저장
          await _saveLoginState('email', responseData['uid'], email, '');

          // 메인 페이지로 이동
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(),
            ),
          );
        } else {
          setState(() {
            isLoading = false; // 로딩 상태 변경
            _errorText = "Failed to Sign in. Please check your ID or Password.";
          });
        }
      } catch (e) {
        setState(() {
          isLoading = false; // 로딩 상태 변경
          _errorText = "error occurred. Please try again.";
        });
      }
    }
  }

  // 로그인 상태를 SharedPreferences에 저장
  Future<void> _saveLoginState(
      String method, String uid, String email, String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('loginMethod', method);
    await prefs.setString('token', uid);
    await prefs.setString('email', email);
    if (name.isNotEmpty) {
      await prefs.setString('name', name);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading == true) {
      return LoadingScreen();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Container(),
          backgroundColor: Colors.white.withOpacity(0.0), // 투명도 설정된 상단바 배경색
          bottomOpacity: 0.0,
          elevation: 0.0,
          scrolledUnderElevation: 0,
          shape: const Border(
            bottom: BorderSide(
              color: Colors.transparent,
              width: 0.0,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: const Color(0xFFF4F6F7), // 배경색 설정

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // 여백 설정
            child: Form(
              key: _formKey, // 폼 키 지정
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // 세로 방향으로 가운데 정렬
                crossAxisAlignment: CrossAxisAlignment.stretch, // 가로 방향으로 꽉 채움
                children: <Widget>[
                  SizedBox(height: 30.0), // 공간 추가
                  Text(
                    'Welcome Please\nSign in', // 제목 텍스트
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  SizedBox(height: 40.0), // 공간 추가
                  Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Please enter your email',
                      labelStyle: TextStyle(
                        color: Colors.grey, // Set the text color to blue
                      ),
                      hintText: ' ',
                      filled: true,
                      fillColor: const Color(0xFFECF0F2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      final regex = RegExp(_emailPattern);
                      if (!regex.hasMatch(value)) {
                        return 'Please check your ID or Password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 24.0),
                  Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Pretendard',
                    ),
                  ),
                  SizedBox(height: 8.0),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                        labelText: 'Please enter your password',
                        labelStyle: TextStyle(
                          color: Colors.grey, // Set the text color to blue
                        ),
                        hintText: ' ',
                        filled: true,
                        fillColor: const Color(0xFFECF0F2),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        )),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 8 || value.length > 16) {
                        return 'Please check your ID or Password';
                      }
                      if (!RegExp(r'^(?=.*?[0-9])(?=.*?[!@#$%^&*()_\-+=]).*$')
                          .hasMatch(value)) {
                        return 'Please check your ID or Password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.0),
                  if (_errorText.isNotEmpty)
                    Text(
                      _errorText,
                      style: TextStyle(color: const Color(0xFFFF74440)),
                    ),
                  SizedBox(height: 100.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Signup()),
                          );
                        },
                        child: Text('Sign up',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 14.0)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QuestionScreen()),
                          );
                        },
                        child: Text('Find password',
                            style:
                                TextStyle(color: Colors.grey, fontSize: 14.0)),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),

                  ElevatedButton(
                    onPressed: _signInWithEmail, // 이메일/비밀번호 로그인 버튼
                    child: Text('Sign In',
                        style: TextStyle(color: Colors.white, fontSize: 20.0)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 70),
                      backgroundColor: const Color(0xFF1dbe92),
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      textStyle: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Pretendard',
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
