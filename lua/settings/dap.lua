require('dap-python').setup('~/.virtualenvs/debugpy/bin/python')

require("dapui").setup()
require("nvim-dap-virtual-text").setup()

require('dap-go').setup {
  dap_configurations = {
    {
      type = "go",
      name = "Attach remote",
      mode = "remote",
      request = "attach",
      connect = {
        host = "127.0.0.1",
        port = "${port}"
      }
    },
  },
  delve = {
    path = "dlv",
    initialize_timeout_sec = 30,
    port = "${port}",
    args = {
      "--log",
    },
  },
}
