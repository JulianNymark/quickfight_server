server = {}

function server.init( arg )
    state = "running"
	require "setup"
	
	port = 56789
	-- create a TCP socket and bind it to the local host, at any port
	server = assert(socket.bind("*", port))
	-- find out which port the OS chose for us
	ip, port = server:getsockname()
	
	-- player location
	locX = 100
	locY = 100

	-- set fps values
	fps = 60
	fps_max = 1/60
end

function server.update( dt )
    print("server running!")
end

function server.quit()
    print("server exit")
end

-- init, start thread for prompt & server update()
server.init( arg )

-- run prompt
while state == "running" do
    --io.write(string.format("> "))
    --input = io.read()
    --print(input)

	-- wait for a connection from any client
	print("wait for connection on port: " .. port)
	local client = server:accept()
	-- make sure we don't block waiting for this client's line
	--client:settimeout(10)
	
	local line = ""
	while line ~= "exit" do
		-- fps timer start
		local fps_start = socket.gettime()
		
		-- receive the line
		print("receive()")
		local line, err = client:receive()
		print("received: " .. line)
		local l = split(line, ",")
		local time = socket.gettime()*1000
		--locX = l[1] + 10 * math.cos(time/100)
		--locY = l[2] + 10 * math.sin(time/100)
		locX = l[1] + 100 * math.cos(time/1000)
		locY = l[2] + 100 * math.sin(time/1000)
		
		print("send()")
		client:send("".. locX .. ",".. locY .."\n")

		local fps_stop = socket.gettime()
		local frame_time = fps_stop - fps_start
		
		-- sleep extra time...
		if (frame_time < fps_max) then
			sleeptime = fps_max - frame_time
			sleep(sleeptime)
		end

		local fps_stop = socket.gettime()
		local frame_time = fps_stop - fps_start
		print("frame_time: ".. frame_time)
		print("FPS: ".. 1/frame_time)
	end
	
	-- done with client, close the object
	client:close()
    
    -- exit
    if line == "exit" or line == "quit" then
		state = "stopping"
    end
end

