# Opencloud
- Run this when you are setting this up for first time
```
podman run --rm -it \
    -v $HOME/podman/opencloud:/etc/opencloud \
    -v $HOME/opencloud:/var/lib/opencloud \
    -e IDM_ADMIN_PASSWORD=admin \
    opencloudeu/opencloud-rolling:latest init
```



## Major Problem
- None, documentation is lacking some important parts and all the resources are put into docker compose instruction and if you want to do manual compose you are on your own 
