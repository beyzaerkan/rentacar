# Rent A Car
## Database Management Systems Project
### Senaryo
Kullanıcıların, araçların, çalışanların, ofislerin vb. bilgilerin saklandığı, kullanıcıların kaydolabildiği, 
araba kiralayabildikleri, listeyebildikleri; adminlerin ise arabaları listeleyebildiği, ekleme, çıkarma, 
güncelleme işlemlerini yapabildiği bir araba kiralama web uygulaması.

### İş Kuralları
- Kullanıcıların isim, soyisim, mail, şifre, adres, telefon no, rol, kayıt tarihi bilgileri mevcuttur.
- Arabaların kiralama bedeli, tip, koltuk sayı, vites, fotoğraf, yakıt türü, model, marka, ofis bilgileri 
mevcuttur.
- Ofislerin isim, şehir bilgileri mevcuttur.
- Markaların isim, model bilgileri mevcuttur. 
- Kiralanan araçların gün, alış tarih, teslim tarih, müşteri, araba, ofis, ödeme bilgileri mevcuttur.
- Ödemelerin bedel, kiralama, ödeme günü bilgileri mevcuttur. 
- Kullanıcılar admin ve müşteri olmak üzere ikiye ayrılır. 
- Bir kullanıcının yalnızca bir rolü vardır. Bir rolü birden fazla kullanıcı alabilir.
- Bir müşteri birden fazla araba kiralayabilir. Bir araba birden fazla kiralanabilir.
- Bir müşteri birden fazla ödeme yapabilir. Bir ödeme yalnızca bir müşteriye aittir.
- Bir telefon numarası yalnızca bir müşteriye ait olabilir. Bir müşterinin birden fazla telefon numarası 
olabilir.
- Bir adres sadece bir müşteriye ait olabilir. Bir müşterinin birden fazla adresi olabilir.
- Bir arabanın yalnızca bir markası vardır. Bir markanın birden fazla arabası olabilir.
- Bir araba yalnızca bir ofiste bulunabilir. Bir ofiste birden fazla araba bulunabilir.
- Bir model yalnızca bir markanın olabilir. Bir markanın birden fazla modeli bulunabilir.
- Bir şehirde birden fazla ofis olabilir. Bir ofis sadece bir şehirde bulur.
- Bir çalışan yalnızca bir ofise kayıtlı olabilir. Bir ofiste birden fazla çalışan olabilir.
- Bir araba birden fazla kiralanabilir. Bir kiralamada yalnızca bir araba bulunur.

### Varlık Bağıntı Modeli
![Varlık Bağıntı Modeli](https://github.com/beyzaerkan/rentacar/blob/main/Varl%C4%B1k%20Ba%C4%9F%C4%B1nt%C4%B1%20Diyagram%C4%B1.png)
