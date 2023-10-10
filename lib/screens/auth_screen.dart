import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/model/device_data.dart';
import 'package:to_do_list/utility/auth.dart';
import 'package:to_do_list/view_model/auth_provider.dart';

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
  bool isNewUser = true;
  void toggleUser(bool val) {
    setState(() {
      isNewUser = !val;
    });
  }

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
                      decoration: const InputDecoration(
                        labelText: 'Phone number',
                        prefixIcon: ShowCountryCode(),

                        border: OutlineInputBorder(),
                        hintText: 'Enter your phone number',
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
                          // registerUser("+919797767375", context);
                        }
                      },
                      child: authVariablesMap[AuthScreenVariables.isverifying]
                          ? CircularProgressIndicator()
                          : Text(isNewUser ? 'Register' : 'Login'),
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
                        Text(isNewUser ? 'Already a user?' : 'New user?'),
                        TextButton(
                            onPressed: () {
                              toggleUser(isNewUser);
                              ref
                                  .read(authProvider.notifier)
                                  .toggleIsRegistered(isNewUser);
                            },
                            child: Text(
                                isNewUser ? 'Login here' : 'Register Here'))
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
