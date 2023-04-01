_G.P = function(v)
	print(vim.inspect(v))
	return v
end

_G._ = {}
function _.TableConcat(t1, t2)
	for i = 1, #t2 do
		t1[#t1 + 1] = t2[i]
	end
	return t1
end
