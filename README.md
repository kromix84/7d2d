# 7d2d
7 days to die docker server

This is for 7d2d Linux Server running in Docker Container, Server Version Alpha 18.2.

Volumes are mapped in the docker-compose file for permanence to allow server reboots without losing progress
	- data:/home/steam/server/
	- save:/root/.local/share/7DaysToDie/Saves/

1) Run the container the first time to load all the files in the Host from the Container, then Down the container after it starts.
  a) copy docker-compose.yml to the host server, then run it using "docker-compose up -d"
  b) check the output logs of the 7d2d server with the command " tail +1f ./docker/volumes/7d2d_data/_data/output.log"
  c) once server is loaded, down it using the command "docker-compose down"
2) Modify the serverconfig.xml and serveradmin.xml as needed, the path to each are as follows, from the Docker install path:
	a) ./docker/volumes/7d2d_data/_data/serverconfig.xml
	b) ./docker/volumes/7d2d_save/_data/serveradmin.xml
3) Large Maps have difficulties in creation and might give an "Aborted (Core Dumped)" error with no other information.
	In order to generate a world follow the following link or see below:
	https://7daystodie.com/forums/showthread.php?114207-Tool-NITROGEN-a-random-world-generator-for-7DtD
		**NOTE, I'm using Windows to generate the map then transfering to linux server via WinSCP**
	a) Download NitroGen World Generator from link above
	b) Download and install Java 64-bit from Java (will not limit RAM usage during generation as oposed of Java 32-Bit)
	c) Generate map using the NitroGen tool, note the save location for the map. ( example: C:\NitroGen_WorldGenerator\output\NewWorld)
	d) Copy the NewWorld folder from the output folder in NitroGen to ./docker/volumes/7d2d_data/_data/Data/Worlds/
		The final path should be ./docker/volumes/7d2d_data/_data/Data/Worlds/NewWorld/AllTheWorldDataInHere
	e) Modify the serverconfig.xml file in .docker/volumes/7d2d_data/_data/ to reflect this world name. (replace Navezgane with NewWorld)
      *Also modify passwords and other options as needed, do not modify the funky formatting*
4) restart the docker container using "docker-compose up -d".

**NOTE, You will need to modify UFW to allow the ports from the container through the network, and configure port forwarding in the router for WAN access**
