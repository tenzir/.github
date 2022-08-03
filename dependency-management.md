# Dependency Management

When introducing a new dependency or updating an existing one, please consider
the following tasks:

## CMake

Determine whether the dependency is a public, private, or interface depdency or
existing targets.

## Nix

Update the Nix environment to link against the proper dependency.

## Docker

Update `Dockerfile` to reflect the dependency changes.

## CI

Update the dependencies in GitHub Actions workflow files, including the Jupyter
Notebook workflow.
