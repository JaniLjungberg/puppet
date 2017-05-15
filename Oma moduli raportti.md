# Käyttäjien hallinta Muppetin avulla

Tehtävä: Lopputehtävänä on kirjoittaa oma Puppet-moduli ja raportoida tehtävä. Koska olen edellisissä tehtävissä käsitellyt
jo tyypillisiä package-file-service -moduleja, ajattelin kokeilla miten käyttäjien, ryhmien ja kotihakemistojen luonti 
onnistuu Puppetin avulla. Samalla viimeisessä tehtävässä käsitelty defined types jäi hieman pinnalliseksi, joten koitan 
saada tähän tehtävään sen mukaan luomalla lopuksi useita käyttäjiä muuttujia hyödyntäen. Lopullinen tehtävä tulee sisältämään
useamman kuin yhden modulin.

Kone: Asus Notebook R510Z

## Teoriaa

Yleisesti ajateltuna käyttäjien, ryhmien ja kotikansioiden asentaminen ja hallinnointi Puppetilla on järkevää tilanteessa, jossa
työskennellään suhteellisen pienessä organisaatiossa. Kun joudutaan hallinnoimaan suurempia, satojen tai tuhansien käyttäjien
kokonaisuuksia, saattaa olla hyödyllistä ottaa käyttöön jokin keskitetty hallintajärjestelmä, kuten vaikkapa LDAP, eli Lightweight
Directory Access Protocol. Se on pohjana useissa käyttäjähallintaan käytetyissä ohjelmistoissa, kuten Microsoftin Active 
directory tai Apache Directory Server.

Jotta käyttäjät saavat tunnuksensa käyttöön jokaisella verkon koneella, on käyttäjä- ja ryhmäasetukset sisältävät modulit
ajettava erikseen konekohtaisesti. Kannattaa myös pitää mielessä, että jokaisen käyttäjän oikeudet voivat vaihdella sen mukaan, 
mihin järjestelmään kirjaudutaan sisään. Eri koneille voidaan siis samalle käyttäjälle määritellä erilaisia oikeuksia. Näin 
käyttäjät voivat kirjautua omilla tunnuksillaan kaikille verkon koneille. Käyttäjätiliasetuksia tehdessämme samalla kokeilemme
myös SSH-avainten hallinnointia. 

Jos käyttäjiä on vain vähän, saattaa käyttäjän asetukset tekevät modulin pitää erillään. Näin monimutkaisia ja yksinkertaisia
asetuksia sisältävät modulit voivat olla helpommin hallittavissa, kuin yksi jättimäinen tiedosto, joka tekee kaiken kerralla. Näin
yksittäiset asetukset voidaan ottaa käyttöön konekohtaisesti ja jos jollekin kohteelle on asennettava kaikki käyttäjätilit,
voidaan erilliset modulit vain yhdistää yhden classin sisään.

Aloitin kuitenkin tarkistamalla millaisia käyttäjätilejä koneellani oli komennolla:

    awk -F: '/\/home/ {printf "%s:%s\n",$1,$3}' /etc/passwd
    
Vanhoista tehtävistä koneelta löytyi sekalainen joukko käyttäjätilejä, jotka poistin komennolla:

    sudo deluser username


## Yhden käyttäjän luominen
Aloitamme modulien kirjoittamisen modulilla, joka luo yhden käyttäjätilin.

Normaaliin tyyliin loin ensin kansion, jonne uusi moduli sijoitetaan.

    mkdir user-jani
    mkdir manifests
    
Seuraavksi luotiin init.pp -tiedosto, jonne käyttäjän luomiseen tarkoitettu koodi sijoitetaan.

![image of init](https://github.com/JaniLjungberg/puppetgit/blob/master/images/user1.png)

Käyttäjän luonnissa annoimme siis seuraavat parametrit:

*comment: kommenttikenttä käyttäjälle

*home: kotikansion sijainti

*shell: login shell

*UID: User ID, käyttäjän oma tunniste. Näiden suunnittelun tulisi noudattaa selkeää logiikkaa.

*GID: Groud ID, jokainen käyttäjä kuuluu oletuksena omaan ryhmäänsä, joka nimetään tilin mukaaan.

*Manage home: Luo käyttäjälle kotihakemiston, mutta vain jos muualla asetettu ensure =>present

*Password: Salasanan hash, joka on noudettu /etc/shadow tiedostosta komennolla cat /etc/shadow, yksinkertaiset lainausmerkit!

*Groups: Ryhmät joissa admin on jäseninä. Voidaan selvittää komennolla $groups jani

Seuraavaksi kotin ajaa modulin. Pieniä virheitä oli kuitenkin monia, jotka on tosin korjattu jo yllä olevaan kuvaan.

Nyt loimme siis tavallaan kopion pääkäyttäjä ja administraattoritilistä jani, jota voisimme käyttää myös muiden koneiden kanssa.
En kuitenkaan uskaltanut laittaa modulia kirjoittamaan oikean käyttäjätili janin päälle, sillä en ollut varma 
esimerkiksi miten salasana-asetukset kopioituisivat. Aluksi myös GUI ja GID olivat arvolla 1000, mutta koska alkuperäinen 
käyttäjä jani oli jo sillä paikalla, ei kopiota voitu luoda niillä arvoilla.

![image of init](https://github.com/JaniLjungberg/puppetgit/blob/master/images/user2.png)

Kokeilin vielä kirjautua huvin vuoksi järjestelmään jani2 käyttäjällä. Kirjautuminen onnistui.

## SSH avaimien hallinta

Yksi hallinnointia helpottava toimenpide on SSH avaimien luonti ja käyttöönotto client-koneilla. Kokeilen aluksi miten 
tämä onnistuu ja voinko testata tämän toimivuutta ilman, että luon oikean master-client -ympäristön labraluokkaan. 

Tarkoituksena on siis luoda ssh -avainpari ja kopioida julkinen avain clientin käyttäjän authorized_keys tiedostoon kansioon
/home/username/.ssh/authorized_keys

Aloitetaan luomalla uusi SSH-avainpari komennolla:

    sudo ssh-keygen

![image of init](https://github.com/JaniLjungberg/puppetgit/blob/master/images/user3.png)

Sitten palaamme muokkaamaan aikaisempaa modulia, jonne lisäämme käyttäjäkohtaisen salausavaimen.

![image of init](https://github.com/JaniLjungberg/puppetgit/blob/master/images/user4.png)

Seuraavaksi ajoin modulin vain nähdäkseni mitä tapahtuu.

![image of init](https://github.com/JaniLjungberg/puppetgit/blob/master/images/user5.png)

Nähdäkseni avaimen lisääminen onnistui, mutta voimme tarkistaa löytyykö se oikeasta paikasta. Testausta varten olikin
hyvä, että olimme luoneet käyttäjän jani sen sijaan, että olisimme käyttäneet oikeaa root-tiliä. Nyt pystyimme kirjautumaan 
toisella käyttäjällä ja tarkistaa, olivatko salausavaimemme ilmestyneet piilotettuun kansioon .ssh, joka löytyy 
kotihakemistostamme.

![image of init](https://github.com/JaniLjungberg/puppetgit/blob/master/images/user6.png)

Kuten huomaamme on puppet luonut tarvittavat avaimet.

## Useiden käyttäjien lisääminen ja defined types

Kun tarkastelemme kirjoittamaamme modulia, huomaamme, että siinä on paljon toistoa. Voimme sieventää sitä 
ottamalla käyttöön defined types -määritellyt muuttujat.

Kirjoitamme nyt modulin siistimpään muotoon niin, että sen avulla voidaan lisätä helpommin useitakin käyttäjiä.

Luomme uuden moduli-kansion, jonne luonne uuden manifests-kansion ja init.pp tiedoston.

Sen sisällöksi tulee seuraavaa.

![image of init](https://github.com/JaniLjungberg/puppetgit/blob/master/images/user7.png)

Ylimmällä rivillä on siis defined type -määrittlyjä ja listaus muuttujista joita moduliin tuodaan. Käytännössä kun uutta
käyttäjää luodaan, tarvitaan siis vain kuusi erilaista muuttujaa, jotka ovat nimi, uid, salasana, ryhmät, ssh-avaimen tyyppi ja julkinen avain.

Lievästi vaikemmin hahmotettava voi olla alussa oleva rivi:

$username = $title

Tässä username muuttuja saa arvokseen title, jota ei ole kuitenkaan löydettävissä tästä tiedostosta. Se määritellään kuitenkin muualla, eli luokassa joka kutsuu tätä modulia. Title on aina luokan alussa ensimmäisellä rivillä ja sitä seuraa kaksoispiste.

Nyt uusien käyttäjien luomisen tulisi onnistua kirjoittamalla lyhyempiä, vai kuusi arvoa sisältäviä luokkia.

Kokeilemme ja luomme uuden käyttäjän luovan modulin. Uusien käyttäjien tekemisen tulisi nyt onnistua helpommin 
seuraavan kaltaisen modulin avulla.

![image of init](https://github.com/JaniLjungberg/puppetgit/blob/master/images/user8.png)

Kokeilin uuden tero käyttäjän luomista. Käyttäjän ja ssh-avaimen luonti onnistui kuten odotettua.

![image of init](https://github.com/JaniLjungberg/puppetgit/blob/master/images/user9.png)

 ## Yhteenvetona
 
 Tehtävä jää nyt kyllä pahasti kesken. Tarkoituksena oli vielä hallita käyttäjien oikeuksia, mutta en saanut edes tätä
 vaihetta kunnolla loppuun tai testattua. Havainnoin nyt, miten visioin modulien toimintaa ja mitä vaaditaan, jotta 
 ssh -autentikointi ilman salasanaa käyttäen suojausavaimia saataisiin toimimaan. 
 
 Lisäksi hahmottelen mitä site.pp -tiedoston sisällön pitäisi näyttää, jotta modulit tulisivat hyödynnettyä.
 
 Aluksi tarvitaan tyypillinen package-file-service -rakenne, jolla ssh asennetaan, sitten editoidaan sen asetuksia 
 ja lopulta potkaistaan palvelua sen uudelleen käynnistämiseksi. Idea on tarkalleen sama kuin aikaisemmassa tehtävässä,     jossa ssh -portti vaihdettiin toiseen. Jotta kirjautuminen salasanalla voitaisiin kytkjeä pois päältä, pitää konfiguraatiotiedoston /etc/ssh/sshd_config kohta:
 
 #passwordAuthentication yes
 
 Muuttaa niin, että siinä lukee:
 
 passwordAuthentication no
 
 Voisimme periaatteessa käyttää täysin vanhaa ssh-portti modulia ja editoida sen template-kansiota niin, että vaihdetaan
 portti takaisin 22:een ja lisätään ylläoleva passwordAuthentication kohta.
 
 Modulin sisältö on seuraava:
 
 ![image of init](https://github.com/JaniLjungberg/puppetgit/blob/master/images/user10.png)
 
 Lopuksi tarvittaisiin vielä site.pp -tiedosto, jossa ensin luodaan uudet käyttäjät ja kopioidaan julkiset salausavaimet
 kotikansion tiedostoon ja sitten editoidaan ssh-asetustiedostoa, jotta salasanakirjautuminen voidaan estää.
 
 Site.pp tiedosto tulee kansiooon /etc/puppet/manifests/site.pp
 
 Tässä testiskenaariossa sen sisältö olisi jotakuinkin tälläinen.
 
  ![image of init](https://github.com/JaniLjungberg/puppetgit/blob/master/images/user11.png)
  
  Tehtävä jäi tosi pahasti kesken ja jäi harmittamaan, kun en ehtinyt testata koko hommaa kunnolla. 
  
  Aikaa kului kuitenkin aikalailla ja molemmat käyttäjiä lisäävät puppet-modulit toimivat kuten olin ajatellutkin.
  Turhaa aikaa kului kuitenkin kun yritin saada ssh -yhteyttä toimimaan pelkillä salausavaimilla.
  
 
 
 ## Lähteet:
  
  http://manuel.kiessling.net/2014/03/26/building-manageable-server-infrastructures-with-puppet-part-4/
  
  /etc/puppet/manifests/site.pp
  
  https://www.digitalocean.com/community/tutorials/how-to-add-and-delete-users-on-ubuntu-16-04
  
  http://www.hostingadvice.com/how-to/linux-add-user-to-group/
  
  https://docs.puppet.com/puppet/4.10/quick_start_user_group.html
  
  https://docs.puppet.com/puppet/latest/type.html#user-attributes
 
 
 
 
 
 











  
    



