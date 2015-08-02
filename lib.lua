return function(...)
	-- if tonumber(box.info.version:match("%d+%.%d+")) >= 1.6 then
	-- else
	-- 	error("lib required adaptation for 1.5",2)
	-- end
	local allow_relative = false
	local file = debug.getinfo(2).short_src
	local base
	if file and string.sub(file,1,1) == '/' then
		allow_relative = true
		base = string.gsub(file,"[^%/]+$","")
	else
		if type(box.cfg) == 'function' then
		else
			allow_relative = true
			base = box.cfg.work_dir
		end
	end
	if base and string.sub(base,-1,-1) ~= '/' then
		base = base .. '/'
	end
	-- print("lib base = ",base, " allow: ",allow_relative)
	local phash = {}
	local chash = {}
	for str in string.gmatch(package.path,'([^;]+)') do
		if string.sub(str,-5,-1) == '?.lua' then
			local dir = string.sub(str,1,-6)
			phash[dir] = true
		end
		-- print(str)
	end
	for str in string.gmatch(package.cpath,'([^;]+)') do
		if string.sub(str,-4,-1) == '?.so' then
			local dir = string.sub(str,1,-5)
			chash[dir] = true
		end
		-- print(str)
	end

	for i = 1,select('#',...) do
		local path = select(i,...)
		if string.sub(path,1,1) == '/' then
			-- print("Absolute path")
		else
			if not allow_relative then error("Can't set relative lib before initial box.cfg",2) end
			-- print("Relative path")
			path = base .. path
		end
		--- TODO: more correct sanitizing
		local count = 0
		repeat
			path, count = string.gsub( path, "/%./","/" )
		until count == 0
		repeat
			path, count = string.gsub( path, "/[^%/]+/%.%./","/" )
		until count == 0
		repeat
			path, count = string.gsub( path, "//+","/" )
		until count == 0
		if string.sub(path,-1,-1) ~= '/' then
			path = path .. '/'
		end
		print("resulting: ",path)
		if not phash[path] then
			package.path = package.path ..
				';'..path..'?.lua'..
				';'..path..'?/init.lua'
		end
		if not chash[path] then
			package.cpath = package.cpath ..
				';'..path..'?.so'
		end
	end
end
