class sshportti {
	
	exec {"apt-get update":
		command => "/usr/bin/apt-get update",
	}

	package {'ssh':
		ensure => 'installed',
	}

	file {'/etc/ssh/sshd_config':
		content => template("sshportti/sshd_config"),
		require => Package["ssh"],
		notify => Service["ssh"],
	}

	service {'ssh':
		ensure => 'running',
		enable => 'true',
		require => Package["ssh"],
	}



}
