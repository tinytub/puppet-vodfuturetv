# Class: vodfuturetv::configs
#
#
class vodfuturetv::configs {
	user{"webserver":
		ensure     => "present",
		managehome => true,
	}
	file { "/etc/sysctl.conf":
		ensure => file,
		owner => "root",
		group => "root",
		mode => "644",
		source => "puppet://$puppetserver/modules/vodfuturetv/sysctl.conf",
		notify => Exec["sysctl load"],
	}
	exec {"sysctl load":
	command => "sysctl -p",
	user => root,
	path => "/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin",
	subscribe => File["/etc/sysctl.conf"],
	refreshonly => true ,
	}
	# Define: rclocal
	# Parameters:
	# arguments
	#
	define rclocal ( $lip, $gw, $wcip) {
		file { "/etc/rc.d/rc.local":
			ensure => file,
			owner => "root",
			group => "root",
			mode => "644",
	        content => template("vodfuturetv/rc.local.erb"),
	        #require => [File["/export/home0/docs/flv/flash/icntv/data/ysten"], File["/export/home/webserver"], File["/export/home0/webserver/"], Service["portmap"]],
	        require => Service["portmap"],
		}
	}
	rclocal { "rc.local":
	lip => $vodfuturetv::localip,
	gw => $vodfuturetv::gateway,
	wcip => $vodfuturetv::webclientip,

	}

	#$mount_dirs1 = ["/export/", "/export/home0/", "/export/home/", "/export/home0/docs/", "/export/home0/docs/flv/",
	#		"/export/home0/docs/flv/flash/", "/export/home0/docs/flv/flash/icntv/", "/export/home0/docs/flv/flash/icntv/data/",
#			"/export/home0/docs/flv/flash/icntv/data/ysten", "/export/home0/docs/flv/flash/icntv/data1",
#			"/export/home0/webserver/", "/export/home0/webserver/nginx", "/export/home/webserver", ]
	$mount_dirs2 = ["/export/home0/webserver/", "/export/home0/webserver/nginx", "/export/home/webserver"]
	
	#file { "$mount_dirs1":
#		ensure => "directory",
##		owner => "root",
#		group => "root",
#		mode => 750,
#		before => File["/etc/rc.local"],
#		}
	exec { "create_directory1":
		command => "/bin/mkdir -p /export/home0/docs/flv/flash/icntv/data/ysten",
		creates => "/export/home0/docs/flv/flash/icntv/data/ysten";
		"create_directory2":
		command => "/bin/mkdir -p /export/home0/docs/flv/flash/icntv/data1",
                creates => "/export/home0/docs/flv/flash/icntv/data1";
		"create_directory3":
                command => "/bin/mkdir -p /export/home0/webserver/nginx",
                creates => "/export/home0/webserver/nginx";
		"create_directory4":
                command => "/bin/mkdir -p /export/home/webserver",
                creates => "/export/home/webserver",
	}
	#file { "$mount_dirs2":
	file { ["/export/home0/webserver/","/export/home0/webserver/nginx","/export/home/webserver"]:
		ensure => "directory",
		owner => "webserver",
		group => "webserver",
		mode => 750,
		before => File["/etc/rc.d/rc.local"],
		require => [Exec["create_directory3"], Exec["create_directory4"]]
		}
	# Define: ifctglo0
	# Parameters:
	# arguments
	#
	define ifctglo0 ( $l0ip ) {
		file { "/etc/sysconfig/network-scripts/ifcfg-lo:0":
            owner => root,
            group => root,
            mode => 644,
            content => template("vodfuturetv/ifcfg-lo0.erb")
		}
	}
	ifctglo0 {ifctg-lo0:
		l0ip => $vodfuturetv::lo0ip,

	}

}