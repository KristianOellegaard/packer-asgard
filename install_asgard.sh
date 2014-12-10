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

# Use the java from Oracle
echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
add-apt-repository ppa:webupd8team/java -y
apt-get update
apt-get install oracle-java7-installer -f -y

update-java-alternatives -s java-7-oracle

cd /var/lib/tomcat7/webapps


cat > /etc/nginx/sites-enabled/default <<EOF
server {
        location / {
                proxy_pass        http://localhost:8080/;
                proxy_set_header Host \$http_host;
        }

}
EOF

cat > /etc/default/tomcat7 <<EOF

# Run Tomcat as this user ID. Not setting this or leaving it blank will use the
# default of tomcat7.
TOMCAT7_USER=tomcat7

# Run Tomcat as this group ID. Not setting this or leaving it blank will use
# the default of tomcat7.
TOMCAT7_GROUP=tomcat7

# The home directory of the Java development kit (JDK). You need at least
# JDK version 1.5. If JAVA_HOME is not set, some common directories for
# OpenJDK, the Sun JDK, and various J2SE 1.5 versions are tried.
#JAVA_HOME=/usr/lib/jvm/openjdk-6-jdk

# You may pass JVM startup parameters to Java here. If unset, the default
# options will be: -Djava.awt.headless=true -Xmx128m -XX:+UseConcMarkSweepGC
#
# Use "-XX:+UseConcMarkSweepGC" to enable the CMS garbage collector (improved
# response time). If you use that option and you run Tomcat on a machine with
# exactly one CPU chip that contains one or two cores, you should also add
# the "-XX:+CMSIncrementalMode" option.
JAVA_OPTS="-Djava.awt.headless=true -Xmx2048m -XX:MaxPermSize=128m -XX:+UseConcMarkSweepGC"

# To enable remote debugging uncomment the following line.
# You will then be able to use a java debugger on port 8000.
#JAVA_OPTS="${JAVA_OPTS} -Xdebug -Xrunjdwp:transport=dt_socket,address=8000,server=y,suspend=n"

# Java compiler to use for translating JavaServer Pages (JSPs). You can use all
# compilers that are accepted by Ant's build.compiler property.
#JSP_COMPILER=javac

# Use the Java security manager? (yes/no, default: no)
#TOMCAT7_SECURITY=no

# Number of days to keep logfiles in /var/log/tomcat7. Default is 14 days.
#LOGFILE_DAYS=14

# Location of the JVM temporary directory
# WARNING: This directory will be destroyed and recreated at every startup !
#JVM_TMP=/tmp/tomcat7-temp

# If you run Tomcat on port numbers that are all higher than 1023, then you
# do not need authbind.  It is used for binding Tomcat to lower port numbers.
# NOTE: authbind works only with IPv4.  Do not enable it when using IPv6.
# (yes/no, default: no)
#AUTHBIND=no

EOF

cat > /tmp/crontab <<EOF
# Edit this file to introduce tasks to be run by cron.
#
# Each task to run has to be defined through a single line
# indicating with different fields when the task will be run
# and what command to run for the task
#
# To define the time you can provide concrete values for
# minute (m), hour (h), day of month (dom), month (mon),
# and day of week (dow) or use '*' in these fields (for 'any').#
# Notice that tasks will be started based on the cron's system
# daemon's notion of time and timezones.
#
# Output of the crontab jobs (including errors) is sent through
# email to the user the crontab file belongs to (unless redirected).
#
# For example, you can run a backup of all your user accounts
# at 5 a.m every week with:
# 0 5 * * 1 tar -zcf /var/backups/home.tgz /home/
#
# For more information see the manual pages of crontab(5) and cron(8)
#
# m h  dom mon dow   command
0 */8   *   *   *    /usr/bin/service tomcat7 restart

EOF

crontab /tmp/crontab

#wget https://github.com/Netflix/asgard/releases/download/asgard-1.4.2/asgard.war
wget https://netflixoss.ci.cloudbees.com/job/asgard-master/lastSuccessfulBuild/artifact/target/asgard.war
rm -r ROOT/
mv asgard.war ROOT.war

mkdir /usr/share/tomcat7/.asgard/

cat > /usr/share/tomcat7/.asgard/Config.groovy <<EOF
// Add the correct values below

import com.netflix.asgard.Region
grails {
        awsAccounts=[] // ['12312312312', '13123123']
        awsAccountNames=[] ['12312312': 'test', '412312312': 'prod'] 
}
secret {
        accessId='sadasdasdasd'
        secretKey='asdasdasda'
}
cloud {
        accountName='prod'
        publicResourceAccounts=['test']
        buildServer = 'http://circleci.com/gh/yourorg/project'
        imageTagMasterAccount='test'
}
promote {
    // The address of the Asgard server that should receive all the REST calls
    // to add, update, and delete image tags in order keep the image tags
    // identical between the source and target accounts.
    targetServer = 'http://prod'

    // Set this to true in order to turn on image replication from this Asgard
    // instance. Only set this on the source Asgard, not on the target Asgard.
    imageTags = false

    // The address of the One True Asgard Instance that should be solely
    // responsible for automated replication of image tags to the tag promotion
    // target account. Asgard will query this address for its internal host name
    // in order to answer the question "Am I the current Asgard instance who
    // should do the tag replication?"
    canonicalServerForBakeEnvironment = 'http://test'
}

plugin {
    authenticationProvider = 'oneLoginAuthenticationProvider'
}

security {
    onelogin {
        url = 'https://app.onelogin.com/trust/saml2/http-post/sso/...'
        certificate = "" // without the comment ----BEGIN----/----END----
    }
}

EOF
