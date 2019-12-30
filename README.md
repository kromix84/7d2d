# 7d2d
### 7 days to die docker server
##### This is for 7d2d Linux Server running in Docker Container, Server Version Alpha 18.2.

Volumes are mapped in the docker-compose file for permanence to allow server reboots without losing progress
- data:/home/steam/server/
- save:/root/.local/share/7DaysToDie/Saves/

1. Run the container the first time to load all the files in the Host from the Container, then Down the container after it starts.
	-  copy docker-compose.yml to the host server (example: */opt/7d2d/*, then run it using "docker-compose up -d"
	- check the output logs of the 7d2d server with the command " tail +1f ./docker/volumes/7d2d_data/_data/output.log"
	- Once server is loaded, down it using the command "docker-compose down"
2. Modify the serverconfig.xml and serveradmin.xml as needed, the path to each are as follows, from the Docker install path:
	- ./docker/volumes/7d2d_data/_data/serverconfig.xml
	- ./docker/volumes/7d2d_save/_data/serveradmin.xml
3. Large Maps have difficulties in creation and might give an "Aborted (Core Dumped)" error with no other information.
	>In order to generate a world follow the following link or see below:
	https://7daystodie.com/forums/showthread.php?114207-Tool-NITROGEN-a-random-world-generator-for-7DtD

	**NOTE, I am using Windows to generate the map then transfering to linux server via WinSCP**

	- Download NitroGen World Generator from link above
	- Download and install Java 64-bit from Java (will not limit RAM usage during generation as oposed of Java 32-Bit)
	- Generate map using the NitroGen tool, note the save location for the map. 
	   (example: C:\NitroGen_WorldGenerator\output\NewWorld)
	- Copy the *NewWorld* folder from the output folder in NitroGen to 
	./docker/volumes/7d2d_data/_data/Data/Worlds/
	- The final path should be:
		./docker/volumes/7d2d_data/_data/Data/Worlds/*NewWorld*/*AllTheWorldDataInHere*

4. Modify the values in **serverconfig.xml**  located in **.docker/volumes/7d2d_data/_data/**
	- ServerName  
	- Server Description
	- TelnetPassword
	- GameWorld (this should be the name of your *NewWorld*)
	- GameName
	- Any other options as needed
	**Do not modify the funky formatting, seems to break the config**
5.  Restart the docker container using "docker-compose up -d".

> #### Scheduling Server Reboots
> This game seems to require server reboots to maintain stability, in order to perform proper reboots without crashing the server, you must issue the shutdown command to the game itself via telnet, as the shutdown command closes out the process, the container will go down, but as we have an "unless-stopped" on Reboot in the YAML file, the container will auto restart, as *it wasn't stopped* by docker . There are 3 ways of achieving this:
>  1. Manually via Web Console
>>    - go to https://172.30.0.1:8080 (*configured in YAML file*) from a computer in the local network and type *shutdown*.
>  2. Manually via Telnet (ensure telnet is installed in the host attempting the connection)
>>    - From a computer in the local network (or host) type **telnet 172.30.0.1 8081**, then type in telnet password (from serverconfig.xml) when asked, then issue the command **shutdown**
>  3. Automatically via a scheduler (Linux will need **expect** installed *apt-get install expect*) 
>>    - Copy the shtdwn.sh script to your *docker-container.yml* folder (example: */opt/7d2d/*).
>>    - Edit crontab to reboot the 7d2d server (sudo crontab -e)
>~~~~
> # This Reboots the 7d2d server and container daily at 4AM
> # Modify the command path to target the actual location of the script
> # m h  dom mon dow   command
>   0 4   *   *   *    /opt/7d2d/shtdwn.sh
>~~~~

**NOTE, You will need to modify UFW to allow the ports from the container through the network, and configure port forwarding in the router for WAN access**


