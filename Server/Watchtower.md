# Watchtower

https://github.com/containrrr/watchtower  
  
I update all my Docker containers at once using "watchtower".  
Watchtower is a containerized (docker) service that will automatically check and apply updates of all your containers.  
It is highly customizable; you can configure it to check/apply updates every X time units or at a certain date/hour, you can ask it to only watch specific containers or only containers that has a certain label, sends you notification, etc...  
It automatically detect the source image and the run command and it will use them both correctly when applying update.  
See the documentation here : https://containrrr.dev/watchtower/  
  
Personaly, I'm not a huge fan of automatic update processes. I like to keep them interactive so I can see what's going on and directly interact in case of problems.  
However, I like to simplify this process as much as possible ! Thats why I use watchtower with the "--run-once" mode, so it is at me to manually launch it everytime but it still does everything for me :)  
See https://containrrr.dev/watchtower/arguments/ for more details

## Update All Docker Containers at once

I basically just need to launch the following command each time I want to update my docker containers :  
*(containers has to be started in order to be updated)*

```
sudo docker run --rm -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --run-once
```
  
I can then clean all dangling docker images :

```
sudo docker image prune
```

**OR**  
  
Cleaning the dangling docker images can be automatically done by Watchtower itself with the `--cleanup` argument :  

```
sudo docker run --rm -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --cleanup --run-once
```

## Tips and tricks
I've setuped the following alias in my .bashrc *(the "docker pull" at the beginning is just to make sure I always run the latest watchtower image)* :

```
alias dockup="sudo docker pull containrrr/watchtower && sudo docker run --rm -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower --cleanup --run-once"
```
