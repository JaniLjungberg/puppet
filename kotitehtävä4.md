## Kotitehtävä 4

Tämän viikon kotitehtävänä on kirjoittaa Puppet-moduli, joka käyttää Defined types määrittelyjä.

Kone: Asus Notebook R510Z

## Defined types

Defined types tarkoittaa valmiiksi määriteltyjä konfiguraatio-objekteja,joita voidaan käyttää silloin, kun samalla kohteella tehdään useita samankaltaisia asetuksia.

Tarkoituksenani oli ensin kirjoittaa moduli, jonka avulla voi luoda monia uusia käyttäjiä. Katsoessani netistä ohjeita tulin kuitenkin siihen tulokseen, etten ymmärtänyt asioista tarpeeksi, joten tässä kotitehtävässä päädyin kokeilemaan yksinkertaista ratkaisua, jossa luodaan useita tiedostoja ja kirjoitetaan niihin erilaista sisältöä.

# Modulin rakenne

Käytin samaa konetta kuin aikaisemmissakin kotitehtävissä, joten puppet ja git olivat valmiiksi asennettuja. Aloitiin suoraan luomalla uuden modulin multifile ja manifests-kansion, jonne loin tiedoston init.pp.

  mkdir multifile
  mkdir manifests
  sudo nano init.pp
  
  

