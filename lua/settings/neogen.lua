local neogen = require('neogen')

neogen.setup({
  enable = true,
  languages = {
    python = {
      template = {
        annotation_convention = "google_docstrings"
      }
    }
  }
})
