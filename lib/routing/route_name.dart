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

  account(path: "/account"),

  transactions(path: "/transactions"),

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
  reportIssue(path: "/reportIssue");

  const RoutePath({required this.path});
  final String path;
}
