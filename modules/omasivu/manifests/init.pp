class omasivu {

	exec {"apt-get update":
		command => "/usr/bin/apt-get update",
	}

	package {'apache2':
		ensure => 'installed',
		allowcdrom => true,
	}

	service {'apache2':
		ensure => 'running',
		enable => 'true',
		require => Package["apache2"],
	}

	file {'/home/jani/kotisivu':
		ensure => 'directory',
	}

	
	file {'/home/jani/kotisivu/index.html':
		content => template("omasivu/index.html"),
	}

	file {'/etc/apache2/sites-available/omasivu.conf':
		content => template("omasivu/omasivu.conf"),
		require => Package['apache2'],
		notify => Service['apache2'],
	}

	file {'/etc/apache2/sites-enabled/omasivu.conf':
		ensure => 'link',
		target => '/etc/apache2/sites-available/omasivu.conf',
		require => Package["apache2"],
		notify => Service["apache2"],
	}

	file {'/etc/apache2/sites-enabled/000-default.conf':
		ensure => 'absent',
		notify => Service["apache2"],
	}

}
