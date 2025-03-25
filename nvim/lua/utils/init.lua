local M = {}

function M.file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

function M.filename()
  return vim.fn.expand("%")
end

function M.splitextension(filename)
    local name, extension = string.match(filename, "^(.+)%.([^%.]+)$")
    return name, extension
end

return M
