return function()
	local safe_require = require("nebula.helpers.require").safe_require
	local mason = safe_require("mason")

	if not mason then
		return
	end

	mason.setup()
end
