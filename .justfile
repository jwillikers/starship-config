default: install

alias f := format
alias fmt := format

format:
    just --fmt --unstable

install:
    #!/usr/bin/env bash
    set -euxo pipefail
    curl --location https://copr.fedorainfracloud.org/coprs/atim/starship/repo/fedora/atim-starship-fedora.repo \
        | sudo tee /etc/yum.repos.d/atim-starship-fedora.repo
    distro=$(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release)
    if [ "$distro" = "fedora" ]; then
        variant=$(awk -F= '$1=="VARIANT_ID" { print $2 ;}' /etc/os-release)
        if [ "$variant" = "toolbx" ]; then
            sudo dnf --assumeyes install starship
        elif [ "$variant" = "iot" ] || [[ "$variant" = *-atomic ]]; then
            sudo rpm-ostree install --idempotent starship
            echo "Reboot to finish installation."
        fi
    fi
    mkdir --parents "{{ config_directory() }}"
    ln --force --relative --symbolic starship.toml "{{ config_directory() }}/starship.toml"
