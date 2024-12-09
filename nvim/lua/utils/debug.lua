--
-- Debugging module
--

--[[

-- Usage

local dbg = require('utils.debug')
dbg.init("/home/jbreig/Downloads/lua.log")  -- create file first
dbg.log(object_to_log)  -- log object, strings are ok

--]]

local M = {}
local f = {}

function M.init(path)
  f = io.open(path, "a+")
  io.output(f)
end

function M.log(elem)
  io.write("----------------------------------------\n")
  io.write(vim.inspect(elem))
  io.write("\n")
  io.write("----------------------------------------\n")
end

function M.close()
  io.close(f)
end

return M
