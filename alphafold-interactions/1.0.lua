help([[
For detailed instructions, go to:
    https://github.com/benoitcoulombelab/alphafold-interactions

This module sets the following environment variables:
    ALPHAFOLD_INTERACTIONS:  directory containing alphafold-interactions
]])

whatis("Version: 1.0")
whatis("URL: https://github.com/benoitcoulombelab/alphafold-interactions")
whatis("Description: This software tries to guess which proteins interact with a protein of interest using AlphaFold multimer")

local module_path = myFileName()
local module_name = myModuleFullName()
local module_base = module_path:sub(1,module_path:find(module_name,1,true)-2)
local apps_base = module_base:gsub("(.*)/(.*)","%1")
local home = pathJoin(apps_base, module_name)
prepend_path("PATH", pathJoin(home, "venv/bin"))
setenv("ALPHAFOLD_INTERACTIONS", home)
setenv("ALPHAFOLD_INTERACTIONS_VERSION", myModuleVersion())
