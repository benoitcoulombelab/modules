help([[
For detailed instructions, go to:
    https://github.com/SlavovLab/DART-ID
]])

whatis("Version: 2.0.7")
whatis("Keywords: Single-cell Proteomics")
whatis("URL: https://github.com/SlavovLab/DART-ID")
whatis("Description: DART-ID increases single-cell proteome coverage.")

prereq(between("python","3.7.0","3.8.10"))

local module_path = myFileName()
local module_name = myModuleFullName()
local module_base = module_path:sub(1,module_path:find(module_name,1,true)-2)
local apps_base = module_base:gsub("(.*)/(.*)","%1")
local home = pathJoin(apps_base, module_name)
prepend_path("PATH", pathJoin(home, "venv/bin"))
setenv("DART_ID", home)
setenv("DART_ID_VERSION", myModuleVersion())
