local function input_then_exec(cmd)
	vim.ui.input({
		prompt = "Arguments, " .. cmd,
	}, function(input)
		if input then
			if input.length > 0 then
				vim.api.nvim_command(cmd .. input)
			else
				vim.api.nvim_command(cmd)
			end
		end
	end)
end

return {
	input_then_exec = input_then_exec,
}
