local args = {...}

local function getReceiverLog()
	local _, id, data = os.pullEvent('receiver_log')

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
end

local function timeout()
	os.sleep(2)
end

if #args < 2 then
	print('Usage: sendc <id> <command> ...')
else
	local data = {
		command=args[2]
	}

	if #args > 2 then
		data.args = {unpack(args, 3)}
	end

	rednet.send(tonumber(args[1]), data, 'command_handler')
	parallel.waitForAny(getReceiverLog, timeout)
end