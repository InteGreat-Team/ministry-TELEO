import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../sign-up/frontend/screens/USER_SIGNUP_1.dart' as signup;
import '../../../login/frontend/screens/SHARED_LOGIN.dart';
import '../../backend/models/SHARED_STARTSCREEN_VAR.dart';
import '../../backend/viewmodels/SHARED_STARTSCREEN_FUNC.dart';

class SHARED_STARTSCREEN extends StatefulWidget {
  const SHARED_STARTSCREEN({Key? key}) : super(key: key);

  @override
  State<SHARED_STARTSCREEN> createState() => _SHARED_STARTSCREENState();
}

class _SHARED_STARTSCREENState extends State<SHARED_STARTSCREEN> {
  final SharedStartScreenVariables _vars = SharedStartScreenVariables();
  final SharedStartScreenFunctions _functions = SharedStartScreenFunctions();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                'assets/images/teleo_logo.png',
                height: 120,
              ),
              const SizedBox(height: 24),
              const Text(
                'TELEO',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF002642),
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Connecting Churches, Empowering Ministry',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4A4A4A),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SHARED_LOGIN(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF002642),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const signup.USER_SIGNUP_1(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF002642), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Create a new account',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF002642),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
