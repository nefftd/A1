local temp_probe = {}

local address = nil
local pin = 1

function temp_probe.find_temperature_probe()
  ow.setup(pin)
  count = 0
  repeat
    count = count + 1
    addr = ow.reset_search(pin)
    addr = ow.search(pin)
    tmr.wdclr()
  until((addr ~= nil) or (count > 100))

  if (addr == nil) then
    print("FATAL ERROR: No more addresses.")
  else
    address = addr
  end
end

function temp_probe.get_temperature()
  if (address == nil) then
    temp_probe.find_temperature_probe()
  end
  crc = ow.crc8(string.sub(address,1,7))
  if (crc == address:byte(8)) then
    if ((address:byte(1) == 0x10) or (address:byte(1) == 0x28)) then
      ow.reset(pin)
      ow.select(pin, address)
      ow.write(pin, 0x44, 1)
      tmr.delay(1000000)
      present = ow.reset(pin)
      ow.select(pin, address)
      ow.write(pin,0xBE,1)
      data = string.char(ow.read(pin))
      for i = 1, 8 do
        data = data .. string.char(ow.read(pin))
      end
      print(data:byte(1) .. ":" .. data:byte(2))
      crc = ow.crc8(string.sub(data,1,8))
      if (crc == data:byte(9)) then
        temp = (data:byte(2) * 256 + (data:byte(1))) * 0.0625
        if (data:byte(2) > 31) then
                 temp = -(255 - bit.rshift(bit.band((data:byte(2) * 256 + data:byte(1)), 2040), 3)) * 0.0625
        end
        return temp
      end                   
      tmr.wdclr()
    else
    print("Device family is not recognized.")
  end
  else
    print("CRC is not valid!")
  end
  return "Error"
end

return temp_probe;