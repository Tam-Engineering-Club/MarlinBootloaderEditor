require "fileManager"
function love.load()
	scl = 6
	screenW = 16 * 8
	screenH = 64
	love.graphics.setBackgroundColor(255,255,255)
	success = love.window.setMode( screenW * scl, screenH * scl)
	map = {}
	mState = 0
    p = readMapFile("map.txt",screenH)
	for i=1, screenH do
		map[i] = {}
		for j=1, screenW do
			-- print( p[i][j])
			if p[i][j] ~= nil then
				map[i][j] = p[i][j]
			else
				map[i][j] = "0"
			end
		end
	end
	-- print (string.format("%x",12))
	-- for i=1, #map do
	-- 	for j=1, #map[i] do
	-- 		print(map[i][j])
	-- 	end
	-- end
	-- print (tonumber("0x7DE",16))
	-- t = toBits(13)
	-- for i=1, #t do 
	-- 	print(t[i])
	-- end
end

function love.mousepressed(x, y, button)
	if button == 2 then
		mState = (mState - 1) * - 1
    end
end
function love.keypressed(key)
   if key == "return" then
   		genMapFile(map,"map.txt")
   end
end
function placeTile(tileMap,mState)
	if love.mouse.isDown(1) then
		mx = math.floor((love.mouse.getX())/scl) + 1;
		my = math.floor((love.mouse.getY())/scl) + 1;
		--- if 0 erase if 1 then draw
		if mState == 0 then
			tileMap[my][mx] = "1"; -- sets the value of the block to the one in the map
		else 
			tileMap[my][mx] = "0";
		end
	end
end

function love.update(dt)
	placeTile(map,mState)
end

function love.draw()
	love.graphics.setColor(0,0,0)
	-- for i=1,screenW do 
	-- 	love.graphics.line(i*scl,0,i*scl,screenH*scl)
	-- end
	-- for i=1, screenH do
	-- 	love.graphics.line(0,i*scl,screenW*scl,i*scl)
	-- end
	for i=1, #map do
		for j=1, #map[i] do
			if map[i][j] ~= "0" then
				love.graphics.rectangle("fill", (j-1) * scl,(i-1) * scl,scl,scl)
			end 
		end
	end
	-- love.graphics.rectangle("fill",love.mouse.getX() - scl/2,love.mouse.getY() - scl/2,scl,scl)
end