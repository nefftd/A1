local ap = {}

function ap.start_ap()
    wifi.setmode(wifi.SOFTAP);
    wifi.ap.config({ssid = DEVICE_TYPE.."-"..SERIAL_NUMBER, pwd="(FAVEGA)"});
    cfg = nil;
    status = "Started AP.";
    require 'http'.start_http_server();
    package.loaded['http'] = nil;
end

return ap;