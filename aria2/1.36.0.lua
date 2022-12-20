help([[
For detailed instructions, go to:
    https://aria2.github.io
    or
    https://github.com/aria2/aria2
]])

whatis("Version: 1.36.0")
whatis("URL: https://github.com/aria2/aria2")
whatis("Description: aria2 is a lightweight multi-protocol & multi-source command-line download utility.")

prereq("StdEnv/2020")

local module_path = myFileName()
local module_name = myModuleFullName()
local module_base = module_path:sub(1,module_path:find(module_name,1,true)-2)
local apps_base = module_base:gsub("(.*)/(.*)","%1")
local home = pathJoin(apps_base, module_name)
prepend_path("PATH", pathJoin(home, "bin"))
prepend_path("MANPATH", pathJoin(home, "doc/man"))
setenv("ARIA2", home)
setenv("ARIA2_VERSION", myModuleVersion())
