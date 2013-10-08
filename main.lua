server = {}

function server.init( arg )
    state = "running"
    -- require "common"
    require "socket"
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
    io.write(string.format("> "))
    input = io.read()
    print(input)
    
    -- exit
    if input == "exit" or input == "quit" then
	state = "stopping"
    end
end
