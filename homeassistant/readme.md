# Homeassistant

## Major Problem
- The dbus is not working properly on podman, due to this we cannot use bluetooth devices.
    - To get around with this you have to add in homeassistant.container
        ```ini
            UserNS=keep-id
        ```
    
    - but the above setting, hangs my podman raspberry pi 4, as it actively converts all the files inside the container to another user. So, I have choose to remove dbus as I am not using bluetooth anyway.
