cat > /etc/apt/sources.list <<EOF
## Note, this file is written by cloud-init on first boot of an instance
## modifications made here will not survive a re-bundle.
## if you wish to make changes you can:
## a.) add 'apt_preserve_sources_list: true' to /etc/cloud/cloud.cfg
##     or do the same in user-data
## b.) add sources in /etc/apt/sources.list.d
## c.) make changes to template file /etc/cloud/templates/sources.list.tmpl
#

# See http://help.ubuntu.com/community/UpgradeNotes for how to upgrade to
# newer versions of the distribution.
deb http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ precise main
deb-src http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ precise main

## Major bug fix updates produced after the final release of the
## distribution.
deb http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ precise-updates main
deb-src http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ precise-updates main

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team. Also, please note that software in universe WILL NOT receive any
## review or updates from the Ubuntu security team.
deb http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ precise universe
deb-src http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ precise universe
deb http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ precise-updates universe
deb-src http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ precise-updates universe

## N.B. software from this repository is ENTIRELY UNSUPPORTED by the Ubuntu
## team, and may not be under a free licence. Please satisfy yourself as to
## your rights to use the software. Also, please note that software in
## multiverse WILL NOT receive any review or updates from the Ubuntu
## security team.
# deb http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ precise multiverse
# deb-src http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ precise multiverse
# deb http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ precise-updates multiverse
# deb-src http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ precise-updates multiverse

## Uncomment the following two lines to add software from the 'backports'
## repository.
## N.B. software from this repository may not have been tested as
## extensively as that contained in the main release, although it includes
## newer versions of some applications which may provide useful features.
## Also, please note that software in backports WILL NOT receive any review
## or updates from the Ubuntu security team.
# deb http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ precise-backports main restricted universe multiverse
# deb-src http://eu-west-1.ec2.archive.ubuntu.com/ubuntu/ precise-backports main restricted universe multiverse

## Uncomment the following two lines to add software from Canonical's
## 'partner' repository.
## This software is not part of Ubuntu, but is offered by Canonical and the
## respective vendors as a service to Ubuntu users.
# deb http://archive.canonical.com/ubuntu precise partner
# deb-src http://archive.canonical.com/ubuntu precise partner

deb http://security.ubuntu.com/ubuntu precise-security main
deb-src http://security.ubuntu.com/ubuntu precise-security main
deb http://security.ubuntu.com/ubuntu precise-security universe
deb-src http://security.ubuntu.com/ubuntu precise-security universe
# deb http://security.ubuntu.com/ubuntu precise-security multiverse
# deb-src http://security.ubuntu.com/ubuntu precise-security multiverse
EOF


apt-get update
apt-get upgrade -f -y

apt-get install tomcat7 nginx -f -y
cd /var/lib/tomcat7/webapps


cat > /etc/nginx/sites-enabled/default <<EOF
server {
        location / {
                proxy_pass        http://localhost:8080/;
        }

}
EOF
#wget https://github.com/Netflix/asgard/releases/download/asgard-1.4.2/asgard.war
wget https://netflixoss.ci.cloudbees.com/job/asgard-master/lastSuccessfulBuild/artifact/target/asgard.war
rm -r ROOT/
mv asgard.war ROOT.war
