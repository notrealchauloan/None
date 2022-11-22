# COSC2767_Assignment1_BashScript_AWS_s3880115
- RMIT University Vietnam
- Course: COSC2767 Systems Deployment and Operations
- Semester: 2022B
- Assessment: Assignment 1
- Author: Nguyen Chau Loan
- ID: 3880115
- Created  date: 01/08/2022
- Last modified: 03/08/2022 
- Acknowledgement: to Codinglabweb.com https://www.codinglabweb.com/2021/03/responsive-portfolio-website-using-html-css$

## Command Explanations
> # Initialization

```
# Navigate to key locations
PS C:\Users\Admin> cd .\.ssh\keys

# Connect to instance
PS C:\Users\Admin\.ssh\keys> ssh -i "s3880115_key.pem" ec2-user@ec2-34-202-161-134.compute-1.amazonaws.com

# Install Git and Git credentials
sudo yum install git -y
git config --global user.email "notrealchauloan@gmail.com"
git config --global user.name "notrealchauloan"

# Sudo as root user
sudo su -

# Pull code from Git
git clone https://github.com/notrealchauloan/COSC2767_Assignment1_BashScript_AWS_s3880115

# Enter the following for username, no need for entering password
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

# Run Bash Script
sh COSC2767_Assignment1_BashScript_AWS_s3880115/bashscript/asm1bash.sh

```
> # Bash Script
> ## Install Java
```
sudo amazon-linux-extras install java-openjdk11 -y
```

> ## Install and modify Maven
> #### Installation
```
# Go to opt directory
cd /opt

# Download binary distribution of Maven
wget https://dlcdn.apache.org/maven/maven-3/3.8.6/binaries/apache-maven-3.8.6-bin.tar.gz

# Extract the compressed file
tar -xvzf apache-maven-3.8.6-bin.tar.gz

# Rename folder
mv apache-maven-3.8.6 maven
```

> #### Modification (mvn)
```
# Back to home
cd ~

# Append a new text line right after the line that contains 'programs' in bash_profile file
sed -i '/programs/a \JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.13.0.8-1.amzn2.0.3.x86_64' .bash_profile
sed -i '/programs/a \M2=/opt/maven/bin' .bash_profile
sed -i '/programs/a \M2_HOME=/opt/maven' .bash_profile

# Append this string (:$JAVA ... $M2) at the END of the line that contains 'PATH=' in bash_profile file
sed -i '/PATH=/ s/$/:$JAVA_HOME:$M2_HOME:$M2/' .bash_profile

cd ~

# Apply new changes to bash_profile
source ~/.bash_profile
```

> ## Install and modify Tomcat
> #### Installation
```
# Go to opt directory
cd /opt

# Install Tomcat
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.65/bin/apache-tomcat-9.0.65.tar.gz

# Unzip tomcat zip folder
tar -xvzf apache-tomcat-9.0.65.tar.gz

# Change the folder name to be "tomcat"
mv apache-tomcat-9.0.65 tomcat
```

> #### Modification (tomcatup, tomcatdown)
```
# comment by adding '<!--' after the line that contain 'sameSiteCookies' and '-->' before the line that contain 'sessionAttributeValueClassNameFilter' in /opt/tomcat/webapps/host-manager/META-INF/context.xml
sed -i '/sameSiteCookies/a \<!--' /opt/tomcat/webapps/host-manager/META-INF/context.xml
sed -i '/sessionAttributeValueClassNameFilter/i \-->' /opt/tomcat/webapps/host-manager/META-INF/context.xml

# comment by adding '<!--' after the line that contain 'sameSiteCookies' and '-->' before the line that contain 'sessionAttributeValueClassNameFilter' in /opt/tomcat/webapps/manager/META-INF/context.xml
sed -i '/sameSiteCookies/a \<!--' /opt/tomcat/webapps/manager/META-INF/context.xml
sed -i '/sessionAttributeValueClassNameFilter/i \-->' /opt/tomcat/webapps/manager/META-INF/context.xml

# Append the following string (<role ...  />) into tomcat-users.xml where there is 'tomcat-users>'
sed -i '/tomcat-users>/i \<role rolename="admin-gui"/>' /opt/tomcat/conf/tomcat-users.xml
sed -i '/tomcat-users>/i \<role rolename="manager-gui"/>' /opt/tomcat/conf/tomcat-users.xml
sed -i '/tomcat-users>/i \<role rolename="manager-script"/>' /opt/tomcat/conf/tomcat-users.xml
sed -i '/tomcat-users>/i \<role rolename="manager-jmx"/>' /opt/tomcat/conf/tomcat-users.xml
sed -i '/tomcat-users>/i \<role rolename="manager-status"/>' /opt/tomcat/conf/tomcat-users.xml
sed -i '/tomcat-users>/i \<user username="admin" password="s3cret" roles="admin-gui,manager-gui, manager-script, manager-jmx, manager-status"/>' /opt/tomcat/conf/tomcat-users.xml

ln -s /opt/tomcat/bin/startup.sh /usr/local/bin/tomcatup
ln -s /opt/tomcat/bin/shutdown.sh /usr/local/bin/tomcatdown

tomcatdown
tomcatup
```

> ## Web
```
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
```

> # See my website here
```
# Open your browser, type
54.208.104.79:8080/myPortfolio/
```

## Screenshots of Personal Profile Website
> #### Homepage contains primary information including name, sID, major, my main skill
![image](https://user-images.githubusercontent.com/75651801/183259903-a6b3ba31-8747-4728-9dbb-9f2804a784c8.png)

> #### Additional Information: My brief self introduction. You can also download my CV here
![image](https://user-images.githubusercontent.com/75651801/183259989-c2a10966-241e-4449-9cce-2a3176611b4e.png)
