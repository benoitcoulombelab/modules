help([[
For detailed instructions, go to:
    https://github.com/benoitcoulombelab/maxquant-tools
]])

whatis("Version: 0.1")
whatis("Keywords: MaxQuant, Utility")
whatis("URL: https://github.com/benoitcoulombelab/maxquant-tools")
whatis("Description: Utilities to run MaxQuant on Compute Canada server.")

prereq(atleast("python","3.5.4"))

local module_path = myFileName()
local module_name = myModuleFullName()
local module_base = module_path:sub(1,module_path:find(module_name,1,true)-2)
local apps_base = module_base:gsub("(.*)/(.*)","%1")
local home = pathJoin(apps_base, module_name)
prepend_path("PATH", pathJoin(home, "bash"))
prepend_path("PATH", pathJoin(home, "venv/bin"))
setenv("MAXQUANT_TOOLS", home)
setenv("MAXQUANT_TOOLS_VERSION", myModuleVersion())
