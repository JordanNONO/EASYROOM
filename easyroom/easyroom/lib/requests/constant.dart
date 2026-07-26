// TODO: this LAN IP only works on the same Wi-Fi as the dev machine, and http://
// (not https://) sends the login password and JWT unencrypted. Point this at the
// deployed backend's https:// URL before testing on a real phone off this network.
//String API_URL = "https://easyroom-2nq7.onrender.com";
String API_URL = "http://192.168.1.83:4500";
String BASE_URL = "$API_URL/api/v1";
