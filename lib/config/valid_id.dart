enum ValidID {
  driverLicense(value: 'Driver\'s License'),
  umid(value: 'UMID'),
  passport(value: 'Passport'),
  tin(value: 'TIN'),
  prc(value: 'PRC'),
  none(value: 'none');

  const ValidID({required this.value});
  final String value;
}
