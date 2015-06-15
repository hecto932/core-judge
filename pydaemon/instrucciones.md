#How to execute this daemon?

##Pre-requisites

### Installation

```sh
    $ sudo apt-get install python python3
    $ sudo apt-get install python-daemon python-lockfile
```

##Instructions

1.- Create a folder in /usr/share/ called "pydaemon"

2.- Copy "pydaemon.py" in /usr/share/pydaemon

3.- You must create these folders:
    
        mkdir -p /var/log/pydaemon
        mkdir -p /var/run/pydaemon

4.- Copy "pydaemon.sh" in /etc/init.d/

5.- Change the permissions to the file:

    chmod u+x pydaemon

6.- To be the autorun script:

    /etc/init.d/insserv pydaemon.sh

7.- Once you have all this steps, you can monitor the daemon:
    
    tail -f /var/log/pydaemon/pydaemon.log



