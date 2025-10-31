local args = {...}
if #args ~= 2 then
	print('Usage: text <id> <message>')
else
	print('Sending "' .. args[2] .. '" to ' .. args[1])
	rednet.send(tonumber(args[1]), args[2], 'command_handler')
end
