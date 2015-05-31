local ap = {}

function ap.start_ap()
    wifi.setmode(wifi.SOFTAP);
    wifi.ap.config({ssid = DEVICE_TYPE.."-"..SERIAL_NUMBER, pwd="(FAVEGA)"});
    DEVICE_STATUS = "Started AP.";
    dofile'http'.start_http_server();
end

return ap;
