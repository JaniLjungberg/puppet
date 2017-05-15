class users {

	include jani-user
	include tero-user
	}

node "puppetclient" {
	include apache2
	include ssh-portti
	inlude users
}
