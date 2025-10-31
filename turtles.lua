local turtles = {rednet.lookup("command_handler")}

io.write(#turtles .. " turtle")
if #turtles > 1 then
	io.write("s")
end

io.write(" available.\nID")

if #turtles > 1 then
	io.write("s")
end

io.write(": ")

for _, id in pairs(turtles) do
	io.write(id .. ' ')
end
io.write('\n')