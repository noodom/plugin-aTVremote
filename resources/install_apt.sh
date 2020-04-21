#!/bin/bash
PROGRESS_FILE=/tmp/dependancy_aTVremote_in_progress
BASEDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
if [ ! -z $1 ]; then
	PROGRESS_FILE=$1
fi
touch ${PROGRESS_FILE}
echo 0 > ${PROGRESS_FILE}
echo "--0%"
echo "********************************************************"
echo "*             Installation des dépendances             *"
echo "********************************************************"

sudo apt-get update
echo 10 > ${PROGRESS_FILE}
echo "--10%"
echo "Installation des dépendances apt"

sudo apt-get -y install lsb-release
if [ $(lsb_release -c | grep 'jessie' | wc -l) -eq 1 ]; then
    echo "ATTENTION CE PLUGIN NE FONCTIONNE PAS SOUS JESSIE, MERCI DE METTRE A JOUR VOTRE DISTRIBUTION !!!"
	echo "********************************************************"
	echo "*             Installation terminée                    *"
	echo "********************************************************"
    exit 1;
fi
sudo apt-get -y install python3 python3-pip python3-setuptools build-essential python3-dev zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev curl

echo 20 > ${PROGRESS_FILE}
echo "--20%"
cd ${BASEDIR};
sudo rm -fR ${BASEDIR}/atvremote
sudo pip3 install virtualenv
sudo virtualenv ${BASEDIR}/atvremote

echo 30 > ${PROGRESS_FILE}
echo "--30%"
lsb_release -c | grep stretch
if [ $? -eq 0 ]
then
  python3.7 --version &>/dev/null
  if [ $? -ne 0 ]; then
    sudo curl -O https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tar.xz
    sudo tar -xf Python-3.7.3.tar.xz
    #Clean tar file
    sudo rm -fR Python-3.7.3.tar.xz
    cd Python-3.7.3/
    #sudo ./configure --enable-optimizations #too slow
    sudo ./configure --prefix=/usr
    sudo make -j 2
    sudo make altinstall
    cd ..
    #Clean Python folder
    sudo rm -fR Python-3.7.3/
  fi
fi

echo 80 > ${PROGRESS_FILE}
echo "--80%"

sudo virtualenv -p `which python3.7` ${BASEDIR}/atvremote/
source ${BASEDIR}/atvremote/bin/activate

sudo pip3 install -I wheel
sudo pip3 install -I git+https://github.com/NebzHB/pyatv@release_0_5_x
deactivate

sudo pip3 install --upgrade pip
echo 100 > /${PROGRESS_FILE}
echo "--100%"
echo "********************************************************"
echo "*             Installation terminée                    *"
echo "********************************************************"
rm ${PROGRESS_FILE}
