local a1 = {}
local wifi_conn_timeout_counter = 0;

function a1.connect_to_wifi()
    print("Connecting to WiFi...");
    wifi.setmode(wifi.STATION);
    wifi.sta.config(SSID, PASSWORD);
    wifi.sta.connect();
    tmr.alarm(1, 1000, 1, function()
        if wifi.sta.getip() == "0.0.0.0" or wifi.sta.getip() == nil then
        	if wifi_conn_timeout_counter < 30 then
            	print("Not yet connected, waiting...");
            	wifi_conn_timeout_counter = wifi_conn_timeout_counter + 1;
           	else
           		print("Can not connect to WiFi.");
           		status = "Failed to connect to WiFi";
           		local ap = require 'ap';
				      ap.start_ap();
				      ap = nil;
           		tmr.stop(1);
           	end
        else
            tmr.stop(1);
            print("Connected. IP: ", wifi.sta.getip());
            tmr.alarm(1, 10000, 1, function()
              print("Temperature", require 'temp_probe'.get_temperature(), "C.");
            end)
        end
    end)
end

return a1;