# I. Init

## 1. Installation de Docker

## 2. Vérifier que Docker est bien là

## 3. sudo c pa bo

🌞 **Ajouter votre utilisateur au groupe `docker`**

```
sudo usermod -aG docker axel
```
```
axel@debian:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
```

## 4. Un premier conteneur en vif

🌞 **Lancer un conteneur NGINX**

```
axel@debian:~$ docker run -d -p 9999:80 nginx
Unable to find image 'nginx:latest' locally
latest: Pulling from library/nginx
af107e978371: Pull complete
336ba1f05c3e: Pull complete
8c37d2ff6efa: Pull complete
51d6357098de: Pull complete
782f1ecce57d: Pull complete
5e99d351b073: Pull complete
7b73345df136: Pull complete
Digest: sha256:bd30b8d47b230de52431cc71c5cce149b8d5d4c87c204902acf2504435d4b4c9
Status: Downloaded newer image for nginx:latest
c386a068aa4949c1dbd22ccc04756066260da52fdbb229ea747557a275bcdb36
```

🌞 **Visitons**

```
axel@debian:~$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS                                   NAMES
c386a068aa49   nginx     "/docker-entrypoint.…"   8 seconds ago   Up 7 seconds   0.0.0.0:9999->80/tcp, :::9999->80/tcp   interesting_keller
```
```
axel@debian:~$ docker logs c386a068aa49
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: Getting the checksum of /etc/nginx/conf.d/default.conf
10-listen-on-ipv6-by-default.sh: info: Enabled listen on IPv6 in /etc/nginx/conf.d/default.conf
/docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envsh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2023/12/21 09:50:17 [notice] 1#1: using the "epoll" event method
2023/12/21 09:50:17 [notice] 1#1: nginx/1.25.3
2023/12/21 09:50:17 [notice] 1#1: built by gcc 12.2.0 (Debian 12.2.0-14)
2023/12/21 09:50:17 [notice] 1#1: OS: Linux 6.1.0-16-amd64
2023/12/21 09:50:17 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
2023/12/21 09:50:17 [notice] 1#1: start worker processes
2023/12/21 09:50:17 [notice] 1#1: start worker process 29
2023/12/21 09:50:17 [notice] 1#1: start worker process 30
2023/12/21 09:50:17 [notice] 1#1: start worker process 31
2023/12/21 09:50:17 [notice] 1#1: start worker process 32
2023/12/21 09:50:17 [notice] 1#1: start worker process 33
2023/12/21 09:50:17 [notice] 1#1: start worker process 34
2023/12/21 09:50:17 [notice] 1#1: start worker process 35
2023/12/21 09:50:17 [notice] 1#1: start worker process 36
2023/12/21 09:50:17 [notice] 1#1: start worker process 37
2023/12/21 09:50:17 [notice] 1#1: start worker process 38
2023/12/21 09:50:17 [notice] 1#1: start worker process 39
2023/12/21 09:50:17 [notice] 1#1: start worker process 40
2023/12/21 09:50:17 [notice] 1#1: start worker process 41
2023/12/21 09:50:17 [notice] 1#1: start worker process 42
2023/12/21 09:50:17 [notice] 1#1: start worker process 43
2023/12/21 09:50:17 [notice] 1#1: start worker process 44
172.17.0.1 - - [21/Dec/2023:09:55:48 +0000] "GET / HTTP/1.1" 200 615 "-" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0" "-"
2023/12/21 09:55:48 [error] 29#29: *1 open() "/usr/share/nginx/html/favicon.ico" failed (2: No such file or directory), client: 172.17.0.1, server: localhost, request: "GET /favicon.ico HTTP/1.1", host: "localhost:9999", referrer: "http://localhost:9999/"
172.17.0.1 - - [21/Dec/2023:09:55:48 +0000] "GET /favicon.ico HTTP/1.1" 404 153 "http://localhost:9999/" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0" "-"
172.17.0.1 - - [21/Dec/2023:09:56:48 +0000] "GET / HTTP/1.1" 200 615 "-" "Mozilla/5.0 (X11; Linux x86_64; rv:109.0) Gecko/20100101 Firefox/115.0" "-"
```
```
axel@debian:~$ docker inspect c386a068aa49
[
    {
        "Id": "c386a068aa4949c1dbd22ccc04756066260da52fdbb229ea747557a275bcdb36",
        "Created": "2023-12-21T09:50:17.138149634Z",
        "Path": "/docker-entrypoint.sh",
        "Args": [
            "nginx",
            "-g",
            "daemon off;"
        ],
        "State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
            "Restarting": false,
            "OOMKilled": false,
            "Dead": false,
            "Pid": 16426,
            "ExitCode": 0,
            "Error": "",
            "StartedAt": "2023-12-21T09:50:17.745604443Z",
            "FinishedAt": "0001-01-01T00:00:00Z"
        },
        "Image": "sha256:d453dd892d9357f3559b967478ae9cbc417b52de66b53142f6c16c8a275486b9",
        "ResolvConfPath": "/var/lib/docker/containers/c386a068aa4949c1dbd22ccc04756066260da52fdbb229ea747557a275bcdb36/resolv.conf",
        "HostnamePath": "/var/lib/docker/containers/c386a068aa4949c1dbd22ccc04756066260da52fdbb229ea747557a275bcdb36/hostname",
        "HostsPath": "/var/lib/docker/containers/c386a068aa4949c1dbd22ccc04756066260da52fdbb229ea747557a275bcdb36/hosts",
        "LogPath": "/var/lib/docker/containers/c386a068aa4949c1dbd22ccc04756066260da52fdbb229ea747557a275bcdb36/c386a068aa4949c1dbd22ccc04756066260da52fdbb229ea747557a275bcdb36-json.log",
        "Name": "/interesting_keller",
        "RestartCount": 0,
        "Driver": "overlay2",
        "Platform": "linux",
        "MountLabel": "",
        "ProcessLabel": "",
        "AppArmorProfile": "docker-default",
        "ExecIDs": null,
        "HostConfig": {
            "Binds": null,
            "ContainerIDFile": "",
            "LogConfig": {
                "Type": "json-file",
                "Config": {}
            },
            "NetworkMode": "default",
            "PortBindings": {
                "80/tcp": [
                    {
                        "HostIp": "",
                        "HostPort": "9999"
                    }
                ]
            },
            "RestartPolicy": {
                "Name": "no",
                "MaximumRetryCount": 0
            },
            "AutoRemove": false,
            "VolumeDriver": "",
            "VolumesFrom": null,
            "ConsoleSize": [
                21,
                109
            ],
            "CapAdd": null,
            "CapDrop": null,
            "CgroupnsMode": "private",
            "Dns": [],
            "DnsOptions": [],
            "DnsSearch": [],
            "ExtraHosts": null,
            "GroupAdd": null,
            "IpcMode": "private",
            "Cgroup": "",
            "Links": null,
            "OomScoreAdj": 0,
            "PidMode": "",
            "Privileged": false,
            "PublishAllPorts": false,
            "ReadonlyRootfs": false,
            "SecurityOpt": null,
            "UTSMode": "",
            "UsernsMode": "",
            "ShmSize": 67108864,
            "Runtime": "runc",
            "Isolation": "",
            "CpuShares": 0,
            "Memory": 0,
            "NanoCpus": 0,
            "CgroupParent": "",
            "BlkioWeight": 0,
            "BlkioWeightDevice": [],
            "BlkioDeviceReadBps": [],
            "BlkioDeviceWriteBps": [],
            "BlkioDeviceReadIOps": [],
            "BlkioDeviceWriteIOps": [],
            "CpuPeriod": 0,
            "CpuQuota": 0,
            "CpuRealtimePeriod": 0,
            "CpuRealtimeRuntime": 0,
            "CpusetCpus": "",
            "CpusetMems": "",
            "Devices": [],
            "DeviceCgroupRules": null,
            "DeviceRequests": null,
            "MemoryReservation": 0,
            "MemorySwap": 0,
            "MemorySwappiness": null,
            "OomKillDisable": null,
            "PidsLimit": null,
            "Ulimits": null,
            "CpuCount": 0,
            "CpuPercent": 0,
            "IOMaximumIOps": 0,
            "IOMaximumBandwidth": 0,
            "MaskedPaths": [
                "/proc/asound",
                "/proc/acpi",
                "/proc/kcore",
                "/proc/keys",
                "/proc/latency_stats",
                "/proc/timer_list",
                "/proc/timer_stats",
                "/proc/sched_debug",
                "/proc/scsi",
                "/sys/firmware",
                "/sys/devices/virtual/powercap"
            ],
            "ReadonlyPaths": [
                "/proc/bus",
                "/proc/fs",
                "/proc/irq",
                "/proc/sys",
                "/proc/sysrq-trigger"
            ]
        },
        "GraphDriver": {
            "Data": {
                "LowerDir": "/var/lib/docker/overlay2/19bc886476261b5ee243aacf7a0ebb1e12800f59344152ba3da1cc99c3f7f202-init/diff:/var/lib/docker/overlay2/8e5a44cc10669f883595b8b2583f7eb093415daeea48e64f49ed3669409ec477/diff:/var/lib/docker/overlay2/ad64cf08c2e7a506138f426ed84dc9d6084857c26df1d06f0d9462a5aa6e8a02/diff:/var/lib/docker/overlay2/f0cf753f5889132074ed95862429836388411dda902b3e7041d147f9e6739eb0/diff:/var/lib/docker/overlay2/24a2bc823f3bab40d386cf99a51604bf09e77b2446b42e2735ebade10e1f1ac7/diff:/var/lib/docker/overlay2/ea9555a482900e66cd4b9f9f730921908532575a74ad0a7bbf975afee0e3faf2/diff:/var/lib/docker/overlay2/2f652e9b9bdf6914104fca8a94635b059606bf3bd89834a8b130b3a057c9f0a7/diff:/var/lib/docker/overlay2/51b196c70b6bc24cab51dab54e0045236f2143df519e036d4fe57f51849d3275/diff",
                "MergedDir": "/var/lib/docker/overlay2/19bc886476261b5ee243aacf7a0ebb1e12800f59344152ba3da1cc99c3f7f202/merged",
                "UpperDir": "/var/lib/docker/overlay2/19bc886476261b5ee243aacf7a0ebb1e12800f59344152ba3da1cc99c3f7f202/diff",
                "WorkDir": "/var/lib/docker/overlay2/19bc886476261b5ee243aacf7a0ebb1e12800f59344152ba3da1cc99c3f7f202/work"
            },
            "Name": "overlay2"
        },
        "Mounts": [],
        "Config": {
            "Hostname": "c386a068aa49",
            "Domainname": "",
            "User": "",
            "AttachStdin": false,
            "AttachStdout": false,
            "AttachStderr": false,
            "ExposedPorts": {
                "80/tcp": {}
            },
            "Tty": false,
            "OpenStdin": false,
            "StdinOnce": false,
            "Env": [
                "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
                "NGINX_VERSION=1.25.3",
                "NJS_VERSION=0.8.2",
                "PKG_RELEASE=1~bookworm"
            ],
            "Cmd": [
                "nginx",
                "-g",
                "daemon off;"
            ],
            "Image": "nginx",
            "Volumes": null,
            "WorkingDir": "",
            "Entrypoint": [
                "/docker-entrypoint.sh"
            ],
            "OnBuild": null,
            "Labels": {
                "maintainer": "NGINX Docker Maintainers <docker-maint@nginx.com>"
            },
            "StopSignal": "SIGQUIT"
        },
        "NetworkSettings": {
            "Bridge": "",
            "SandboxID": "24d8886fc908a01c57e1ea8e5857433d99b00524973b56acd74b346da9bfd6a5",
            "HairpinMode": false,
            "LinkLocalIPv6Address": "",
            "LinkLocalIPv6PrefixLen": 0,
            "Ports": {
                "80/tcp": [
                    {
                        "HostIp": "0.0.0.0",
                        "HostPort": "9999"
                    },
                    {
                        "HostIp": "::",
                        "HostPort": "9999"
                    }
                ]
            },
            "SandboxKey": "/var/run/docker/netns/24d8886fc908",
            "SecondaryIPAddresses": null,
            "SecondaryIPv6Addresses": null,
            "EndpointID": "43d644c050b9d13dc5139923249fd104ba399ebae3384a8b32e1e72f9f5a0222",
            "Gateway": "172.17.0.1",
            "GlobalIPv6Address": "",
            "GlobalIPv6PrefixLen": 0,
            "IPAddress": "172.17.0.2",
            "IPPrefixLen": 16,
            "IPv6Gateway": "",
            "MacAddress": "02:42:ac:11:00:02",
            "Networks": {
                "bridge": {
                    "IPAMConfig": null,
                    "Links": null,
                    "Aliases": null,
                    "NetworkID": "885e45fe24f9431a1918f96154b4ef90724a9b2c1e59394363cc4cec41b5b138",
                    "EndpointID": "43d644c050b9d13dc5139923249fd104ba399ebae3384a8b32e1e72f9f5a0222",
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.2",
                    "IPPrefixLen": 16,
                    "IPv6Gateway": "",
                    "GlobalIPv6Address": "",
                    "GlobalIPv6PrefixLen": 0,
                    "MacAddress": "02:42:ac:11:00:02",
                    "DriverOpts": null
                }
            }
        }
    }
]
```
```
axel@debian:~$ sudo ss -lnpt | grep docker
LISTEN 0      4096         0.0.0.0:9999      0.0.0.0:*    users:(("docker-proxy",pid=16383,fd=4))
LISTEN 0      4096            [::]:9999         [::]:*    users:(("docker-proxy",pid=16390,fd=4))
```
```
axel@debian:~$ curl http://localhost:9999
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

🌞 **On va ajouter un site Web au conteneur NGINX**

```
axel@debian:~/Random/nginx$ cat index.html
<h1>MEOOOW</h1>
axel@debian:~/Random/nginx$ cat site_nul.conf
server {
    listen        8080;

    location / {
        root /var/www/html/;
    }
}
```
```
axel@debian:~/Random/nginx$ docker run -d -p 9999:8080 -v /home/axel/Random/nginx/index.html:/var/www/html/index.html -v /home/axel/Random/nginx/site_nul.conf:/etc/nginx/conf.d/site_nul.conf nginx
244397a6e5e14d39e77a3647abe54e90418c30b7a7bbd95d96ea4c3028ff4f2e
```

🌞 **Visitons**

```
axel@debian:~/Random/nginx$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED              STATUS              PORTS                                               NAMES
244397a6e5e1   nginx     "/docker-entrypoint.…"   About a minute ago   Up About a minute   80/tcp, 0.0.0.0:9999->8080/tcp, :::9999->8080/tcp   competent_dijkstra
```
```
axel@debian:~/Random/nginx$ curl http://localhost:9999
<h1>MEOOOW</h1>
```

## 5. Un deuxième conteneur en vif

🌞 **Lance un conteneur Python, avec un shell**

```
axel@debian:~/Random/nginx$ docker run -it python bash
Unable to find image 'python:latest' locally
latest: Pulling from library/python
bc0734b949dc: Pull complete
b5de22c0f5cd: Pull complete
917ee5330e73: Pull complete
b43bd898d5fb: Pull complete
7fad4bffde24: Pull complete
d685eb68699f: Pull complete
107007f161d0: Pull complete
02b85463d724: Pull complete
Digest: sha256:3733015cdd1bd7d9a0b9fe21a925b608de82131aa4f3d397e465a1fcb545d36f
Status: Downloaded newer image for python:latest
```

🌞 **Installe des libs Python**

```
root@602e7d8f8c94:/# pip install aiohttp
Collecting aiohttp
  Obtaining dependency information for aiohttp from https://files.pythonhosted.org/packages/75/5f/90a2869ad3d1fb9bd984bfc1b02d8b19e381467b238bd3668a09faa69df5/aiohttp-3.9.1-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl.metadata
  Downloading aiohttp-3.9.1-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl.metadata (7.4 kB)
Collecting attrs>=17.3.0 (from aiohttp)
  Downloading attrs-23.1.0-py3-none-any.whl (61 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 61.2/61.2 kB 1.3 MB/s eta 0:00:00
Collecting multidict<7.0,>=4.5 (from aiohttp)
  Downloading multidict-6.0.4.tar.gz (51 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 51.3/51.3 kB 3.8 MB/s eta 0:00:00
  Installing build dependencies ... done
  Getting requirements to build wheel ... done
  Installing backend dependencies ... done
  Preparing metadata (pyproject.toml) ... done
Collecting yarl<2.0,>=1.0 (from aiohttp)
  Obtaining dependency information for yarl<2.0,>=1.0 from https://files.pythonhosted.org/packages/28/1c/bdb3411467b805737dd2720b85fd082e49f59bf0cc12dc1dfcc80ab3d274/yarl-1.9.4-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl.metadata
  Downloading yarl-1.9.4-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl.metadata (31 kB)
Collecting frozenlist>=1.1.1 (from aiohttp)
  Obtaining dependency information for frozenlist>=1.1.1 from https://files.pythonhosted.org/packages/0b/f2/b8158a0f06faefec33f4dff6345a575c18095a44e52d4f10c678c137d0e0/frozenlist-1.4.1-cp312-cp312-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_17_x86_64.manylinux2014_x86_64.whl.metadata
  Downloading frozenlist-1.4.1-cp312-cp312-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_17_x86_64.manylinux2014_x86_64.whl.metadata (12 kB)
Collecting aiosignal>=1.1.2 (from aiohttp)
  Downloading aiosignal-1.3.1-py3-none-any.whl (7.6 kB)
Collecting idna>=2.0 (from yarl<2.0,>=1.0->aiohttp)
  Obtaining dependency information for idna>=2.0 from https://files.pythonhosted.org/packages/c2/e7/a82b05cf63a603df6e68d59ae6a68bf5064484a0718ea5033660af4b54a9/idna-3.6-py3-none-any.whl.metadata
  Downloading idna-3.6-py3-none-any.whl.metadata (9.9 kB)
Downloading aiohttp-3.9.1-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (1.3 MB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 1.3/1.3 MB 19.8 MB/s eta 0:00:00
Downloading frozenlist-1.4.1-cp312-cp312-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_17_x86_64.manylinux2014_x86_64.whl (281 kB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 281.5/281.5 kB 25.3 MB/s eta 0:00:00
Downloading yarl-1.9.4-cp312-cp312-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (322 kB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 322.4/322.4 kB 13.9 MB/s eta 0:00:00
Downloading idna-3.6-py3-none-any.whl (61 kB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 61.6/61.6 kB 7.5 MB/s eta 0:00:00
Building wheels for collected packages: multidict
  Building wheel for multidict (pyproject.toml) ... done
  Created wheel for multidict: filename=multidict-6.0.4-cp312-cp312-linux_x86_64.whl size=114917 sha256=dbc443b84ab4342e9ebba3abb6f25447d606b3db19b3690b20ef67ea8c12b3ec
  Stored in directory: /root/.cache/pip/wheels/f6/d8/ff/3c14a64b8f2ab1aa94ba2888f5a988be6ab446ec5c8d1a82da
Successfully built multidict
Installing collected packages: multidict, idna, frozenlist, attrs, yarl, aiosignal, aiohttp
Successfully installed aiohttp-3.9.1 aiosignal-1.3.1 attrs-23.1.0 frozenlist-1.4.1 idna-3.6 multidict-6.0.4 yarl-1.9.4
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv

[notice] A new release of pip is available: 23.2.1 -> 23.3.2
[notice] To update, run: pip install --upgrade pip
root@602e7d8f8c94:/# pip install aioconsole
Collecting aioconsole
  Obtaining dependency information for aioconsole from https://files.pythonhosted.org/packages/f7/39/b392dc1a8bb58342deacc1ed2b00edf88fd357e6fdf76cc6c8046825f84f/aioconsole-0.7.0-py3-none-any.whl.metadata
  Downloading aioconsole-0.7.0-py3-none-any.whl.metadata (5.3 kB)
Downloading aioconsole-0.7.0-py3-none-any.whl (30 kB)
Installing collected packages: aioconsole
Successfully installed aioconsole-0.7.0
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv

[notice] A new release of pip is available: 23.2.1 -> 23.3.2
[notice] To update, run: pip install --upgrade pip
```
```
root@602e7d8f8c94:/# python
Python 3.12.1 (main, Dec 19 2023, 20:14:15) [GCC 12.2.0] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> import aiohttp
>>>
```

# II. Images

## 1. Images publiques

🌞 **Récupérez des images**

```
axel@debian:~$ docker pull python:3.11
3.11: Pulling from library/python
bc0734b949dc: Already exists
b5de22c0f5cd: Already exists
917ee5330e73: Already exists
b43bd898d5fb: Already exists
7fad4bffde24: Already exists
1f68ce6a3e62: Pull complete
e27d998f416b: Pull complete
fefdcd9854bf: Pull complete
Digest: sha256:4e5e9b05dda9cf699084f20bb1d3463234446387fa0f7a45d90689c48e204c83
Status: Downloaded newer image for python:3.11
docker.io/library/python:3.11

axel@debian:~$ docker pull mysql:5.7
5.7: Pulling from library/mysql
20e4dcae4c69: Pull complete
1c56c3d4ce74: Pull complete
e9f03a1c24ce: Pull complete
68c3898c2015: Pull complete
6b95a940e7b6: Pull complete
90986bb8de6e: Pull complete
ae71319cb779: Pull complete
ffc89e9dfd88: Pull complete
43d05e938198: Pull complete
064b2d298fba: Pull complete
df9a4d85569b: Pull complete
Digest: sha256:4bc6bc963e6d8443453676cae56536f4b8156d78bae03c0145cbe47c2aad73bb
Status: Downloaded newer image for mysql:5.7
docker.io/library/mysql:5.7

axel@debian:~$ docker pull wordpress
Using default tag: latest
latest: Pulling from library/wordpress
af107e978371: Already exists
6480d4ad61d2: Pull complete
95f5176ece8b: Pull complete
0ebe7ec824ca: Pull complete
673e01769ec9: Pull complete
74f0c50b3097: Pull complete
1a19a72eb529: Pull complete
50436df89cfb: Pull complete
8b616b90f7e6: Pull complete
df9d2e4043f8: Pull complete
d6236f3e94a1: Pull complete
59fa8b76a6b3: Pull complete
99eb3419cf60: Pull complete
22f5c20b545d: Pull complete
1f0d2c1603d0: Pull complete
4624824acfea: Pull complete
79c3af11cab5: Pull complete
e8d8239610fb: Pull complete
a1ff013e1d94: Pull complete
31076364071c: Pull complete
87728bbad961: Pull complete
Digest: sha256:be7173998a8fa131b132cbf69d3ea0239ff62be006f1ec11895758cf7b1acd9e
Status: Downloaded newer image for wordpress:latest
docker.io/library/wordpress:latest

axel@debian:~$ docker pull linuxserver/wikijs
Using default tag: latest
latest: Pulling from linuxserver/wikijs
8b16ab80b9bd: Pull complete
07a0e16f7be1: Pull complete
145cda5894de: Pull complete
1a16fa4f6192: Pull complete
84d558be1106: Pull complete
4573be43bb06: Pull complete
20b23561c7ea: Pull complete
Digest: sha256:131d247ab257cc3de56232b75917d6f4e24e07c461c9481b0e7072ae8eba3071
Status: Downloaded newer image for linuxserver/wikijs:latest
docker.io/linuxserver/wikijs:latest

axel@debian:~$ docker images
REPOSITORY           TAG       IMAGE ID       CREATED       SIZE
linuxserver/wikijs   latest    869729f6d3c5   5 days ago    441MB
mysql                5.7       5107333e08a8   8 days ago    501MB
python               latest    fc7a60e86bae   13 days ago   1.02GB
wordpress            latest    fd2f5a0c6fba   2 weeks ago   739MB
python               3.11      22140cbb3b0c   2 weeks ago   1.01GB
nginx                latest    d453dd892d93   8 weeks ago   187MB
```

🌞 **Lancez un conteneur à partir de l'image Python**

```
axel@debian:~$ docker run -it python:3.11 bash
root@1118605fd907:/# python --version
Python 3.11.7
```

## 2. Construire une image

🌞 **Ecrire un Dockerfile pour une image qui héberge une application Python**

```
axel@debian:~/Random$ cat Dockerfile 
FROM debian
RUN apt update
RUN apt install python3 -y
RUN apt install python3-emoji
COPY app.py .
ENTRYPOINT ["python3", "app.py"]
```

🌞 **Build l'image**

```
axel@debian:~/Random$ docker build . -t python_app:version_de_ouf
```
```
axel@debian:~/Random$ docker images | grep python_app
python_app           version_de_ouf   ecf077f4b57d   2 minutes ago   190MB
```

🌞 **Lancer l'image**

```
axel@debian:~/Random$ docker run python_app:version_de_ouf
Cet exemple d'application est vraiment naze 👎
```

# III. Docker compose

🌞 **Créez un fichier `docker-compose.yml`**

```
axel@debian:~/Random/compose_test$ cat docker-compose.yml 
version: "3"

services:
  conteneur_nul:
    image: debian
    entrypoint: sleep 9999
  conteneur_flopesque:
    image: debian
    entrypoint: sleep 9999
```

🌞 **Lancez les deux conteneurs** avec `docker compose`

```
axel@debian:~/Random/compose_test$ docker compose up -d
[+] Running 3/3
 ✔ conteneur_flopesque 1 layers [⣿]      0B/0B      Pulled                                         2.7s 
   ✔ bc0734b949dc Already exists                                                                   0.0s 
 ✔ conteneur_nul Pulled                                                                            3.1s 
[+] Running 3/3
 ✔ Network compose_test_default                  Created                                           0.2s 
 ✔ Container compose_test-conteneur_flopesque-1  Started                                           0.0s 
 ✔ Container compose_test-conteneur_nul-1        Start...                                          0.0s 
```

🌞 **Vérifier que les deux conteneurs tournent**

```
axel@debian:~/Random/compose_test$ docker compose ps
NAME                                 IMAGE     COMMAND        SERVICE               CREATED         STATUS         PORTS
compose_test-conteneur_flopesque-1   debian    "sleep 9999"   conteneur_flopesque   6 minutes ago   Up 6 minutes   
compose_test-conteneur_nul-1         debian    "sleep 9999"   conteneur_nul         6 minutes ago   Up 6 minutes   
```

🌞 **Pop un shell dans le conteneur `conteneur_nul`**

```
axel@debian:~/Random/compose_test$ docker exec compose_test-conteneur_nul-1 apt update -y

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

Get:1 http://deb.debian.org/debian bookworm InRelease [151 kB]
Get:2 http://deb.debian.org/debian bookworm-updates InRelease [52.1 kB]
Get:3 http://deb.debian.org/debian-security bookworm-security InRelease [48.0 kB]
Get:4 http://deb.debian.org/debian bookworm/main amd64 Packages [8787 kB]
Get:5 http://deb.debian.org/debian bookworm-updates/main amd64 Packages [11.3 kB]
Get:6 http://deb.debian.org/debian-security bookworm-security/main amd64 Packages [130 kB]
Fetched 9180 kB in 4s (2448 kB/s)
Reading package lists...
Building dependency tree...
Reading state information...
All packages are up to date.
axel@debian:~/Random/compose_test$ docker exec compose_test-conteneur_nul-1 apt install -y iputils-ping

WARNING: apt does not have a stable CLI interface. Use with caution in scripts.

Reading package lists...
Building dependency tree...
Reading state information...
The following additional packages will be installed:
  libcap2-bin libpam-cap
The following NEW packages will be installed:
  iputils-ping libcap2-bin libpam-cap
0 upgraded, 3 newly installed, 0 to remove and 0 not upgraded.
Need to get 96.2 kB of archives.
After this operation, 311 kB of additional disk space will be used.
Get:1 http://deb.debian.org/debian bookworm/main amd64 libcap2-bin amd64 1:2.66-4 [34.7 kB]
Get:2 http://deb.debian.org/debian bookworm/main amd64 iputils-ping amd64 3:20221126-1 [47.1 kB]
Get:3 http://deb.debian.org/debian bookworm/main amd64 libpam-cap amd64 1:2.66-4 [14.5 kB]
debconf: delaying package configuration, since apt-utils is not installed
Fetched 96.2 kB in 0s (1278 kB/s)
Selecting previously unselected package libcap2-bin.
(Reading database ... 6098 files and directories currently installed.)
Preparing to unpack .../libcap2-bin_1%3a2.66-4_amd64.deb ...
Unpacking libcap2-bin (1:2.66-4) ...
Selecting previously unselected package iputils-ping.
Preparing to unpack .../iputils-ping_3%3a20221126-1_amd64.deb ...
Unpacking iputils-ping (3:20221126-1) ...
Selecting previously unselected package libpam-cap:amd64.
Preparing to unpack .../libpam-cap_1%3a2.66-4_amd64.deb ...
Unpacking libpam-cap:amd64 (1:2.66-4) ...
Setting up libcap2-bin (1:2.66-4) ...
Setting up libpam-cap:amd64 (1:2.66-4) ...
debconf: unable to initialize frontend: Dialog
debconf: (TERM is not set, so the dialog frontend is not usable.)
debconf: falling back to frontend: Readline
debconf: unable to initialize frontend: Readline
debconf: (Can't locate Term/ReadLine.pm in @INC (you may need to install the Term::ReadLine module) (@INC contains: /etc/perl /usr/local/lib/x86_64-linux-gnu/perl/5.36.0 /usr/local/share/perl/5.36.0 /usr/lib/x86_64-linux-gnu/perl5/5.36 /usr/share/perl5 /usr/lib/x86_64-linux-gnu/perl-base /usr/lib/x86_64-linux-gnu/perl/5.36 /usr/share/perl/5.36 /usr/local/lib/site_perl) at /usr/share/perl5/Debconf/FrontEnd/Readline.pm line 7.)
debconf: falling back to frontend: Teletype
Setting up iputils-ping (3:20221126-1) ...
axel@debian:~/Random/compose_test$ docker exec compose_test-conteneur_nul-1 ping conteneur_flopesque
PING conteneur_flopesque (172.18.0.3) 56(84) bytes of data.
64 bytes from compose_test-conteneur_flopesque-1.compose_test_default (172.18.0.3): icmp_seq=1 ttl=64 time=0.219 ms
64 bytes from compose_test-conteneur_flopesque-1.compose_test_default (172.18.0.3): icmp_seq=2 ttl=64 time=0.110 ms
```