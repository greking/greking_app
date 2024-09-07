import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_app/privacy.dart';
import 'package:my_app/terms.dart';
import 'map.dart';
import 'main.dart';
import 'shop.dart';
import 'mycourse.dart';
import 'privacy.dart';
import 'terms.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class My extends StatefulWidget {
  const My({super.key});
  @override
  _MyState createState() => _MyState();
}

class _MyState extends State<My> {
  bool isLoggedIn = false;
  String? email;
  String? name;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // 로그인 상태 확인
  }

  // 로그인 상태 확인 및 SharedPreferences에서 저장된 정보 불러오기
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loginMethod = prefs.getString('loginMethod');
    String? token = prefs.getString('token');
    String? savedEmail = prefs.getString('email'); // 저장된 이메일
    String? savedName = prefs.getString('name'); // 저장된 사용자 이름

    if (loginMethod != null && token != null) {
      setState(() {
        isLoggedIn = true;
        email = savedEmail ?? '1234545@example.com'; // 이메일이 없으면 기본값
        name = savedName ?? 'Kim MinJune'; // 이름이 없으면 기본값
      });
    } else {
      setState(() {
        isLoggedIn = false;
      });
    }
  }

  // 네비게이션 클릭 전에 로그인 상태 확인 함수
  Future<bool> _checkLoginBeforeNavigate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? loginMethod = prefs.getString('loginMethod');
    String? token = prefs.getString('token');

    return (loginMethod != null && token != null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Row(
          children: [
            SizedBox(width: 16.0),
            Text(
              '  MyPage',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        leadingWidth: 200,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SvgPicture.asset('assets/mypicture.svg', width: 52, height: 52),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 로그인된 경우 이름과 이메일 표시, 로그인되지 않은 경우 "Need to sign in" 및 로그인 버튼 표시
                    isLoggedIn
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name ?? 'Kim MinJune',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                email ?? '1234545@example.com',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '  Need to sign in',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff0d615c),
                                ),
                              ),
                              SizedBox(width: 50),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                  );
                                },
                                child: Text('Login',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    )),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF1DBE92),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 20,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
                Spacer(),
              ],
            ),
            const SizedBox(height: 24),
            // 로그인 상태일 때만 레벨과 진행 상태 표시
            if (isLoggedIn)
              Row(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 20),
                      Text(
                        'Level 1',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0XFF0D615C),
                        ),
                      ),
                      Text(
                        '  1000/6000',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  SvgPicture.asset(
                    'assets/level_icon.svg',
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(width: 10),
                ],
              ),
            if (isLoggedIn)
              LinearProgressIndicator(
                value: 1000 / 6000,
                backgroundColor: Colors.grey[300],
                color: Color(0XFF1DBE92),
                minHeight: 16,
                borderRadius: BorderRadius.circular(10),
              ),
            const SizedBox(height: 24),
            Column(
              children: [
                buildMenuItem(
                  text: 'Rent reservation',
                  onTap: () {},
                ),
                SizedBox(height: 2),
                buildMenuItem(
                  text: 'App version',
                  onTap: () {},
                ),
                SizedBox(height: 2),
                buildMenuItem(
                  text: 'Notification',
                  onTap: () {},
                ),
                SizedBox(height: 20),
                buildMenuItem(
                  text: 'Terms of Use',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TermsOfUse()),
                    );
                  },
                ),
                SizedBox(height: 2),
                buildMenuItem(
                  text: 'Location Information',
                  onTap: () {},
                ),
                SizedBox(height: 2),
                buildMenuItem(
                  text: 'Privacy policy',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Privacy()),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 4,
        onTap: (index) async {
          if ((index == 2) && !await _checkLoginBeforeNavigate()) {
            // 로그인되지 않은 경우 로그인 페이지로 이동
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          } else {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainPage()),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Treking()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyCourse()),
                );
                break;
              case 3:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Shop()),
                );
                break;
              case 4:
                // Current page
                break;
            }
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/navi_home_off.svg'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/navi_second_off.svg'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/navi_third_off.svg'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/navi_four_off.svg'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/navi_five_on.svg'),
            label: '',
          ),
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget buildMenuItem({required String text, required VoidCallback onTap}) {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        color: Color(0xFFECF0F2),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                color: Color(0xFF1D2228),
                fontSize: 16,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF1D2228),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
