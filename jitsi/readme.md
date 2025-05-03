# Jitsi

This directory contains all the stack required to setup Jitsi

## Instructions

- Create folders in directory specified in .env
    ```sh
        mkdir -p ${CONFIG}/{jicofo,jvb,prosody/config,prosody/prosody-plugins-custom,web/crontabs,web/transcripts,web/load-test}
    ```

- Add this line in /etc/hosts to make the nginx in pod not shitting itself out
    ```sh
        127.0.0.1 xmpp.meet.jitsi
    ```

## Major Problem
- Took an entire fucking day to setup, scratching my head and found the second point above to do to make it working.
