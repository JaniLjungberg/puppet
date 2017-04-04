class apache {
	package {'apache2':
		ensure => 'installed',
	}
	file {'/var/www/html/index.html':
		content => 'Asentaa apachen'
	}
}
