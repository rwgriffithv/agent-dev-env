# TODO

* fix `scripts/setup-host.sh`
  * needs to be idempotent
  * needs to make sure ollama is started with systemctl

* symlink own `.devcontainer/` subdirectories to parent repo `.devcontainer/` directory?
  * make sure that when building the devcontainer the .env file is sourced properly
