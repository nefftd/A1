local http = {}

function http.get_settings_from_request(payload)
	print("Called get setting from request with payload: ", payload);
    local t = {};
    for set in payload:gmatch("[^&]+") do
        t[set:match("^(.-)=")] = set:match("=(.+)$");
    end 
    return t;
end

function http.start_http_server()
    local srv = net.createServer(net.TCP);
    srv:listen(80, function(conn)
        conn:on("receive", function(conn, payload)
        	print("Receiving");
            if (payload:find("GET / ")) then
                conn:send("<h1>Status: "..DEVICE_STATUS.."</h1>");
            elseif (payload:find("POST / ")) then
                for k, v in pairs(http.get_settings_from_request(payload:match(".+[\r\n](.-)$"))) do 
                    if (k == "SSID") then
                        SSID = v;
                        print("Set SSID to ", SSID);
                    elseif (k == "PASSWORD") then
                        PASSWORD = v;
                        print("Set password to ", PASSWORD);
                    elseif (k == "API_TOKEN") then
                        API_TOKEN = v;
                        print("Set API token to ", API_TOKEN);
                    elseif (k == "DEVICE_ID") then
                        DEVICE_ID = v;
                        print("Set device id to ", DEVICE_ID);
                    end
                end
                dofile'settings'.write_settings_to_fs();
                conn:send("HTTP/1.1 200 OK\n<h1>OK</h1>");
                srv:close();
            end
        end)
        conn:on("sent", function(conn) conn:close() end);
    end);
	print("Started HTTP server.");
	if (SSID:match("^%s*$") ~= nil) then
		--SSID is not set, we have to wait for the config
		DEVICE_STATUS = "Waiting for configuration.";
		print("Waiting for configuration");
    elseif DEVICE_STATUS == "Failed to connect to WiFi" then
        print("Waiting for configuration");
	else
		tmr.alarm(0, 120000, 0, function() 
            print("Stopping server");
            srv:close();
            dofile'a1'.connect_to_wifi();
        end);
	end
end

return http;	
