return {
  "https://github.com/glacambre/firenvim",
  run = function() vim.fn['firenvim#install'](0) end,
  config = function()
    vim.g.firenvim_config = {
      globalSettings = {
        alt = "all"
      },
      localSettings = {
        [".*"] = {
          cmdline = "neovim",
          content = "text",
          priority = 0,
          selector = "textarea",
          takeover = "once"
        }
      }
    }
  end
}
