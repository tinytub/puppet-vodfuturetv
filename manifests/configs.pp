# Class: vodfuturetv::modify
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
		source => "puppet://$puppetserver/modules/vodfuturetv/sysctl",
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
		file { "/etc/rc.local":
			ensure => file,
			owner => "root",
			group => "root",
			mode => "644",
	        content => template("vodfuturetv/rc.local.erb"),
	        require => [File["$mount_dirs1"], File["$mount_dirs2"], Service["portmap"]],
		}
	}
	rclocal { "rc.local":
	lip => $vodfuturetv::localip
	gw => $vodfuturetv::gateway
	wcip => $vodfuturetv::webclientip

	}

	$mount_dirs1 = ["/export/", "/export/home0/", "/export/home/", "/export/home0/docs/", "/export/home0/docs/flv/",
					"/export/home0/docs/flv/flash/", "/export/home0/docs/flv/flash/icntv/", "/export/home0/docs/flv/flash/icntv/data/",
					"/export/home0/docs/flv/flash/icntv/data/ysten", "/export/home0/docs/flv/flash/icntv/data1" ]
	$mount_dirs2 = ["/export/home0/webserver/", "/export/home0/webserver/nginx", "/export/home/webserver",]
	
	file { "$mount_dirs1":
		ensure => "directory",
		owner => "root",
		group => "root",
		mode => 750,
		}
	file { "$mount_dirs2":
		ensure => "directory",
		owner => "webserver",
		group => "webserver",
		mode => 750,
		}
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
            content => template("network/ifctg-lo0.erb")
		}
	}
	ifctglo0 {ifctg-lo0:
		l0ip => $vodfuturetv::lo0ip,

	}



}