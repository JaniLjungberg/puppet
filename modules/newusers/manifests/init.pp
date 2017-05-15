define newusers ( $name, $uid, $password, $groups, $sshkeytype, $sshkey ) {

	$username = $title

	user { "$username":
		comment => "$name",
		home => "/home/$username",
		shell => "/bin/bash",
		uid => $uid,
		gid => $uid,
		managehome => "true",
		password => "$password",
		groups => $groups,
	}

	group { "$username":
		gid => $uid,
	}

	ssh_authorized_key { "ssh-key-for-$username":
		user => "$username",
		ensure => present,
		type => "$sshkeytype",
		key => "$sshkey",
		name => "$username",
	}
}




