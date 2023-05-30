help([[
For detailed instructions, go to:
    https://github.com/prehensilecode/alphafold_singularity
    or
    https://github.com/deepmind/alphafold
]])

whatis("Version: 2.3.2")
whatis("URL: https://github.com/deepmind/alphafold")
whatis("Description: Highly accurate protein structure prediction.")

prereq(atleast("apptainer","1.1"))

local module_path = myFileName()
local module_name = myModuleFullName()
local module_base = module_path:sub(1,module_path:find(module_name,1,true)-2)
local apps_base = module_base:gsub("(.*)/(.*)","%1")
local home = pathJoin(apps_base, module_name)
prepend_path("PATH", pathJoin(home, "venv/bin"))
setenv("ALPHAFOLD", home)
setenv("ALPHAFOLD_DIR", home)
setenv("ALPHAFOLD_VERSION", myModuleVersion())
setenv("ALPHAFOLD_CONTAINER", pathJoin(home, "alphafold.sif"))
setenv("ALPHAFOLD_DATADIR", pathJoin(home, "../data"))
setenv("ALPHAFOLD_PIP", "absl-py==1.0.0 biopython==1.79 chex==0.0.7 dm-haiku==0.0.8 dm-tree==0.1.6 docker==5.0.0 immutabledict==2.0.0 jax==0.3.22 ml-collections==0.1.0 numpy==1.21.4 pandas==1.3.0 protobuf==3.20.1 scipy==1.7.0 tensorflow==2.9.0")
