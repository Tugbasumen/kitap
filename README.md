
📚 Yapay Zekâ Destekli Türkçe Kitap Özetleme Mobil Uygulaması

Bu proje, Türkçe kitap açıklamalarını yapay zekâ destekli abstractive özetleme yöntemiyle otomatik olarak özetleyen ve bu özetleri bir mobil uygulama üzerinden kullanıcılara sunan uçtan uca bir sistemdir.

Proje kapsamında veri toplama, özetleme, değerlendirme, veritabanı yönetimi ve mobil uygulama geliştirme aşamaları entegre biçimde gerçekleştirilmiştir.


🎯 Projenin Amacı

Uzun kitap açıklamalarını kısa ve anlamlı özetlere dönüştürmek
Türkçe metinler için yerel büyük dil modeli (LLM) kullanmak
Kullanıcılara mobil uygulama üzerinden hızlı kitap keşfi imkânı sunmak
Özetleme performansını ROUGE metrikleri ile değerlendirmek



🧠 Kullanılan Yöntem

Bu çalışmada abstractive (soyutlayıcı) özetleme yöntemi tercih edilmiştir.

> Model, metinden birebir cümleler seçmek yerine içeriği anlayarak yeni ve özgün cümleler üretmektedir.


🛠 Kullanılan Teknolojiler

🔹 Backend & AI

 Python
 DeepSeek Large Language Model (yerel)
 Flask (REST API)
 Requests
 Pandas, NumPy

🔹 Veri Toplama

 Web Scraping
 BeautifulSoup
 Requests

🔹 Değerlendirme

 ROUGE-1
 ROUGE-2
 ROUGE-L

🔹 Veritabanı

 Firebase Firestore
 Firebase Authentication

🔹 Mobil Uygulama

Flutter


📊 Model Performans Değerlendirmesi

Üretilen özetler, orijinal kitap açıklamalarıyla karşılaştırılarak ROUGE metrikleri kullanılarak değerlendirilmiştir.

ROUGE-1: Kelime örtüşmesi
ROUGE-2: İkili kelime dizileri
ROUGE-L: En uzun ortak alt dizi

Bu metrikler sayesinde modelin içerik koruma başarısı nicel olarak ölçülmüştür.

---

📱 Mobil Uygulama Özellikleri

* Kitap listeleme
* Kitap detay görüntüleme
* Yapay zekâ ile üretilmiş özetler
* Favori kitap ekleme / çıkarma
* Firebase Authentication ile kullanıcı bazlı favoriler




✨ Sonuç

Bu çalışma, yerel büyük dil modellerinin Türkçe metin özetleme görevlerinde etkili biçimde kullanılabileceğini ve mobil uygulamalarla entegre edilebileceğini göstermektedir.

<img width="347" height="711" alt="image" src="https://github.com/user-attachments/assets/8a725c33-3cbf-4b29-9104-0a691553aba3" />
<img width="362" height="752" alt="image" src="https://github.com/user-attachments/assets/52cd3bef-4352-40c1-8cdf-638985da1eb5" />
<img width="405" height="840" alt="image" src="https://github.com/user-attachments/assets/52f6a9d8-b4a7-4954-92fd-0b6064a11933" />
<img width="345" height="729" alt="image" src="https://github.com/user-attachments/assets/027c84e0-c284-4b94-8d2d-9d4983c270d6" />
<img width="346" height="768" alt="image" src="https://github.com/user-attachments/assets/fd476748-a1d6-41b8-8cbb-4d6b93cd9773" />
<img width="337" height="694" alt="image" src="https://github.com/user-attachments/assets/38a79eec-a761-4fc3-8981-63d642ab5efe" />
<img width="342" height="708" alt="image" src="https://github.com/user-attachments/assets/1fa30d21-1f47-4a84-9cd5-b189a420971c" />
<img width="410" height="857" alt="image" src="https://github.com/user-attachments/assets/7e762a2a-789b-44e3-a2e7-387d005cc4fe" />
<img width="376" height="795" alt="image" src="https://github.com/user-attachments/assets/2dfdd9f7-a134-4058-9b07-ca52bfd4b6ac" />
<img width="373" height="775" alt="image" src="https://github.com/user-attachments/assets/b39913a5-9ded-4272-8b81-c1e4511978f5" />
<img width="444" height="949" alt="image" src="https://github.com/user-attachments/assets/2a207d83-8ab8-4a8a-92ba-208d764387ec" />
<img width="444" height="949" alt="image" src="https://github.com/user-attachments/assets/fe7b5785-d8dc-413b-8e72-c209ae6f2612" />
<img width="465" height="970" alt="image" src="https://github.com/user-attachments/assets/a1d3e52c-979e-4faa-af97-6c59af7b5d90" />
