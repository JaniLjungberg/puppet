class banshee {
	file { '/etc/puppet/banshee':
		content => "Tämä moduli asentaa Banshee video-ohjelman.\n"
		}

	package { 'banshee':
		ensure => installed	
		}
}