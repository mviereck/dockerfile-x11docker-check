# x11docker/check
[x11docker](https://github.com/mviereck/x11docker) container isolation and feature check.

Provides a GUI with several buttons to check out container capabilities and possible X security leaks.
The results will differ depending on chosen x11docker options on startup.

Image on Docker Hub: [x11docker/check](https://hub.docker.com/r/x11docker/check)

Example for a quite insecure setup: 
```
x11docker --hostdisplay --gpu x11docker/check
```

![Screenshot of x11docker/check](https://raw.githubusercontent.com/mviereck/x11docker/screenshots/screenshot-check.png?raw=true "Checking container isolation with x11docker/check")

