# Immich

- make required directory
```sh
mkdir ~/podman/immich/{ml,database}
mkdir ${UPLOAD_LOCATION}
```

- copy and modify env.example to .env
- change the URL for machine learning container in settings

## Note
I have moved the postgres and valkey on host, to have unified Database engine for all the apps and to ease backup of Databases.

So, I have moved the immich_db.container and immich_valkey.container to .bak files, to not picked up by systemd.


## Major Problem
- none
