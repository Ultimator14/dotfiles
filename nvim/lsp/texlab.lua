--[
-- Language: LaTeX
-- Server: texlab
-- dev-tex/texlab
--]
return {
  -- defined in lspconfig.lua
  --on_attach = on_attach_texlab,
  settings = {
    texlab = {
      chktex = {
        onOpenAndSave = true    -- run chktex on save
      }
    }
  }
}
