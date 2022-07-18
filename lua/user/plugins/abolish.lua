return {
	"https://github.com/tpope/vim-abolish",
	event = "BufRead",
	config = function()
		vim.cmd([[
Abolish ret{run,unr}    return
Abolish delte{,e}       delete{}
Abolish funciton{,ed,s} function{}
Abolish seconde{,s}     second{,s}
Abolish relatvie        relative
Abolish haeder          header
Abolish realted         related
Abolish withouth without
Abolish reponsive responsive
Abolish cosnt const
    ]])
	end,
}
