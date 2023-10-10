import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/view_model/auth_provider.dart';
import 'package:to_do_list/view_model/country_provider.dart';
import 'dart:developer' as dev;

class ShowCountryCode extends ConsumerWidget {
  const ShowCountryCode({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final country = ref.watch(countryProvider);
    dev.log(country.geographic.toString());

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Add some padding to the text to make it look more balanced.
        Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 8.0),
          child: Text(
            country.flagEmoji,
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        // Increase the font size of the phone code slightly.
        Text(
          country.phoneCode,
          style: TextStyle(fontSize: 18.0),
        ),
        // Add some padding to the text button to make it look more tappable.
        TextButton(
          onPressed: () => showCountryPicker(
            context: context,
            showPhoneCode: true,
            onSelect: (Country newCountry) {
              ref.read(countryProvider.notifier).changeCountry = newCountry;
              print('Select country: ${country.displayName}');
            },
          ),
          child: Icon(Icons.arrow_drop_down),
        ),
      ],
    );
  }
}
