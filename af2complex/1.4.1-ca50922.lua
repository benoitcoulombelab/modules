help([[
For detailed instructions, go to:
    https://github.com/FreshAirTonight/af2complex
]])

whatis("Version: 1.4.1 commit ca50922")
whatis("URL: https://github.com/FreshAirTonight/af2complex")
whatis("Description: Predicting and modeling protein complexes with deep learning.")

prereq("alphafold/2.3.2")

local module_path = myFileName()
local module_name = myModuleFullName()
local module_base = module_path:sub(1,module_path:find(module_name,1,true)-2)
local apps_base = module_base:gsub("(.*)/(.*)","%1")
local home = pathJoin(apps_base, module_name)
prepend_path("PATH", pathJoin(home, "venv/bin"))
setenv("AF2COMPLEX", home)
setenv("AF2COMPLEX_VERSION", "ca50922a668d278cd92ad8adb843cd5206f8e8fc")
LmodMessage("To execute AF2Complex run: python $AF2COMPLEX/src/run_af2c_mod.py\n")
