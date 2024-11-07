import 'dart:convert';

String prettyJSON(jsonObject) {
  const encoder = JsonEncoder.withIndent('    ');
  return encoder.convert(jsonObject);
}
