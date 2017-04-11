class kotisivu {

	package {'apache2':
		ensure => 'installed',
	}

	Service {'apache2':
                ensure => 'running',
                enable => 'true',
                require => Package['apache2'],
        }


	file {'/etc/apache2/mods-available/kotisivu.conf':
		content => template("kotisivu/kotisivu.conf"),
		require => Package["apache2"],
		notify => Service["apache2"],
	}

	file {'/etc/apache2/mods-enabled/kotisivu.conf':
                ensure => 'link',
		target => '/etc/apache2/mods-available/kotisivu.conf',
                require => Package["apache2"],
                notify => Service["apache2"],
        }

	


}

