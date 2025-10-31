local monitor = peripheral.find("monitor")
if monitor then
	term.redirect(monitor)
end

print('Receiver started')

while true do
	local id, data = rednet.receive('command_handler', 1000)

	if type(data) == 'string' then
		io.write('<' .. id .. '> ' .. data)
		if data:sub(#data, #data) ~= '\n' then
			io.write('\n')
		end

	elseif type(data) == 'number' then
		print('<' .. id .. '> ' .. data)

	elseif type(data) == 'table' then
		if data.type == nil then
			printError('Received table from ' .. id .. ', but data.type is nil')

		elseif data.type == 'log' then
			if data.isError then
				local originalTextColor = term.getTextColor()
				term.setTextColor(colours.red)

				io.write('<' .. id .. '> ' .. data.text)
				term.setTextColor(originalTextColor)

			else
				io.write('<' .. id .. '> ' .. data.text)
			end

			if data.text:sub(#data.text, #data.text) ~= '\n' then
				io.write('\n')
			end

		else
			printError('Received unknown data type from ' .. id)
		end
	end

	os.queueEvent('receiver_log', id, data)
end