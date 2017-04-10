# Kotitehtävä 2

Asenna ja konfiguroi jokin palvelin package-file-service -tyyliin Puppetilla.

Julkaise kotitehtävä GitHubissa ja kirjoita raportti Mahttps://github.com/JaniLjungberg/puppetgitrkDownilla.

## Ympäristö:

Asus Notebook R510Z, Ubuntu 16.04

## Apache2

Päätin, että yritän tässä tehtävässä asentaa Apache2 palvelimen ja vaihtaa asetuksia niin, että palvelimen timeout on 60, eikä 300, kuten oletusasetuksena.

## Modulin luominen

Aloitin luomalla uuden modulin kotihakemistoni github-kansioon modules.

	mkdir -p modules/apache2/manifests
	nano modules/apache2/manifests/init.pp

Tiedoston sisällöksi kirjoitin.

![image of init](https://github.com/JaniLjungberg/puppetgit/blob/master/images/2-3.png)

Tällä modulilla apachen pitäisi siis asentua ja käynnistyä. Päätin kokeilla miten toimii.

	sudo puppet apply --modulepath /home/jani/puppetgit/modules/ -e 'class{"apache2":}'
	
Komento meni läpi ja Apache asentui ja oli toiminnassa.

![image of init](https://github.com/JaniLjungberg/puppetgit/blob/master/images/2-4.png)

![image of init](https://github.com/JaniLjungberg/puppetgit/blob/master/images/2-5.png)

Seuraavaksi tarkoitus olisi muokata apachen asetustiedostoa erinäköiseksi.

## Apachen asetukset

Seuraavaksi olisi tarkoitus muokata Apachen asetustiedostoa niin, että se avaisi default-sivun asemasta jonkin toisen tiedoston.
Tämä tapahtuu luomalla apachen asetustiedostosta template.

Aloitin siirtymällä kansioon modules/apache2/ ja luomalla sinne kansion templates. Sitten kopioin apachen asetustiedoston kansioon.

	cd modules/apache2
	mkdir templates
	cp /etc/apache2/apache2.conf templates/

Seuraavaksi tein muutoksia apachen asetustiedostoon template kansiossa. 

![image of init](https://github.com/JaniLjungberg/puppetgit/blob/master/images/timeout.png)

Asetus Timeout määrittelee kauan palvelin käyttää maksimissaan aikaa kunkin pyynnön käsittelyyn. Vaihdoin oletusasetuksen 300 sekuntia 60 sekuntiin ja tallensin tiedoston.

Seuraavaksi piti editoida modulini päivittämään Apachen asetukset. 

![image of init](https://github.com/JaniLjungberg/puppetgit/blob/master/images/uusimoduli.png)


Lopuksi kokeilin ajaa modulini uudestaan.

![image of init](https://github.com/JaniLjungberg/puppetgit/blob/master/images/result.png)


Kaikki näytti toimivan.


Lähteenä käytetty omia vanhoja kotitehtäviäni ja Tero Karvisen ohjeistusta osoitteissa:

https://janipuppet.wordpress.com/

http://terokarvinen.com/2013/ssh-server-puppet-module-for-ubuntu-12-04


	




