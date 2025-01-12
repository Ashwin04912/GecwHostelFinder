import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gecw_lakx/application/auth/sign_in_form/sign_in_form_bloc.dart';
import 'package:gecw_lakx/presentation/auth/sign_up_screen.dart';
import 'package:gecw_lakx/presentation/bottom_navigation/bottom_navigation_owner.dart';
import 'package:gecw_lakx/presentation/bottom_navigation/bottom_navigation_student.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SignInFormBloc, SignInFormState>(
        listener: (context, state) {
          state.signInFailureOrSuccessOption.fold(() {}, (some) {
            some.fold((f) {
              final message = f.maybeWhen(
                invalidEmailAndPasswordCombinationFailure: () =>
                    "Invalid Password or Email Combination",
                userNotFound: () => "User not found",
                emailAlreadyInUse: () => "Email already in use",
                orElse: () => "Some Error Occurred",
              );
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(message)));
            }, (s) {
              if (s == 'student') {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (ctx) =>
                            const BottomNavigationBarStudentWidget()),
                    (route) => false);
              } else {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (ctx) =>
                            const BottomNavigationBarOwnerWidget()),
                    (route) => false);
              }
            });
          });
        },
        builder: (context, state) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E1E2C), Color(0xFF23232F)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Header Section
                const Column(
                  children: [
                    Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Enter your credentials to login",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                // Input Fields Section
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Email Input Field
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Email Address",
                          hintStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.email, color: Colors.white70),
                        ),
                        onChanged: (value) => context
                            .read<SignInFormBloc>()
                            .add(SignInFormEvent.emailAddressChangedEvent(value)),
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
                            (email) => null,
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      // Password Input Field
                      TextFormField(
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.lock, color: Colors.white70),
                        ),
                        obscureText: true,
                        onChanged: (value) => context
                            .read<SignInFormBloc>()
                            .add(SignInFormEvent.passwordChangedEvent(value)),
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
                            (password) => null,
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      // Login Button
                      state.isSubmitting
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.purple,
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () {
                                context.read<SignInFormBloc>().add(
                                    SignInFormEvent
                                        .signInWithEmailAndPasswordPressed());
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const StadiumBorder(),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Colors.purple,
                              ),
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            ),
                    ],
                  ),
                ),
                // Signup Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.white70),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => const SignUpScreen(),
                        ));
                      },
                      child: const Text(
                        "Sign Up",
                        style: TextStyle(color: Colors.purple),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
