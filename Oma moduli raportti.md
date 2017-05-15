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

comment: kommenttikenttä käyttäjälle
home: kotikansion sijainti
shell: login shell
UID: User ID, käyttäjän oma tunniste. Näiden suunnittelun tulisi noudattaa selkeää logiikkaa.
GID: Groud ID, jokainen käyttäjä kuuluu oletuksena omaan ryhmäänsä, joka nimetään tilin mukaaan.
Manage home: Luo käyttäjälle kotihakemiston, mutta vain jos muualla asetettu ensure =>present
Password: Salasanan hash, joka on noudettu /etc/shadow tiedostosta komennolla cat /etc/shadow, yksinkertaiset lainausmerkit!
Groups: Ryhmät joissa admin on jäseninä. Voidaan selvittää komennolla $groups jani

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

Aloitetaan luomalla uusi SSH-avainpari.

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

## Käyttäjäoikeuksien hallinta

Haluamme myös keskittää käyttäjäoikeudet konekohtaisesti ja tämä onnistuisi muokkaamalla 










  
    



