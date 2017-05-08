class multifile {

	define multifile ($teksti) {
		file {"$title":
			ensure => file,
			content => $teksti,
		}
	}

	file {'/home/jani/testi':
		ensure => 'directory',
	}

	multifile {'/home/jani/testi/file1':
		teksti =>"This is the test file number 1\n",
	}

	multifile {'/home/jani/testi/file2':
		teksti =>"This is the test file number 2\n",
	}

	multifile {'/home/jani/testi/file3':
		teksti =>"This is the test file number 3\n",
	}

}

