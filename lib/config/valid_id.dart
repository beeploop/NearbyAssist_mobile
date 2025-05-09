enum ValidID {
  philSys(value: 'PhilSys ID'),
  umid(value: 'UMID'),
  driverLicense(value: "Driver's License"),
  prc(value: 'PRC'),
  voters(value: "Voter's ID"),
  passport(value: 'Passport'),
  tin(value: 'TIN'),
  none(value: 'none');

  const ValidID({required this.value});
  final String value;
}
