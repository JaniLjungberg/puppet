class jani-user {
	
	user { "jani2":
		comment => "jani ljungberg",
		home => "/home/jani2",
		shell => "/bin/bash",
		uid => 1001,
		gid => 1001,
		managehome => "true",
		password => '$6$vCceT0mO$V6hm5CkfIv0JUYLZ..SfEYFus.E03CCptxy9IU7n1tP1mh401/YkYMLa9y1Kr5nBRbU0e2DQDpKUqU/iZoHPR.',
		groups     => ["adm", "cdrom", "sudo", "dip", "plugdev", "lpadmin", "sambashare"],
	}

	group { "jani2":
		gid => 1001,
	}

	ssh_authorized_key { "ssh-key-for-jani2":
		user => "jani2",
		ensure => present,
		type => "ssh-rsa",
		key => "AAAAB3NzaC1yc2EAAAADAQABAAABAQDtGNQxzLDXEgwHMAAuxY5AMKqxIK9aInE9Zg1rvd/AdejophbmRm2pWbpLe0+g7rw/Jb1quq8n8C8cwsmPjdw4neO9Ay/6HDIkNMPxQUNTcJ+o432+ZqfwEhZZ0Asgd5Xc2IW5T5slCEG1gTsU0bqwa7q0VPWQNJs4UYbjCo3u20ZBa8p1dfl7G7phyOILAxjUVJWtdIC1dl4gWKOPgTgKxUEX5rGiVb0/MMJbAnO/npRAIDUaGOcOXhkrSIqxd1WP0wOd3bABhPqkyrwEE3fzHbY+eFPYX7BonrjyLnjis6ocDEZSiqewvy5sIMOtW6kxoJmNq3qDPJSP5Wm0ycOb",
		name => "root@laptop",
	}


}

