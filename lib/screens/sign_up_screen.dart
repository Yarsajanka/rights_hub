import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum VerificationMethod { email, phone }

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  VerificationMethod _verificationMethod = VerificationMethod.email;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _smsCodeController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  String? _errorMessage;

  String? _verificationId;

  void _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      if (_verificationMethod == VerificationMethod.email) {
        // Email verification flow
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        await userCredential.user?.sendEmailVerification();

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Verification Email Sent'),
            content: Text('Please check your email to verify your account.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  Navigator.of(context).pop(); // Return to login screen
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        // Phone verification flow
        await _auth.verifyPhoneNumber(
          phoneNumber: _phoneController.text.trim(),
          verificationCompleted: (PhoneAuthCredential credential) async {
            // Auto-retrieval or instant verification
            await _auth.signInWithCredential(credential);
            _showSuccessAndReturn();
          },
          verificationFailed: (FirebaseAuthException e) {
            setState(() {
              _errorMessage = e.message;
              _isLoading = false;
            });
          },
          codeSent: (String verificationId, int? resendToken) {
            setState(() {
              _verificationId = verificationId;
              _isLoading = false;
            });
            _showSmsCodeDialog();
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            _verificationId = verificationId;
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
        _isLoading = false;
      });
    }
  }

  void _showSmsCodeDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Enter SMS Code'),
          content: TextField(
            controller: _smsCodeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'SMS Code',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final code = _smsCodeController.text.trim();
                if (code.isNotEmpty && _verificationId != null) {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: _verificationId!,
                    smsCode: code,
                  );
                  try {
                    await _auth.signInWithCredential(credential);
                    Navigator.of(context).pop(); // Close dialog
                    _showSuccessAndReturn();
                  } catch (e) {
                    setState(() {
                      _errorMessage = 'Invalid code. Please try again.';
                    });
                  }
                }
              },
              child: Text('Verify'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessAndReturn() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text('Account created and phone number verified.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Return to login screen
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  String? _validatePasswordMatch(String? value) {
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/sharp_logo.png',
                    height: 100,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio<VerificationMethod>(
                        value: VerificationMethod.email,
                        groupValue: _verificationMethod,
                        onChanged: (VerificationMethod? value) {
                          setState(() {
                            _verificationMethod = value!;
                          });
                        },
                      ),
                      Text('Email Verification'),
                      SizedBox(width: 20),
                      Radio<VerificationMethod>(
                        value: VerificationMethod.phone,
                        groupValue: _verificationMethod,
                        onChanged: (VerificationMethod? value) {
                          setState(() {
                            _verificationMethod = value!;
                          });
                        },
                      ),
                      Text('Phone Verification'),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter username' : null,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter name' : null,
                  ),
                  SizedBox(height: 20),
                  if (_verificationMethod == VerificationMethod.email)
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter email';
                        }
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Enter valid email';
                        }
                        return null;
                      },
                    ),
                  if (_verificationMethod == VerificationMethod.phone)
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Enter phone number' : null,
                    ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Enter password' : null,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
                    ),
                    validator: _validatePasswordMatch,
                  ),
                  SizedBox(height: 20),
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  SizedBox(height: 20),
                  _isLoading
                      ? CircularProgressIndicator()
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _signUp,
                            child: Text('Sign Up'),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
