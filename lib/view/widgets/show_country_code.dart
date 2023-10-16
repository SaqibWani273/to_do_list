import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/view_model/country_provider.dart';

class ShowCountryCode extends ConsumerWidget {
  const ShowCountryCode({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final country = ref.watch(countryProvider);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Add some padding to the text to make it look more balanced.
        Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 8.0),
          child: Text(
            country.flagEmoji,
            style: const TextStyle(fontSize: 18.0),
          ),
        ),
        // Increase the font size of the phone code slightly.
        Text(
          "+${country.phoneCode}",
          style: const TextStyle(fontSize: 18.0),
        ),
        // Add some padding to the text button to make it look more tappable.
        TextButton(
          onPressed: () => showCountryPicker(
            context: context,
            showPhoneCode: true,
            onSelect: (Country newCountry) {
              ref.read(countryProvider.notifier).changeCountry = newCountry;
            },
          ),
          child: const Icon(Icons.arrow_drop_down),
        ),
      ],
    );
  }
}
