return function(yes, no, cond)
	if type(cond) == "function" then
		return cond() and yes or no
	end
	return cond and yes or no
end
