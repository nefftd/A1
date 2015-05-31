local settings = {}

--Tries to retrieve settings from the file system.
function settings.read_settings_from_fs()
    if (file.open("settings", "r") == true) then
        local line = file.readline();
        while (line ~= nil) do
            local setting = settings.settings_split(line);
            if (setting[1] == "SSID") then
                SSID = setting[2];
                print("Loaded SSID from settings: ", setting[2]);
            elseif (setting[1] == "PASSWORD") then
                PASSWORD = setting[2];
                print("Loaded password from settings: ", setting[2]);
            elseif (setting[1] == "API_TOKEN") then
                API_TOKEN = setting[2];
                print("Loaded api token from settings: ", setting[2]);
            elseif (setting[1] == "DEVICE_ID") then
                DEVICE_ID = setting[2];
                print("Loaded device id from settings: ", setting[2]);
            else
                print("Unknown settings key: ", setting[1]);
            end
            line = file.readline()
        end
        file.close()
    else
        return nil;
    end
end
 
--Splits string with format key=value into key and value.
function settings.settings_split(inputstr)
    local t={} ; local i=1;
    for str in inputstr:gmatch("[^=]+") do
        t[i] = str:gsub("\n", "");
        i = i + 1;
    end
    return t;
end
 
--Writes locals to file system
function settings.write_settings_to_fs()
    print("Writing settings");
    file.open("settings", "w+");
    file.writeline("SSID="..SSID);
    file.writeline("PASSWORD="..PASSWORD);
    file.writeline("API_TOKEN="..API_TOKEN);
    file.writeline("DEVICE_ID="..DEVICE_ID);
    file.close();
    print("Settings written");
end

return settings;
