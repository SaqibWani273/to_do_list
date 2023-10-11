import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/model/device_data.dart';
import 'package:to_do_list/utility/auth.dart';
import 'package:to_do_list/view_model/auth_provider.dart';
import 'package:to_do_list/view_model/country_provider.dart';

import '../widgets/show_country_code.dart';

class AuthScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  late DeviceData deviceData;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    deviceData = DeviceData(context: context);
    deviceData.setAllFields();
    final authVariablesMap = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: deviceData.height,
          color: Colors.white,
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //image
                  Container(
                    // padding: EdgeInsets.only(top: 20),
                    height: deviceData.height! * 0.3,
                    width: deviceData.width! * 0.8,
                    alignment: Alignment.topCenter,
                    child: Image.asset(
                      'assets/images/img_for_auth_screen1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  //textfield
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null ||
                            value.trim().length != 10 ||
                            int.tryParse(value) == null) {
                          return 'enter valid 10-digit number';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Phone number',
                        prefixIcon: ShowCountryCode(),

                        border: OutlineInputBorder(),
                        hintText: 'Enter 10-digit phone number',
                        alignLabelWithHint: false,
                        // errorText: 'Please enter a valid phone number',
                        fillColor: Colors.black,
                      ),
                    ),
                  ),
                  //submit button
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!authVariablesMap[
                            AuthScreenVariables.isverifying]) {
                          if (_formKey.currentState != null) {
                            if (_formKey.currentState!.validate()) {
                              ref
                                  .read(authProvider.notifier)
                                  .toggleIsVerifying();
                              final countryCode =
                                  ref.watch(countryProvider).phoneCode;
                              registerUser(
                                  "$countryCode${_phoneController.text.trim()}",
                                  context);
                            }
                          }
                        }
                      },
                      child: authVariablesMap[AuthScreenVariables.isverifying]
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: Center(
                                child: CircularProgressIndicator.adaptive(
                                  strokeWidth: 2.0,
                                  backgroundColor: Colors.amber,
                                ),
                              ),
                            )
                          : Text(
                              authVariablesMap[AuthScreenVariables.isRegistered]
                                  ? 'Login'
                                  : 'Register'),
                    ),
                  ),
                  SizedBox(
                    height: deviceData.height! * 0.1,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(authVariablesMap[AuthScreenVariables.isRegistered]
                            ? 'New user?'
                            : 'Already a user?'),
                        TextButton(
                            onPressed: () {
                              ref
                                  .read(authProvider.notifier)
                                  .toggleIsRegistered();
                            },
                            child: Text(authVariablesMap[
                                    AuthScreenVariables.isRegistered]
                                ? 'Register Here'
                                : 'Login here'))
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
