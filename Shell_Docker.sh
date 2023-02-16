#!/bin/bash
echo ""
echo "           ###################################"
echo "           #                                 #"
echo "           #        [YOUR DOCKER NAME]       #"
echo "           #                                 #"
echo "           ###################################"
echo ""

# Verify if the user it's root or not. #

if [ "$USER" != "root" ]
then
	echo -e "  Execute as superuser!\n"
	exit 0
fi

read -p "  [YAML VARIABLE]: " VARIABLE1
read -p "  [YAML VARIABLE]: " VARIABLE2
read -p "  [YAML VARIABLE]: " VARIABLE3
read -p "  [DOCKER NAME]:  " DOCKERNAME

# Removes the container with the same name that is running #

if docker ps -f "name=$DOCKERNAME" > /dev/null
then 
	echo "$(docker rm -f $DOCKERNAME > /dev/null)"
	echo "  Docker removed."
fi 

# Updates the image #

echo -e "\n  Updating the image..."
echo "  Image updated. $(docker pull [YOUR IMAGE] > /dev/null)"

# Creates a folder with a standard name: "docker-$DOCKERNAME" #

echo "  Folder created. $(mkdir docker-$DOCKERNAME)"
cd ./docker-$DOCKERNAME

# It creates a .yaml with the name "docker-compose.yaml" with the environment variables already filled in, in addition to a file that will store the log. # 

touch docker-compose.yaml
touch log.txt
touch error.txt
echo "  YAML created. $(echo "version: '2.2'

services:

   $DOCKERNAME:
    image: [YOUR IMAGE]
    container_name: $DOCKERNAME
    hostname: $DOCKERNAME
    environment:
      VARIABLE1: $VARIABLE1
      VARIABLE2: $VARIABLE2
    volumes:
     - ./app:/source/app
    ports:
     - \"19001:8090\""  > docker-compose.yaml) "

# Sobe o container #

echo "  Taking the log... $(docker-compose -f docker-compose.yaml up > log.txt 2> error.txt)" 

# CAT command to make your validation of sucess. #
cat log.txt | grep "X" > /dev/null 
SUCESSO="$(echo $?)"
if [ "$SUCESSO" = 0 ]
then
       echo -e "\n  Sucess.\n"
       exit 0
fi
if [ "$SUCESSO" != 0 ]
then
	echo -e "\n  Error.\n"
	rm -f docker-compose.yaml
	rm -f error.txt
fi
