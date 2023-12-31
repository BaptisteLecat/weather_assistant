import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weatherjourney/src/constants/app_sizes.dart';
import 'package:weatherjourney/src/features/authentication/presentation/controller/auth_controller.dart';
import 'package:weatherjourney/src/routing/app_router.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      authControllerProvider,
      (_, state) => state.maybeWhen(
        error: (error, _) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(error.toString()),
          ),
        ),
        orElse: () {},
      ),
    );
    final state = ref.watch(authControllerProvider);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Sizes.p24, vertical: Sizes.p48),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(top: Sizes.p24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Create a new account",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).primaryColor,
                                  )),
                          const SizedBox(height: Sizes.p12),
                          Text(
                              "Create an account so you can watch beautiful generated landscapes",
                              style: Theme.of(context).textTheme.titleMedium)
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Form(
                        key: _formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                children: [
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      hintText: "Email",
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: Sizes.p20),
                              TextFormField(
                                controller: _passwordController,
                                decoration: const InputDecoration(
                                  hintText: "Password",
                                ),
                              ),
                              const SizedBox(height: Sizes.p20),
                              const Spacer(),
                              GestureDetector(
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    FocusScopeNode currentFocus =
                                        FocusScope.of(context);
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                    ref
                                        .read(authControllerProvider.notifier)
                                        .signUpWithEmail(
                                            email: _emailController.text,
                                            password: _passwordController.text);
                                  }
                                },
                                child: Container(
                                    height: 54,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: Sizes.p12),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                    child: Center(
                                        child: (!state.isLoading)
                                            ? Text("Create account",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge!
                                                    .copyWith(
                                                        color: Colors.white))
                                            : const CircularProgressIndicator())),
                              ),
                              const SizedBox(height: Sizes.p16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                      onTap: () =>
                                          context.goNamed(AppRoute.signIn.name),
                                      child: RichText(
                                          text: TextSpan(
                                              text:
                                                  "Already have an account ? ",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall,
                                              children: [
                                            TextSpan(
                                                text: "Sign in",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall!
                                                    .copyWith(
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold))
                                          ]))),
                                ],
                              )
                            ])),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: GestureDetector(
                                    onTap: () =>
                                        context.goNamed(AppRoute.signIn.name),
                                    child: RichText(
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        text: TextSpan(
                                            text:
                                                "By signing up, you agree to Weather Journey's\n",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall,
                                            children: [
                                              TextSpan(
                                                  text: "Terms of Service",
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () => launchUrl(
                                                        Uri.https(
                                                            "weatherjourney.webflow.io",
                                                            "terms-of-use")),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                              const TextSpan(text: " and "),
                                              TextSpan(
                                                  text: "Privacy Policy",
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () => launchUrl(Uri.https(
                                                        "weatherjourney.webflow.io",
                                                        "confidentiality-rules")),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                          color:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            ]))),
                              ),
                            ],
                          ),
                        ]),
                  )
                ])));
  }
}
