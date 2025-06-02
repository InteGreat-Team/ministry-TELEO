import 'package:flutter/material.dart';

class CountryCode {
  final String name;
  final String code;
  final String dialCode;
  
  const CountryCode({
    required this.name,
    required this.code,
    required this.dialCode,
  });
}

class CountryCodePicker extends StatefulWidget {
  final Function(CountryCode) onChanged;
  final CountryCode initialSelection;
  
  const CountryCodePicker({
    super.key,
    required this.onChanged,
    required this.initialSelection,
  });

  @override
  State<CountryCodePicker> createState() => _CountryCodePickerState();
}

class _CountryCodePickerState extends State<CountryCodePicker> {
  late CountryCode _selectedCountry;
  
  // Sample list of countries - in a real app, this would be more comprehensive
  final List<CountryCode> _countries = const [
    CountryCode(name: 'Philippines', code: 'PH', dialCode: '+63'),
    CountryCode(name: 'United States', code: 'US', dialCode: '+1'),
    CountryCode(name: 'United Kingdom', code: 'GB', dialCode: '+44'),
    CountryCode(name: 'Australia', code: 'AU', dialCode: '+61'),
    CountryCode(name: 'Canada', code: 'CA', dialCode: '+1'),
    CountryCode(name: 'China', code: 'CN', dialCode: '+86'),
    CountryCode(name: 'India', code: 'IN', dialCode: '+91'),
    CountryCode(name: 'Japan', code: 'JP', dialCode: '+81'),
    CountryCode(name: 'Singapore', code: 'SG', dialCode: '+65'),
    CountryCode(name: 'South Korea', code: 'KR', dialCode: '+82'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.initialSelection;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _showCountryPicker,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedCountry.dialCode,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey.shade700,
            ),
          ],
        ),
      ),
    );
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Text(
                'Select Country Code',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _countries.length,
                itemBuilder: (context, index) {
                  final country = _countries[index];
                  return ListTile(
                    title: Text(country.name),
                    trailing: Text(
                      country.dialCode,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _selectedCountry = country;
                      });
                      widget.onChanged(country);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}