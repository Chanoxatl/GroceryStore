import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // big logo
            Padding(
              padding: const EdgeInsets.only(
                left: 100.0,
                right: 100.0,
                top: 120,
                bottom: 20,
              ),
              child: Image.asset('lib/images/grocery.png'),
            ),

            // we deliver groceries at your doorstep
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Text(
                'Grocery App',
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSerif(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // groceree gives you fresh vegetables and fruits
            Text(
              'Quality items',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),

            const SizedBox(height: 24),

            const Spacer(),

            // get started button
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ShopDialog();
                  },
                );
              },
              child: Material(
                borderRadius: BorderRadius.circular(16),
                color: const Color.fromARGB(255, 112, 91, 222),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: const Text(
                    "Shop",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // register button
            InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return RegisterDialog();
                  },
                );
              },
              child: Material(
                borderRadius: BorderRadius.circular(16),
                color: Colors.blue,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: const Text(
                    "Register",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class RegisterDialog extends StatefulWidget {
  const RegisterDialog({Key? key}) : super(key: key);

  @override
  _RegisterDialogState createState() => _RegisterDialogState();
}

class _RegisterDialogState extends State<RegisterDialog> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  void _registerUser() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (password == confirmPassword) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        // Registration successful. You can now store additional user data if needed.
        // For example, you can store the 'name' in the user's profile or Firestore database.

        // After successfully registering the user, navigate to the HomePage
        Navigator.pop(context); // Close the dialog
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return HomePage();
            },
          ),
        );
      } catch (e) {
        // Handle registration errors (e.g., email already exists).
        // You can display an error message or handle it as per your app's requirements.
        print("Error occurred during registration: $e");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Registration Failed"),
              content: Text("An error occurred during registration. Please try again."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK"),
                ),
              ],
            );
          },
        );
      }
    } else {
      // Password and Confirm Password do not match. Show an error message.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Invalid Input"),
            content: Text("Password and Confirm Password do not match. Please try again."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Register"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Name",
            ),
          ),
          SizedBox(height: 12),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: "Email",
            ),
          ),
          SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password",
            ),
          ),
          SizedBox(height: 12),
          TextField(
            controller: _confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Confirm Password",
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            _registerUser(); // Call the registration function when the "Register" button in the dialog is pressed.
          },
          child: Text("Register"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
      ],
    );
  }
}

class ShopDialog extends StatefulWidget {
  const ShopDialog({Key? key}) : super(key: key);

  @override
  _ShopDialogState createState() => _ShopDialogState();
}

class _ShopDialogState extends State<ShopDialog> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _shopUser() async {
    String email = _emailController.text;
    String password = _passwordController.text;

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      // Login successful. You can now perform any necessary actions after the user is logged in.

      // After successful login, navigate to the HomePage
      Navigator.pop(context); // Close the dialog
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) {
            return HomePage();
          },
        ),
      );
    } catch (e) {
      // Handle login errors (e.g., invalid credentials).
      // You can display an error message or handle it as per your app's requirements.
      print("Error occurred during login: $e");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Login Failed"),
            content: Text("Invalid credentials. Please try again."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Login"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: "Email",
            ),
          ),
          SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password",
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            _shopUser(); // Call the shop function when the "Shop" button in the dialog is pressed.
          },
          child: Text("Login"),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: IntroScreen(),
  ));
}
