local _ = {}

function _.TableConcat(t1, t2)
	for i = 1, #t2 do
		t1[#t1 + 1] = t2[i]
	end
	return t1
end

function _.unrequire(m)
	package.loaded[m] = nil
	_G[m] = nil
end

function _.P(v)
	if vim.fn.has("nvim-0.9.0") then
		return vim.print(v)
	end
	return vim.pretty_print(v)
end

_G._ = _
