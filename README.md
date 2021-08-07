# modules

Modules for Benoit Coulombe Lab on Compute Canada servers.


* [Install](#install)
* [Configure - only step for most users](#configure)
* [Emails - to receive emails when running jobs](#emails)
* [Uninstall](#uninstall)



## Install

Clone modules repository in the projects folder.

:memo: *The examples use `def-coulomb` project*

:memo: *The examples use the `apps` folder - it is customizable*

```shell
cd ~/projects/def-coulomb
mkdir apps
cd apps
git clone https://github.com/benoitcoulombelab/modules.git
```

Install maxquant-tools.

```shell
module load maxquant-tools
~/projects/def-coulomb/apps/modules/maxquant-tools/install.sh
```

If your project is not `def-coulomb`, run the `change-project.sh` script.

:memo: *Replace `$project` with the name of your project*

```shell
~/projects/def-coulomb/apps/modules/maxquant-tools/change-project.sh $project
```


## Configure

All users that want to use modules will need to run the configuration script.

```shell
~/projects/def-coulomb/apps/modules/configure.sh
source ~/.bash_profile
```

Test if configuration worked.

```shell
module load maxquant
maxquant --help
```

### Remove configuration

If a user wants to stop using modules, he can run the configuration script with `clean` argument.

```shell
~/projects/def-coulomb/apps/modules/configure.sh clean
```


## Emails

To receive emails for jobs, run the following command:

:memo: *Replace `$email` with your email address*

```shell
email-sbatch.sh $email
```

### Stop receiving emails for jobs

To stop receiving emails for jobs, run the following command:

```shell
email-sbatch.sh clean
```


## Installing software

Most modules have an installation script called `install.sh` that allows to install the required software.

To install maxquant-tools.

```shell
module load maxquant-tools
~/projects/def-coulomb/apps/modules/maxquant-tools/install.sh
```

To install MaxQuant.

```shell
module load maxquant
~/projects/def-coulomb/apps/modules/maxquant/install.sh
```


## Uninstall

Remove the `apps` (if not customized) folder from the project folder.

:memo: *It is preferable but not required to run the configuration script with `clean` argument for all users prior to uninstallation*

:memo: *The examples use `def-coulomb` project*

:memo: *The examples use the `apps` folder - it is customizable*

```shell
cd ~/projects/def-coulomb
rm -rf apps
```
