
Процедура ОбновитьФайлНаИС(API_URL,ИмяФайлаДляЗагрузки,Version)
	
	лФайл = Новый Файл(ИмяФайлаДляЗагрузки);

	СтрокаЗапроса = СтрЗаменить(API_URL,"http://infostart.ru", "");
	СтрокаЗапроса = СтрокаЗапроса +	"&v=" + КодироватьСтроку(Version, СпособКодированияСтроки.КодировкаURL);
	
	Разделитель = "241e56c7a3ce4780a258d390258a388a"; 
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла(); 
	
	ВременныйФайл = Новый ЗаписьТекста(ИмяВременногоФайла, КодировкаТекста.ANSI, Символы.ПС, Ложь); 

	ВременныйФайл.ЗаписатьСтроку("--" + Разделитель); 
	ВременныйФайл.ЗаписатьСтроку("Content-Disposition: form-data; name=""file""; filename=""" + лФайл.Имя + """"); 
	ВременныйФайл.ЗаписатьСтроку("Content-Type: application/x-octet-stream"); 
	ВременныйФайл.ЗаписатьСтроку(""); 

	ВременныйФайл.ЗаписатьСтроку(Новый ЧтениеТекста(лФайл.ПолноеИмя,КодировкаТекста.ANSI).Прочитать()); 

	ВременныйФайл.ЗаписатьСтроку("--" + Разделитель); 

	ВременныйФайл.ЗаписатьСтроку("--" + Разделитель + "--"); 
	ВременныйФайл.Закрыть(); 
	
	ВременныйФайл = Новый Файл(ИмяВременногоФайла);
	
	ЗаголовокХТТП = Новый Соответствие(); 
	ЗаголовокХТТП.Вставить("Content-Type", "multipart/form-data; boundary=" + Разделитель); 		
	ЗаголовокХТТП.Вставить("Content-Length", XMLСтрока(ВременныйФайл.Размер()));	
	
	Попытка
		ХТТПСоединение = Новый HTTPСоединение("infostart.ru");
		ХТТПЗапрос = Новый HTTPЗапрос(СтрокаЗапроса, ЗаголовокХТТП);
		ХТТПЗапрос.УстановитьИмяФайлаТела(ИмяВременногоФайла);
		ХТТПОтвет = ХТТПСоединение.ОтправитьДляОбработки(ХТТПЗапрос); 
		responseText = ХТТПОтвет.ПолучитьТелоКакСтроку();
		// Вывод JSON ответа от сервера 
		Сообщить(responseText);   		
		УдалитьФайлы(ИмяВременногоФайла);
	Исключение
		Сообщить("Не удалось установить соединение с сервером :" + Символы.ПС + ИнформацияОбОшибке().Описание);
		УдалитьФайлы(ИмяВременногоФайла);

		Возврат;
	КонецПопытки;
	
КонецПроцедуры


лУРЛ = "http://infostart.ru/public/edit/?a=s&f=615394&h=k^Q5(1Suy^U0zS^84T$k";
лФайл = "c:\temp\test.epf";
лВерсия = "1.2.70";

ОбновитьФайлНаИС(лУРЛ,лФайл,лВерсия);