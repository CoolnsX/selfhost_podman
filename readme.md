# SelfHost using Podman

- make the symlink of the folder you want to use as services to ~/.config/containers/systemd/
    - for e.g. you want to use nextcloud, then do this --
        ```sh
            ln -sf /path/to/this/project/nextcloud ~/.config/containers/systemd/
        ```
    - This will make the nextcloud available in ~/.config/containers/systemd/
        ```txt
            ❯ tree ~/.config/containers/systemd
            .config/containers/systemd
            └── nextcloud -> /home/<user>/<project_dir>/nextcloud
        ```
