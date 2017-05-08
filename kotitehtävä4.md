# Kotitehtävä 4

Tämän viikon kotitehtävänä on kirjoittaa Puppet-moduli, joka käyttää Defined types määrittelyjä.

Kone: Asus Notebook R510Z

## Defined types

Defined types tarkoittaa valmiiksi määriteltyjä konfiguraatio-objekteja,joita voidaan käyttää silloin, kun samalla kohteella tehdään useita samankaltaisia asetuksia.

Tarkoituksenani oli ensin kirjoittaa moduli, jonka avulla voi luoda monia uusia käyttäjiä. Katsoessani netistä ohjeita tulin kuitenkin siihen tulokseen, etten ymmärtänyt asioista tarpeeksi, joten tässä kotitehtävässä päädyin kokeilemaan yksinkertaista ratkaisua, jossa luodaan useita tiedostoja ja kirjoitetaan niihin erilaista sisältöä.

## Modulin rakenne

Käytin samaa konetta kuin aikaisemmissakin kotitehtävissä, joten puppet ja git olivat valmiiksi asennettuja. Aloitiin suoraan luomalla uuden modulin multifile ja manifests-kansion, jonne loin tiedoston init.pp.

    mkdir multifile
    mkdir manifests
    sudo nano init.pp
    
Tiedoston sisällöksi kirjoitin seuraavaa:

![image of init](https://github.com/JaniLjungberg/puppetgit/blob/master/images/4-1.png)

Sitten koitin ajaa tiedoston komennolla:

    sudo puppet apply --modulepath /home/jani/puppetgit/modules/ -e 'class {multifile:}'
    
En saanut virheilmoituksia.

![image of init](https://github.com/JaniLjungberg/puppetgit/blob/master/images/4-2.png)

Lopuksi kävin tarkistamassa olivatko tiedostot ja kansio jotka loin olemassa.

![image of init](https://github.com/JaniLjungberg/puppetgit/blob/master/images/4-3.png)

Kuten näkyy tiedostot ja kansio oli luoto ja tiedostojen sisällöksi oli tullut teksti nimisen muuttujan sisältö.

Tehtävän tekemiseen ei kulunut kuin muutama tunti. Jatkossa kun tarkoituksena olisi kirjoittaa oma Puppet-moduli kurssin päätteeksi, sain tästä tehtävästä hyviä ideoita siitä, mitä haluaisin silloin toteuttaa. Tehtävä löytyy Githubin modules kansiosta.










  
  

