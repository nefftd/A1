DEVICE_TYPE = "A1";
SERIAL_NUMBER = "AAAAAAAA";

SSID = "";
PASSWORD = "";
API_TOKEN = "";
DEVICE_ID = "";

dofile'settings'.read_settings_from_fs();
dofile'ap'.start_ap();
