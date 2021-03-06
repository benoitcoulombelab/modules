help([[
For detailed instructions, go to:
    https://maxquant.net

This module sets the following environment variables:
    MAXQUANT: directory containing MaxQuant programs and bash scripts

This module loads the following modules and their requirements:
    - mono/5.16.0.179
    - singularity/3.8
    - maxquant-tools/1.0
]])

whatis("Version: 1.6.6.0")
whatis("Keywords: MaxQuant, Utility")
whatis("URL: https://maxquant.net")
whatis("Description: MaxQuant is a quantitative proteomics software package designed for analyzing large mass-spectrometric data sets.")

prereq("StdEnv/2018.3")
depends_on("gcc/7.3.0")
depends_on("mono/5.16.0.179")
depends_on("singularity/3.8")
depends_on("python/3.7.4")
depends_on("maxquant-tools/1.0")

local module_path = myFileName()
local module_name = myModuleFullName()
local module_base = module_path:sub(1,module_path:find(module_name,1,true)-2)
local apps_base = module_base:gsub("(.*)/(.*)","%1")
local home = pathJoin(apps_base, module_name)
setenv("MAXQUANT", home)
setenv("MAXQUANT_BASE", home)  -- For compatibility with maxquant-tools
setenv("MAXQUANT_VERSION", myModuleVersion())
