function toBits(num,bits)
    -- returns a table of bits, most significant first.
    bits = bits or math.max(1, select(2, math.frexp(num)))
    local t = {} -- will contain the bits        
    for b = bits, 1, -1 do
        t[b] = math.fmod(num, 2)
        num = math.floor((num - t[b]) / 2)
    end
    return table.concat(t)
end

function string:split(sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

function replaceStr(table,len)
	temp = {}
	str = ""
	nm = 1
	t = ""
	for i=1, #table do
		str = str .. table[i]
	end
	-- print(str)
	-- print(#str)
	for i=1, #table/len do
		t = string.sub(str, nm,len*i)
		-- t = string.sub(str,nm, len*i)
		-- t = string.format("%x",string.sub(str,nm, len*i))
		-- print (string.len(t))
		print(string.format("%x",tonumber(t,2)))
		temp[i] = string.format("%x",tonumber(t,2))
		nm = (len * i) + 1
	end
	return temp
end

function addZeros(str,len)
	for i=1, len - string.len(str) do
		str = "0" .. str
	end
	return str
end


function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function readMapFile(fileName, layers)
	-- contents = love.filesystem.read(fileName,all):split(",")
	contents = string.gsub(string.gsub(love.filesystem.read(fileName,all), "\n", "")," ","")
	contents = contents:split(",")
	fileSize = #contents
	fString = ""
	bit = ""
	mapW = (fileSize/layers) * 8
 	for i=1, fileSize do
 		bit = toBits(tonumber(contents[i],16))
 		bit = addZeros(bit,8)
 		fString = fString .. bit
 	end	
	m = {}

	for i=1, layers do 
		m[i] = {}
		for j=1, mapW do 
			m[i][j] =  string.sub( fString, ((i-1) * mapW) + j,((i-1) * mapW) + j)
		end
	end
	return m
end
-- generate Map file assumes your inputting a 2d array so no layer is required
function genMapFile(map,name)
	local m = deepcopy(map)
	fileData = ""
	t =""
	for i=1, #m do
		m[i] = replaceStr(m[i],8)
		for j=1, #m[i] do
			t= tostring(m[i][j])
			fileData = fileData .."0x".. addZeros(t,2) .. ","
		end 
	end	
	
	fileData = string.sub(fileData,1,string.len(fileData) - 1)
	print(string.len(fileData))	
	path = love.filesystem.getSource() .. "/" .. name
	file = io.open(path, "w")
	file:write(fileData)
	file:close()
	print("File made")

end
