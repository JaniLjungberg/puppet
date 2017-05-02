class apache2 {

	package {'apache2':
		ensure => installed,
		allowcdrom => true,
	}

	file {'/etc/apache2/apache2.conf':
		content => template("apache2/apache2.conf"),
		require => Package["apache2"],
		notify => Service["apache2"],
	}

	service {'apache2':
		ensure => running,
		enable => true,
		require => Package['apache2'],
	}

}




