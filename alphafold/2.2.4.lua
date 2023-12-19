help([[
For detailed instructions, go to:
    https://docs.alliancecan.ca/wiki/AlphaFold
    or
    https://github.com/deepmind/alphafold
]])

whatis("Version: 2.2.4")
whatis("URL: https://github.com/deepmind/alphafold")
whatis("Description: Highly accurate protein structure prediction.")

prereq("gcc/9.3.0")
prereq("openmpi/4.0.3")
prereq("cuda/11.4")
prereq("cudnn/8.2.0")
prereq("kalign/2.03")
prereq("hmmer/3.2.1")
prereq("openmm-alphafold/7.5.1")
prereq("hh-suite/3.3.0")

local module_path = myFileName()
local module_name = myModuleFullName()
local module_base = module_path:sub(1,module_path:find(module_name,1,true)-2)
local apps_base = module_base:gsub("(.*)/(.*)","%1")
local home = pathJoin(apps_base, module_name)
prepend_path("PATH", pathJoin(home, "venv/bin"))
setenv("ALPHAFOLD", home)
setenv("ALPHAFOLD_VERSION", myModuleVersion())
setenv("ALPHAFOLD_DATADIR", "/cvmfs/bio.data.computecanada.ca/content/databases/Core/alphafold2_dbs/2023_07")
setenv("ALPHAFOLD_PDB_MMCIF", pathJoin(apps_base, myModuleName(), "data/pdb_mmcif"))
