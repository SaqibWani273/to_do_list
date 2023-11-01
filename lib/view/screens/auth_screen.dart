import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list/model/device_data.dart';
import 'package:to_do_list/utility/auth.dart';
import 'package:to_do_list/view_model/auth_provider.dart';

import '../widgets/show_country_code.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  late DeviceData deviceData;
  late final SharedPreferences prefs;
  @override
  void initState() {
    initsharedPref();

    super.initState();
  }

  Future<void> initsharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    deviceData = DeviceData(context: context);
    deviceData.setAllFields();
    final authVariablesMap = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Colors.black,
        title: const Text('Authentication'),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: deviceData.height,
          //  color: Colors.white,
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  //image
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.only(top: 50),
                      //     height: deviceData.height! * 0.3,
                      width: deviceData.width! * 0.8,
                      alignment: Alignment.topCenter,
                      child: Image.asset(
                        "assets/images/splash_img.png",
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: SizedBox(
                      // height: deviceData.height*0.,
                      child: Column(
                        children: [
                          // phone textfield
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
                          //password textfield
                          if (authVariablesMap[AuthScreenVariables.otpSent])
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextFormField(
                                controller: _otpController,
                                obscureText: true,
                                validator: (value) {
                                  if (value == null ||
                                      value.trim().length != 6 ||
                                      int.tryParse(value) == null) {
                                    return 'enter valid 6-digit code';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'OTP',
                                  prefixIcon: Icon(Icons.lock),
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter 6-digit code',
                                  alignLabelWithHint: false,
                                  fillColor: Colors.black,
                                ),
                              ),
                            ),

                          //submit button
                          Container(
                            padding: const EdgeInsets.all(16.0),
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: authVariablesMap[
                                      AuthScreenVariables.isverifying]
                                  ? null
                                  : () {
                                      submitForm(
                                        authVariablesMap: authVariablesMap,
                                        formKey: _formKey,
                                        ref: ref,
                                        context: context,
                                        phoneNumber:
                                            _phoneController.text.trim(),
                                        otp: _otpController.text.trim(),
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                  disabledBackgroundColor: Colors.lightBlue),
                              child: authVariablesMap[
                                      AuthScreenVariables.isverifying]
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Center(
                                        child:
                                            CircularProgressIndicator.adaptive(
                                          strokeWidth: 2.0,
                                          backgroundColor: Colors.amber,
                                        ),
                                      ),
                                    )
                                  : Text(authVariablesMap[
                                          AuthScreenVariables.otpSent]
                                      ? 'Login'
                                      : 'Get OTP'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
