help([[
For detailed instructions, go to:
    https://maxquant.net

This module sets the following environment variables:
    MAXQUANT: directory containing MaxQuant programs and bash scripts

This module loads the following modules and their requirements:
    - mono/6.12.0.122
    - maxquant-tools/1.0
]])

whatis("Version: 2.1.0.0")
whatis("Keywords: MaxQuant, Utility")
whatis("URL: https://maxquant.net")
whatis("Description: MaxQuant is a quantitative proteomics software package designed for analyzing large mass-spectrometric data sets.")

prereq("StdEnv/2020")
depends_on("mono/6.12.0.122")
depends_on("python/3.8.10")
depends_on("maxquant-tools/1.0")

local module_path = myFileName()
local module_name = myModuleFullName()
local module_base = module_path:sub(1,module_path:find(module_name,1,true)-2)
local apps_base = module_base:gsub("(.*)/(.*)","%1")
local home = pathJoin(apps_base, module_name)
setenv("MAXQUANT", home)
setenv("MAXQUANT_BASE", home)  -- For compatibility with maxquant-tools
setenv("MAXQUANT_VERSION", myModuleVersion())
