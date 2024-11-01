enum RoutPath {
  login(path: "/login"),

  home(path: "/home"),

  search(path: "/search"),
  map(path: "map"),
  vendor(path: "vendor"),

  route(path: "/route"),

  inbox(path: "/inbox"),
  chat(path: "/chat"),

  account(path: "/account"),

  profile(path: "/profile"),

  settings(path: "/settings"),

  manage(path: "/manage"),
  detail(path: "detail"),
  locationPicker(path: "locationPicker"),
  editLocation(path: "editLocation"),
  addService(path: "addService"),
  editService(path: "editService"),

  verifyAccount(path: "/verifyAccount"),
  vendorApplication(path: "/vendorApplication"),

  information(path: "/information"),
  report(path: "/report");

  const RoutPath({required this.path});
  final String path;
}
