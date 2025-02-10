enum RoutePath {
  login(path: "/login"),

  search(path: "/search"),
  map(path: "map"),

  viewService(path: "/viewService"),

  vendorPage(path: "/vendorPage"),

  route(path: "/route"),

  inbox(path: "/inbox"),
  chat(path: "/chat"),

  saves(path: "/saves"),

  notifications(path: "/notifications"),

  account(path: "/account"),

  transactions(path: "/transactions"),

  profile(path: "/profile"),

  settings(path: "/settings"),

  manage(path: "/manage"),
  locationPicker(path: "locationPicker"),
  editLocation(path: "editLocation"),
  addService(path: "addService"),

  verifyAccount(path: "/verifyAccount"),
  vendorApplication(path: "/vendorApplication"),

  information(path: "/information"),
  reportIssue(path: "/reportIssue");

  const RoutePath({required this.path});
  final String path;
}
