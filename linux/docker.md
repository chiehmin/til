# Docker notes

## Setup

Adding user to `docker` group.

```bash
# adding docker group
$ sudo groupadd docker
# adding user to docker group
$ sudo gpasswd -a ${USER} docker    # or `usermod -a -G docker ${USER}`
# restart docker
$ sudo systemctl restart docker

# logout and login again to refresh group 
```

## Using Xvfb to run GUI applications

* DISPLAY variable format: `<hostname>:<display>.<monitor>`
* Installing Xvfb: `sudo dnf install xorg-x11-server-Xvfb`
* Creating new display with Xvfb: `Xvfb :1 -screen 0 1024x768x16`

Finally running the GUI app with: `DISPLAY=:1.0` appname

### Using x11vnc to access Xvfb

```bash
$ x11vnc -display :1   # the display we created using Xvfb
$ vncviewer :0         # connection localhost vncserver created by x11vnc
```

### Another short solution

[so](http://stackoverflow.com/questions/16296753/can-you-run-gui-apps-in-a-docker-container)

On host
```bash
# making docker 5900 port to be visible by outside
$ docker run -p 5900 [container]
```

Inside container
```bash
# "-create" will create a Xvfb  session if no session is found.
$ x11vnc -create 
```


