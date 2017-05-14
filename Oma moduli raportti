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


## Yhden käyttäjän luominen



