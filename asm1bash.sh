# RMIT University Vietnam
# Course: COSC2767 System Deployment and Operations
# Semester: 2022B
# Assessment: Assignment 1
# Author: Nguyen Chau Loan
# ID: 3880115
# Created Date 04/08/2022
# Last Modified 04/08/2022
# Acknowledgement: to Codinglabweb.com https://www.codinglabweb.com/2021/03/responsive-portfolio-website-using-html-css$


# Install Java 11 following with y for allow/yes
sudo amazon-linux-extras install java-openjdk11 -y

## Install Maven
# Go to opt folder
cd /opt

# Download binary distribution of Maven
wget https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz

# Extract the compressed file
tar -xvzf apache-maven-3.8.6-bin.tar.gz

# Rename folder
mv apache-maven-3.8.6 maven


## Set up symbolic link
# Environment Variables
# Back to home
cd ~

# Edit bash_profile file
sed -i '/programs/a \JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.13.0.8-1.amzn2.0.3.x86_64' .bash_profile
sed -i '/programs/a \M2=/opt/maven/bin' .bash_profile
sed -i '/programs/a \M2_HOME=/opt/maven' .bash_profile

# search file where there is 'PATH=' and append text at the end of that line
sed -i '/PATH=/ s/$/:$JAVA_HOME:$M2_HOME:$M2/' .bash_profile

cd ~

# Apply new changes to bash_profile
source ~/.bash_profile

# Go to opt
cd /opt

# Install Tomcat
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.65/bin/apache-tomcat-9.0.65.tar.gz

# Unzip tomcat zip folder
tar -xvzf apache-tomcat-9.0.65.tar.gz

# Change the folder name to be "tomcat"
mv apache-tomcat-9.0.65 tomcat

# comment line 21,22 in /opt/tomcat/webapps/host-manager AND manager/META-INF/context.xml
sed -i '/sameSiteCookies/a \<!--' /opt/tomcat/webapps/host-manager/META-INF/context.xml
sed -i '/sessionAttributeValueClassNameFilter/i \-->' /opt/tomcat/webapps/host-manager/META-INF/context.xml

sed -i '/sameSiteCookies/a \<!--' /opt/tomcat/webapps/manager/META-INF/context.xml
sed -i '/sessionAttributeValueClassNameFilter/i \-->' /opt/tomcat/webapps/manager/META-INF/context.xml

sed -i '/tomcat-users>/i \<role rolename="admin-gui"/>' /opt/tomcat/conf/tomcat-users.xml
sed -i '/tomcat-users>/i \<role rolename="manager-gui"/>' /opt/tomcat/conf/tomcat-users.xml
sed -i '/tomcat-users>/i \<role rolename="manager-script"/>' /opt/tomcat/conf/tomcat-users.xml
sed -i '/tomcat-users>/i \<role rolename="manager-jmx"/>' /opt/tomcat/conf/tomcat-users.xml
sed -i '/tomcat-users>/i \<role rolename="manager-status"/>' /opt/tomcat/conf/tomcat-users.xml
sed -i '/tomcat-users>/i \<user username="admin" password="s3cret" roles="admin-gui,manager-gui, manager-script, manager-jmx, manager-status"/>' /opt/tomcat/conf/tomcat-users.xml

# Create a symbolic link
ln -s /opt/tomcat/bin/startup.sh /usr/local/bin/tomcatup
ln -s /opt/tomcat/bin/shutdown.sh /usr/local/bin/tomcatdown

tomcatdown
tomcatup

# Go back to root folder
cd ~

# Generate web
mvn archetype:generate -DgroupId=vn.edu.rmit -DartifactId=myPortfolio -DarchetypeArtifactId=maven-archetype-webapp -DinteractiveMode=false

# Remove the default index.jsp file
rm -rf myPortfolio/src/main/webapp/index.jsp

# Copy all the src file in my github repo to this maven project
cp -a ~/COSC2767_Assignment1_BashScript_AWS_s3880115/src/. myPortfolio/src/main/webapp/

# Go to mySimpleProfile folder
cd myPortfolio/

# Build the web app package using maven
mvn package

# Copy the war file to Tomcat webapps folder to host
cp /root/myPortfolio/target/myPortfolio.war /opt/tomcat/webapps/

# Tell the tomcat server to go on production
tomcatup