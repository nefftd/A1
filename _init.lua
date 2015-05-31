DEVICE_TYPE = "A1";
SERIAL_NUMBER = "AAAAAAAA";

SSID = "";
PASSWORD = "";
API_TOKEN = "";
DEVICE_ID = "";

local settings = require 'settings';
settings.read_settings_from_fs();
settings = nil;
package.loaded['settings'] = nil;
local ap = require 'ap';
ap.start_ap();
ap = nil;
package.loaded['ap'] = nil;