# Kotitehtävä 2

Asenna ja konfiguroi jokin palvelin package-file-service -tyyliin Puppetilla.

Julkaise kotitehtävä GitHubissa ja kirjoita raportti MarkDownilla.

## Ympäristö:

Asus Notebook R510Z, Ubuntu 16.04

## Apache2

Päätin, että yritän tässä tehtävässä asentaa Apache2 palvelimen ja vaihtaa aloitussivun joksikin toiseksi.

## Modulin luominen

Aloitin luomalla uuden modulin kotihakemistoni github-kansioon modules.

	mkdir -p modules/apache2/manifests
	nano modules/apache2/manifests/init.pp

Tiedoston sisällöksi kirjoitin.

![text](images/2-1.png)
