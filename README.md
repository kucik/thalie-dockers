# NWN Docker Setup

## 1) Prepare secrets
Create local secret files from examples:

```sh
cp secrets/mysql.env.example secrets/mysql.env
cp secrets/nwn.env.example secrets/nwn.env
cp secrets/nwnx2.ini.example secrets/nwnx2.ini
```

Edit the copied files and fill real values.

## 2) Place game content
Put runtime assets into matching folders under `nwn/`:

- module file -> `nwn/modules/`
- hak files -> `nwn/hak/`
- tlk files -> `nwn/tlk/`
- erf files if needed -> `nwn/erf/`
- localvault data -> `nwn/localvault/`

## 3) Container roles
- `nwnx-build`: build-only container, used to compile NWNX libraries.
- `nwn`: runtime container, used to run the game server.

## 4) Typical commands

```sh
# Build compile container and compile NWNX libs
docker compose build nwnx-build
docker compose run --rm nwnx-build

# Build/start runtime stack
docker compose build nwn
docker compose up -d mysql nwn
```
