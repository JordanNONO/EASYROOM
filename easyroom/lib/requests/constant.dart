// Single source of truth for the backend location: change this value only,
// never hardcode a URL/IP anywhere else in the app.
// NOTE: this is a plain http:// local-network address (only reachable from a
// phone on the same Wi-Fi as the dev machine). It is not usable once the app
// is off that network, and even when a real host is used, iOS blocks
// cleartext http by default (App Transport Security) unless an exception is
// added in ios/Runner/Info.plist. The production value MUST be an https://
// URL once the backend is actually deployed.
String API_URL = "http://172.20.10.2:4500";
String BASE_URL = "$API_URL/api/v1";