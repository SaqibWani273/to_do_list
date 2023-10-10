import 'package:country_picker/country_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:developer' as dev;

Country initialCountry = Country(
  phoneCode: '+91',
  countryCode: 'IN',
  e164Sc: 1,
  geographic: false,
  level: 1,
  name: 'India',
  example: '9797012345',
  displayName: '',
  displayNameNoCountryCode: '',
  e164Key: '',
);

class CountryNotifier extends StateNotifier<Country> {
  CountryNotifier() : super(initialCountry);
  // void changeCountry(Country userCountry) {
  //   state = userCountry;
  // }
  set changeCountry(Country userCountry) {
    state = userCountry;
  }
}

final countryProvider =
    StateNotifierProvider<CountryNotifier, Country>((ref) => CountryNotifier());
