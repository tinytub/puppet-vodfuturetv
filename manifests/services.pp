# Class: vodfuture
#
class vodfuturetv::services {
	service { "portmap":
	    enable => true,
		ensure => running,
		#hasrestart => true,
		hasstatus => true,
		#require => Class["config"],
	}

}