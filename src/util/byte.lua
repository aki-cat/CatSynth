local Byte = {}

function Byte.bytesToHex(byteArray)
    local s = {}

    for i, byte in ipairs(byteArray) do
        s[i] = Byte.byteToHex(byte)
    end

    return table.concat(s, " ")
end

function Byte.byteToHex(byte)
    return string.format("%02X", byte)
end

return Byte

