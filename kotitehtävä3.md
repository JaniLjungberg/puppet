## Kotitehtävä 3

Tämän viikon kotitehtävänä on:

* SSHD. Konfiguroi SSH uuteen porttiin muppetilla.
* Modulit Gittiin. Laita modulisi versionhallintaan niin, niin että saat ne helposti ajettua uudella live-USB työpöydällä.
* Etusivu uusiksi. Vaihda Apachen oletusweppisivu Puppetilla.

Kone: Asus Notebook R510Z, Ubuntu 14.06

## Konfiguroi SSH uuteen porttiin muppetilla.

Aloitin tehtävän tekemisen kirjoittamalla uuden puppet-modulin.

Sijoitin modulin kotihakemistossani sijaitsevaan moduli-kansioon ja annoin sille nimeksi sshportti.

Lisäksi loin sille kansiot manifests ja templates.

    mkdir sshportti
    cd sshportti
    mkdir manifests
    mkdir templates
    
Manifests kansioon loin tiedoston init.pp

Tänne kirjoitin sisällön, joka ensin päivittää apt-getin ja sitten asentaa ssh:n koneelle.

![image of init](https://github.com/JaniLjungberg/puppetgit/blob/master/images/3-1.png)

Kokeilin ensin toimiiko ssh asennus ja apt-get.

![image of init](https://github.com/JaniLjungberg/puppetgit/blob/master/images/3-2.png)

SSH oli jo valmiiksi asennettu ja apt-get toimi kuten pitikin. 

Seuraavaksi tarkoituksena oli saada SSH kuuntelemaan jotain muuta porttia, kuin oletuksena oleva portti 22.

Tämä tapahtuu muokkaamalla kansiossa /etc/ssh/ löytyvää tiedostoa sshd_config

Kopion tiedoston templates-kansioon, jotta voisin käyttää sitä pohjana puppetin file-osiossa.

    sudo cp /etc/ssh/sshd_config /home/jani/puppetgit/modules/sshportti/templates/
     
Editoin tiedoston sisällön ja vaihdoin porttinumeroksi 2222

    nano sshd_config
    
![image of init](https://github.com/JaniLjungberg/puppetgit/blob/master/images/3-3.png)

Palasin muokkaamaan init.pp tiedostoa. 

![image of init](https://github.com/JaniLjungberg/puppetgit/blob/master/images/3-4.png)

Lisäsin tiedostoon kohdat file, joka asentaa templaten kansioon /etc/ssh/ ja lisäksi käynnistin ssh palvelun uudelleen.

Tallensin ja kokeilin miten pelittää.

![image of init](https://github.com/JaniLjungberg/puppetgit/blob/master/images/3-5.png)

Ei virheilmoituksia ja kaikki näytti toimivan!

Kokeilin vielä olivatko asetukseni onnistuneet.

    sudo netstat -tunlp |grep ssh
    
SSH oli nyt portissa 2222, kuten olin asettanutkin.

![image of init](https://github.com/JaniLjungberg/puppetgit/blob/master/images/3-6.png)

    








     
