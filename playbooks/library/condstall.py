#!/usr/bin/python
# ^ this uses the ansible python
# Copyright: (c) 2018, Terry Jones <terry.jones@example.org>
# GNU General Public License v3.0+ (see COPYING or https://www.gnu.org/licenses/gpl-3.0.txt)
import os
import pathlib
from abc import ABC, abstractmethod

from ansible.module_utils.basic import AnsibleModule

__metaclass__ = type

DOCUMENTATION = r"""
---
module: condstall

short_description: Install/upgrade packages using conda

version_added: "1.0.0"

description: 
    - Uses specialized conda environments for building and installing packages.
    - Currently supports conda, rust, and go.

options:
    package:
        description: Full package name and options to pass to the installer.
        required: true
        type: str
    binary:
        description: Name of the resulting binary.
        required: false
        type: str
    installer:
        description: 
            - Name of the package installer.
        required: true
        type: str
        choices: 
            - conda
            - rust
            - go
    target:
        description: 
            - Conda environment's bin directory to target for installation.
            - Specify 'global' to install to the default binary path for that installer.
        default: global
        type: str
    state:
        description: Indicates the desired state of the package.
        type: str
        default: installed
        choices:
            - installed

author:
    - bryce (@brycekbargar)
"""

EXAMPLES = r"""
# install using rust globally
- name: Install delta
  condstall:
    package: "git-delta --locked"
    binary: "delta"
    installer: "rust"
    state: "latest"

# install using go to an environment
- name: Install fzf
  condstall:
    package: "junegunn/fzf@latest"
    binary: "fzf"
    installer: "go"
    target: "sample"
    state: "latest"
"""

RETURN = r"""
# These are examples of possible return values, and in general should use other names for return values.
installed_package:
    description: The original name of the package that was passed in.
    type: str
    returned: always
    sample: 'fd-find'
used_installer:
    description: The original name of the installer that was passed in.
    type: str
    returned: always
    sample: 'rust'
installed_binary_version:
    description: The --version message of the installed binary.
    type: str
    returned: success
    sample: 'fd 8.3.2'
"""


class Installer(ABC):
    def __init__(self, target: str):
        super().__init__()
        self.target = target

    @abstractmethod
    def install_cmd(self, package: str) -> list[str]:
        ...

    def install_env(self, target_prefix: pathlib.Path) -> dict:
        return dict()

    @abstractmethod
    def updated(self, stdout: str) -> bool:
        ...

    @abstractmethod
    def global_bin_path(self, binary: str) -> pathlib.Path:
        ...

    @staticmethod
    def _conda_run(env_name: str) -> list[str]:
        return [
            "conda",
            "run",
            "--name",
            env_name,
            "--no-capture-output",
        ]


class CondaInstaller(Installer):
    def __init__(self, target: str):
        if target == "global":
            target = "installers-conda"
        super(CondaInstaller, self).__init__(target)

    def install_cmd(self, package: str) -> list[str]:
        return ["conda", "install", "--name", self.target, "--yes", package]

    def updated(self, stdout: str) -> bool:
        return "packages will be" in stdout

    def global_bin_path(self, binary: str) -> pathlib.Path:
        raise Exception("conda global path is an environment")


class RustInstaller(Installer):
    def install_cmd(self, package: str) -> list[str]:
        return self._conda_run("installers-rust") + [
            "cargo",
            "install",
            package,
            "--locked",
        ]

    def install_env(self, target_prefix: pathlib.Path) -> dict:
        if self.target == "global":
            return dict()
        return dict(CARGO_INSTALL_ROOT=target_prefix)

    def updated(self, stdout: str) -> bool:
        return "Installing" in stdout

    def global_bin_path(self, binary: str) -> pathlib.Path:
        return pathlib.Path(os.environ["CARGO_HOME"]).joinpath("bin", binary)


class GoInstaller(Installer):
    def install_cmd(self, package: str) -> list[str]:
        return self._conda_run("installers-go") + [
            "go",
            "install",
            package,
        ]

    def install_env(self, target_prefix: pathlib.Path) -> dict:
        if self.target == "global":
            return dict()
        return dict(GOBIN=target_prefix.joinpath("bin"))

    def updated(self, stdout: str) -> bool:
        return len(stdout) > 0

    def global_bin_path(self, binary: str) -> pathlib.Path:
        return pathlib.Path(os.environ["GOPATH"]).joinpath("bin", binary)


def main():
    module = AnsibleModule(
        argument_spec=dict(
            package=dict(type="str", required=True),
            binary=dict(type="str", required=False),
            installer=dict(type="str", required=True),
            target=dict(type="str", required=False, default="global"),
            state=dict(type="str", required=False, default="present"),
        )
    )

    if module.check_mode:
        raise Exception("check mode not supported")

    if not isinstance(module.params, dict):
        raise Exception(f"module.params is a {type(module.params)=}")

    result = dict(
        changed=False,
        used_installer="",
        installed_package="",
        installed_binary_version="",
    )

    result["used_installer"] = install_type = module.params["installer"]
    result["installed_package"] = package = module.params["package"]
    target = module.params["target"]
    binary = module.params["binary"]
    if binary is None or len(binary) == 0:
        binary = package

    match install_type:
        case "conda":
            installer = CondaInstaller(target)
        case "rust":
            installer = RustInstaller(target)
        case "go":
            installer = GoInstaller(target)
        case err:
            raise Exception(f"unexpected installer {err}")

    try:
        install_cmd = installer.install_cmd(package)

        (_, prefix, _) = module.run_command(
            """conda env list | awk '$1=="""
            + f'"{installer.target}"'
            + """{print($2=="*" ? $3 : $2)}'""",
            check_rc=True,
            use_unsafe_shell=True,
        )
        target_prefix = pathlib.Path(prefix.strip())
        env = installer.install_env(target_prefix)
        (_, installed, _) = module.run_command(
            install_cmd, check_rc=True, environ_update=env
        )
        result["changed"] = installer.updated(installed)

        bin_path = (
            installer.global_bin_path(binary)
            if installer.target == "global"
            else target_prefix.joinpath("bin", binary)
        )
        (_, version, _) = module.run_command(
            [bin_path, "--version"],
            check_rc=True,
        )
        result["installed_binary_version"] = version.strip()
    except BaseException as err:
        module.fail_json(f"{type(err)=}: {err=}", **result)

    module.exit_json(**result)


if __name__ == "__main__":
    main()
