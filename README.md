# Disk Space Monitoring Script

## Overview
This is a simple **bash script** that monitors disk usage on a Linux system.  
It's designed to send an email alert when disk usage exceeds a specified threshold, providing a clear and easy-to-read **HTML report**.

---

## Features
- **Customizable Threshold**: Easily adjust the `THRESHOLD` variable to set the disk usage percentage that triggers a warning email.  
- **HTML Email Report**: Generates a formatted HTML email, making the report easy to read and digest.  
- **Clear Alerts**: Sends an **"Alert"** email for critical usage (above the threshold) and an **"All Good"** email when usage is healthy.  
- **Excludes Unnecessary Filesystems**: Uses `df -H -x tmpfs -x devtmpfs` to exclude temporary and device-related filesystems, ensuring you only monitor relevant disk partitions.  

---

## Prerequisites
- A Linux-based system with `df`, `awk`, `sort`, `tail`, and `mail` commands installed.  
- The `mail` command (part of **mailutils** or **bsd-mailx** packages) configured to send emails.
- **Postfix** (or another MTA) must be installed and configured.

## ⚠️ Note
Before running this script, ensure that a **mail transfer agent (MTA)** such as **Postfix** is installed and properly configured on your system.  
The script relies on the `mail` command to send email alerts, and without Postfix (or another MTA), the emails will not be delivered.   

---

### Install Postfix
➡️ **You need sudo/root access** to install and configure Postfix.

**Debian/Ubuntu:**
```bash
sudo apt-get update
sudo apt-get install postfix mailutils -y
```

 **CentOS/RHEL**
 ```
sudo yum install postfix mailx -y
sudo systemctl enable postfix
sudo systemctl start postfix
```
### Quick Postfix Configuration for External SMTP (Gmail)
i► Open the Postfix configuration file:
  ```
  sudo vim /etc/postfix/main.cf
  ```
ii► Add/modify the following lines at the bottom:
```
relayhost = [smtp.gmail.com]:587
mtp_use_tls = yes
smtp_sasl_auth_enable = yes
smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
smtp_sasl_security_options = noanonymous
smtp_sasl_tls_security_options = noanonymous
```
iii► Create the password file:
```
sudo nano /etc/postfix/sasl_passwd
```
iv► Add your Gmail credentials:
```
[smtp.gmail.com]:587 your-email@gmail.com:your-app-password
```
***⚠️ For Gmail, you must generate an App Password (from your `Google Account → Security → App Passwords`)***

v► Secure the file and build the hash:
```
sudo chmod 600 /etc/postfix/sasl_passwd
sudo postmap /etc/postfix/sasl_passwd
```

vi► Restart Postfix:
```
sudo systemctl restart postfix
```

vii► Test email delivery:
```
echo "Test Email from Postfix" | mail -s "Postfix Test" youremail@example.com
```
---

## Usage

### 1. Make it Executable
```bash
chmod +x disk_monitor.sh
```
### 2. Run Manually (for testing)
```
./disk_monitor.sh
```
### 3. Automate with Cron
Run script every Monday at 10:00 AM
  #### i. Create/Edit Cron Jobs
     ```
     crontab -e
     ```
This opens your user’s cron table in the default editor. Add one or both of these:

**Daily at 6:00 AM**
```
0 6 * * * /path/to/your/disk_monitor.sh
```

**Weekly on Monday at 10:00 AM**
```
0 10 * * 1 /path/to/your/disk_monitor.sh
```

Replace `/path/to/your/disk_monitor.sh` with the actual path to your script.

#### ii. Show Current Cron Jobs
```
crontab -l
```
then run `./disk_monitor.sh` again
