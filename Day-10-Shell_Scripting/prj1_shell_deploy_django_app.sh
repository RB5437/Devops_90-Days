#!/bin/bash

<<task
deploy a django app
and handle the code for errors
task

code_clone() {
  echo "cloneing the django app...."
  git clone https://github.com/ShendeShubham17/LondheShubham153-django-notes-app.git
}


install_requirements() {
  echo "installing dependencies"
   sudo apt-get update && sudo apt-get install docker.io nginx -y docker-compose

}


required_restarts() {
	sudo chown $USER /var/run/docker.sock
	#sudo systemctl enable docker 
	#sudo systemctl enable nginx
	#sudo systemctl restart docker
}

deploy() {
   docker build -t notes-app . 
   #docker run -d -p 8000:8000 notes-app:latest
   docker-compose up -d
}

echo "*******************DEPLOYMENT STARTED*****************************"
if ! code_clone; then
	echo "the code directory already exists"
	cd LondheShubham153-django-notes-app
fi

if ! install_requirements; then
	echo "installation failed"
	exit 1
fi
if ! required_restarts; then
	echo "system fault identified"
	exit 1
fi
if ! deploy; then
	echo "Deployment failed, mailing the admin":
	#sendmail
	exit 1
fi
echo "*******************DEPLOYMENT DONE*****************************"
