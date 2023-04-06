_G.__P = function(v)
	return vim.pretty_print(v)
end

_G._ = {}
function _.TableConcat(t1, t2)
	for i = 1, #t2 do
		t1[#t1 + 1] = t2[i]
	end
	return t1
end
