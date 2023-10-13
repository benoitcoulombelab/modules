help([[
This module was renamed to 'pairs' and will be removed from the system on January 19 2024.
]])

whatis("Version: 1.0")
whatis("URL: https://github.com/benoitcoulombelab/alphafold-pairs")
whatis("Description: This software tries to guess which proteins interact with a protein of interest using AlphaFold multimer")

local module_path = myFileName()
local module_name = myModuleFullName()
local module_base = module_path:sub(1,module_path:find(module_name,1,true)-2)
local apps_base = module_base:gsub("(.*)/(.*)","%1")
local home = pathJoin(apps_base, module_name)
prepend_path("PATH", pathJoin(home, "venv/bin"))
setenv("ALPHAFOLD_PAIRS", home)
setenv("ALPHAFOLD_PAIRS_VERSION", myModuleVersion())
LmodMessage("This module was renamed to 'pairs' and will be removed from the system on January 19 2024.\n")
