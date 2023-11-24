# LANCommander Docker
Repo to start [LANCommander](https://github.com/LANCommander/LANCommander) on Linux via Docker.

## Build the image
```bash
docker build . -t lancommander:0.2.2
```

## Configure LANCommander
Please change `Settings.yml` according to your needs.

## Run the image
```
docker run -it -p 1337:1337 -v ${PWD}/Settings.yml:/opt/LANCommander/Settings.yml -v ${PWD}/data:/opt/LANCommander/data lancommander:0.2.2
```

## Get to the UI
After starting the game browse to `http://localhost:1337/`.  
After setting your initial password you have to change to `http://localhost:1337/Games` to get starting, the dashboard doesn't currently work on Linux. The rest is working pretty well.
