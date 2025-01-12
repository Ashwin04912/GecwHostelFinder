import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gecw_lakx/application/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:gecw_lakx/presentation/auth/sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark background
      body: SingleChildScrollView(
        child: BlocConsumer<SignInFormBloc, SignInFormState>(
          listener: (context, state) {
            state.authFailureOrSuccessOption.fold(() {}, (some) {
              some.fold((f) {
                final message = f.maybeWhen(
                  noInternetConnection: () => "Check your internet connection.",
                  emailAlreadyInUse: () => "Email already in use",
                  orElse: () => "Some Error Occurred",
                );
                context.read<SignInFormBloc>().add(SignInFormEvent.resetValues());
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(message)));
              }, (s) {
                debugPrint("login success");

                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => SignInScreen()));
              });
            });
          },
          builder: (context, state) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              height: MediaQuery.of(context).size.height - 50,
              width: double.infinity,
              child: Form(
                autovalidateMode: AutovalidateMode.always,
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        const SizedBox(height: 60.0),
                        const Text(
                          "Sign up",
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // Text color for dark theme
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Create your account",
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[400]),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _emailController,
                          hintText: "Email",
                          prefixIcon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) => context
                              .read<SignInFormBloc>()
                              .add(SignInFormEvent.emailAddressChangedEvent(
                                  value)),
                          validator: (value) {
                            final emailValidation = context
                                .read<SignInFormBloc>()
                                .state
                                .emailAddress
                                .value;

                            return emailValidation.fold(
                              (failure) {
                                return failure.maybeMap(
                                  invalidEmail: (_) => 'Invalid Email',
                                  orElse: () => null,
                                );
                              },
                              (email) =>
                                  null, // If email is valid, return null.
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                            controller: _passwordController,
                            hintText: "Password",
                            prefixIcon: Icons.lock,
                            obscureText: true,
                            onChanged: (value) => context
                                .read<SignInFormBloc>()
                                .add(SignInFormEvent.passwordChangedEvent(
                                    value)),
                            validator: (value) {
                              final passwordValidation = context
                                  .read<SignInFormBloc>()
                                  .state
                                  .password
                                  .value;

                              return passwordValidation.fold(
                                (failure) {
                                  return failure.maybeMap(
                                    shortPassword: (_) => 'Short Password',
                                    orElse: () => null,
                                  );
                                },
                                (password) =>
                                    null, // If password is valid, return null.
                              );
                            }),
                        const SizedBox(height: 20),
                        _buildTextField(
                          controller: _confirmPasswordController,
                          hintText: "Confirm Password",
                          prefixIcon: Icons.lock,
                          obscureText: true,
                          onChanged: (value) => context
                              .read<SignInFormBloc>()
                              .add(SignInFormEvent.passwordChangedEvent(value)),
                          validator: (value) {
                            if (value != _passwordController.text) {
                              return "Passwords do not match";
                            } else {
                              final passwordValidation = context
                                  .read<SignInFormBloc>()
                                  .state
                                  .password
                                  .value;

                              return passwordValidation.fold(
                                (failure) {
                                  return failure.maybeMap(
                                    shortPassword: (_) => 'Short Password',
                                    orElse: () => null,
                                  );
                                },
                                (password) =>
                                    null, // If password is valid, return null.
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        DropdownButtonFormField<String>(
                          dropdownColor: Colors.black,
                          value: _selectedOption,
                          decoration: InputDecoration(
                            
                            border: OutlineInputBorder(
                              
                              borderRadius: BorderRadius.circular(18),
                            ),
                            filled: true,
                            fillColor: Colors.grey[800],
                            labelText: "Role",
                            labelStyle: TextStyle(color: Colors.white),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Hostel_Owner',
                              child: Text('Hostel Owner', style: TextStyle(color: Colors.white)),
                            ),
                            DropdownMenuItem(
                              value: 'Student',
                              child: Text('Student', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedOption = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please select a role";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    state.isSubmitting
                        ? Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              debugPrint(_selectedOption);

                              if (_formKey.currentState!.validate()) {
                                context.read<SignInFormBloc>().add(
                                    SignInFormEvent
                                        .registerWithEmailAndPasswordPressed(
                                            role: _selectedOption.toString()));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.purple,
                            ),
                            child: const Text(
                              "Sign up",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text("Already have an account?",
                            style: TextStyle(color: Colors.white)),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => const SignInScreen(),
                            ));
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Colors.purple),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    required String? Function(String?) validator,
    void Function(dynamic value)? onChanged,
  }) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400]), // Dark theme hint style
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        filled: true,
        fillColor: Colors.grey[800],
        prefixIcon: Icon(prefixIcon, color: Colors.white),
        labelText: hintText,
        labelStyle: TextStyle(color: Colors.white),
      ),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
    );
  }
}
