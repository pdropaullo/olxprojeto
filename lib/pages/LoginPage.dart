import 'package:flutter/material.dart';
import 'package:olxprojeto/pages/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController emailCadastroController = TextEditingController();
  TextEditingController passwordCadastroController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Login'),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Senha'),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () async {
                  String email = emailController.text;
                  String password = passwordController.text;

                  User? user =
                      await signInWithEmailAndPassword(email, password);

                  if (user != null) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => HomePage(),
                      ),
                    );
                  } else {}
                },
                child: Text('Entrar'),
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () {
                  _showRegistrationDialog(context);
                },
                child: Text(
                  'Criar conta',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRegistrationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Cadastro'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                // TextField(
                //   decoration: InputDecoration(labelText: 'Nome'),
                // ),
                TextField(
                  decoration: InputDecoration(labelText: 'Email'),
                  controller: emailCadastroController,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Senha'),
                  controller: passwordCadastroController,
                ),
                // TextField(
                //   decoration: InputDecoration(labelText: 'Confirme a senha'),
                // ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                String emailCadastro = emailCadastroController.text;
                String passwordCadastro = passwordCadastroController.text;

                await signUpWithEmailAndPassword(
                    emailCadastro, passwordCadastro);

                // You can navigate to another page upon successful registration.
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => LoginPage(),
                  ),
                );
              },
              child: Text('Cadastrar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}

Future<User?> signInWithEmailAndPassword(String email, String password) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  } catch (e) {
    print('Error signing in: $e');
    return null;
  }
}

Future<void> signUpWithEmailAndPassword(
    String emailCadastro, String passwordCadastro) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailCadastro, password: passwordCadastro);
    // You can do additional user setup here if needed
    print('User registered: ${userCredential.user?.email}');
  } catch (e) {
    print('Error registering user: $e');
    // Handle the registration error, e.g., display an error message.
  }
}
