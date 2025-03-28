# Nextcloud

The nextcloud image used is actually from linuxserver.io.

## Major Problem
- The fpm is unable to run as root i.e. you cannot do puid and pgid to 0 and call it a day, it won't work.
    - To get Around it, you have to do uidmap. Either on container level, or on pod level if doing pod (as most of us do)
        ```ini
            UIDMap=${PUID}:0:1
            UIDMap=0:1:${PUID}
        ```

- Nextcloud Imaginary unable to start when this UIDMap is set on pod level, in which Imaginary is also configured.
    - To get around with that, set this in the Imaginary.container file
        ```ini
            UserNS=auto
        ```

