class vodfuturetv::cron {
	cron { "ntpdate":
	command => "/usr/sbin/ntpdate 192.168.105.41",
	user => root,
	hour => 0,
	minute => 31
	}
        cron { "nginx killstop":
        command => "/export/home0/webserver/nginx/sbin/killstop &",
        user => root,
        hour => 6,
        minute => 20
        }
        cron { "zabbix":
        command => "/bin/sh /etc/zabbix/RsyncConfig.sh",
        user => root,
        hour => "*/1",
        minute =>8
        }
        cron { "logs updata":
        command => "/root/ftp.sh &",
        user => root,
        hour => "8",
        minute => inline_template("<%= hostname.hash.abs % 60 %>")
        }
}