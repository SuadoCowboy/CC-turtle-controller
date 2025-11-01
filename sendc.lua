local args = {...}

local function _getReceiverLog()
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
			local originalTextColor = term.getTextColor()
			if data.color then
				term.setTextColor(data.color)
			end

			io.write('<' .. id .. '> ' .. data.text)

			if data.text:sub(#data.text, #data.text) ~= '\n' then
				io.write('\n')
			end

			term.setTextColor(originalTextColor)

		else
			printError('Received unknown data type from ' .. id)
		end
	end
end

local timeouted = false
local function timeout()
	os.sleep(2)
	timeouted = true
end

local function getReceiverLog()
	while true do
		parallel.waitForAny(_getReceiverLog, timeout)
		if timeouted then
			break
		end
	end
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
	getReceiverLog()
end