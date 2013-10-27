/*
Alessandro Crugnola
alessandro@sephiroth.it
http://www.sephiroth.it
*/
package com.adobe.webapis.gettext
{
    import flash.net.*;
    import flash.utils.*;
    import flash.errors.*;
    import flash.events.*;
    import com.adobe.webapis.gettext.Parser;

    /**
    * Internationalization and localization support.
    * This module provides internationalization (I18N) and localization (L10N)
    * support for your Python programs by providing an interface to the GNU gettext
    * message catalog library.
    * I18N refers to the operation by which a program is made aware of multiple
    * languages.  L10N refers to the adaptation of your program, once
    * internationalized, to the local language and cultural habits.
    *
    * Based on gettext.py python module
    */
    public class GetText extends EventDispatcher
    {
        static private var translations:Object;
        private var name:    String;
        private var language:String;
        private var charset: String;
        private var url:     String;
        private var info:    Object;
        private var xstream: URLStream;
        private static var singleton:GetText;

        public static const iso639_languageDict:Object = {
            'aa'    : 'Afar. ',
            'ab'    : 'Abkhazian',
            'ae'    : 'Avestan',
            'af'    : 'Afrikaans',
            'am'    : 'Amharic',
            'ar'    : 'Arabic',
            'as'    : 'Assamese',
            'ay'    : 'Aymara',
            'az'    : 'Azerbaijani',
            'ba'    : 'Bashkir',
            'be'    : 'Byelorussian; Belarusian',
            'bg'    : 'Bulgarian',
            'bh'    : 'Bihari',
            'bi'    : 'Bislama',
            'bn'    : 'Bengali; Bangla',
            'bo'    : 'Tibetan',
            'br'    : 'Breton',
            'bs'    : 'Bosnian',
            'ca'    : 'Catalan',
            'ce'    : 'Chechen',
            'ch'    : 'Chamorro',
            'co'    : 'Corsican',
            'cs'    : 'Czech',
            'cu'    : 'Church Slavic',
            'cv'    : 'Chuvash',
            'cy'    : 'Welsh',
            'da'    : 'Danish',
            'de'    : 'German',
            'dz'    : 'Dzongkha; Bhutani',
            'el'    : 'Greek',
            'en'    : 'English',
            'eo'    : 'Esperanto',
            'es'    : 'Spanish',
            'et'    : 'Estonian',
            'eu'    : 'Basque',
            'fa'    : 'Persian',
            'fi'    : 'Finnish',
            'fj'    : 'Fijian; Fiji',
            'fo'    : 'Faroese',
            'fr'    : 'French',
            'fy'    : 'Frisian',
            'ga'    : 'Irish',
            'gd'    : 'Scots; Gaelic',
            'gl'    : 'Gallegan; Galician',
            'gn'    : 'Guarani',
            'gu'    : 'Gujarati',
            'gv'    : 'Manx',
            'ha'    : 'Hausa (?)',
            'he'    : 'Hebrew (formerly iw)',
            'hi'    : 'Hindi',
            'ho'    : 'Hiri Motu',
            'hr'    : 'Croatian',
            'hu'    : 'Hungarian',
            'hy'    : 'Armenian',
            'hz'    : 'Herero',
            'ia'    : 'Interlingua',
            'id'    : 'Indonesian (formerly in)',
            'ie'    : 'Interlingue',
            'ik'    : 'Inupiak',
            'io'    : 'Ido',
            'is'    : 'Icelandic',
            'it'    : 'Italian',
            'iu'    : 'Inuktitut',
            'ja'    : 'Japanese',
            'jv'    : 'Javanese',
            'ka'    : 'Georgian',
            'ki'    : 'Kikuyu',
            'kj'    : 'Kuanyama',
            'kk'    : 'Kazakh',
            'kl'    : 'Kalaallisut; Greenlandic',
            'km'    : 'Khmer; Cambodian',
            'kn'    : 'Kannada',
            'ko'    : 'Korean',
            'ks'    : 'Kashmiri',
            'ku'    : 'Kurdish',
            'kv'    : 'Komi',
            'kw'    : 'Cornish',
            'ky'    : 'Kirghiz',
            'la'    : 'Latin',
            'lb'    : 'Letzeburgesch',
            'ln'    : 'Lingala',
            'lo'    : 'Lao; Laotian',
            'lt'    : 'Lithuanian',
            'lv'    : 'Latvian; Lettish',
            'mg'    : 'Malagasy',
            'mh'    : 'Marshall',
            'mi'    : 'Maori',
            'mk'    : 'Macedonian',
            'ml'    : 'Malayalam',
            'mn'    : 'Mongolian',
            'mo'    : 'Moldavian',
            'mr'    : 'Marathi',
            'ms'    : 'Malay',
            'mt'    : 'Maltese',
            'my'    : 'Burmese',
            'na'    : 'Nauru',
            'nb'    : 'Norwegian Bokmål',
            'nd'    : 'Ndebele, North',
            'ne'    : 'Nepali',
            'ng'    : 'Ndonga',
            'nl'    : 'Dutch',
            'nn'    : 'Norwegian Nynorsk',
            'no'    : 'Norwegian',
            'nr'    : 'Ndebele, South',
            'nv'    : 'Navajo',
            'ny'    : 'Chichewa; Nyanja',
            'oc'    : 'Occitan; Provençal',
            'om'    : '(Afan) Oromo',
            'or'    : 'Oriya',
            'os'    : 'Ossetian; Ossetic',
            'pa'    : 'Panjabi; Punjabi',
            'pi'    : 'Pali',
            'pl'    : 'Polish',
            'ps'    : 'Pashto, Pushto',
            'pt'    : 'Portuguese',
            'qu'    : 'Quechua',
            'rm'    : 'Rhaeto-Romance',
            'rn'    : 'Rundi; Kirundi',
            'ro'    : 'Romanian',
            'ru'    : 'Russian',
            'rw'    : 'Kinyarwanda',
            'sa'    : 'Sanskrit',
            'sc'    : 'Sardinian',
            'sd'    : 'Sindhi',
            'se'    : 'Northern Sami',
            'sg'    : 'Sango; Sangro',
            'si'    : 'Sinhalese',
            'sk'    : 'Slovak',
            'sl'    : 'Slovenian',
            'sm'    : 'Samoan',
            'sn'    : 'Shona',
            'so'    : 'Somali',
            'sq'    : 'Albanian',
            'sr'    : 'Serbian',
            'ss'    : 'Swati; Siswati',
            'st'    : 'Sesotho; Sotho, Southern',
            'su'    : 'Sundanese',
            'sv'    : 'Swedish',
            'sw'    : 'Swahili',
            'ta'    : 'Tamil',
            'te'    : 'Telugu',
            'tg'    : 'Tajik',
            'th'    : 'Thai',
            'ti'    : 'Tigrinya',
            'tk'    : 'Turkmen',
            'tl'    : 'Tagalog',
            'tn'    : 'Tswana; Setswana',
            'to'    : 'Tonga',
            'tr'    : 'Turkish',
            'ts'    : 'Tsonga',
            'tt'    : 'Tatar',
            'tw'    : 'Twi',
            'ty'    : 'Tahitian',
            'ug'    : 'Uighur',
            'uk'    : 'Ukrainian',
            'ur'    : 'Urdu',
            'uz'    : 'Uzbek',
            'vi'    : 'Vietnamese',
            'vo'    : 'Volapük; Volapuk',
            'wa'    : 'Walloon',
            'wo'    : 'Wolof',
            'xh'    : 'Xhosa',
            'yi'    : 'Yiddish (formerly ji)',
            'yo'    : 'Yoruba',
            'za'    : 'Zhuang',
            'zh'    : 'Chinese',
            'zh_tw' : 'Chinese Transitional',
            'zh_cn' : 'Chinese Simplified',
            'zu'    : 'Zulu'
        }

        public function GetText(caller:Function = null){
        	if(caller != GetText.getInstance){
        		throw new Error("Singleton is a singleton class, use GetText.getInstance() instead");
        	}
        }

		/**
		 * Return the Singleton gettext instance
		 * @return 
		 * 
		 */
		public static function getInstance():GetText
		{
			if (GetText.singleton == null) {
				GetText.singleton = new GetText(arguments.callee);
			}
			return GetText.singleton;
		}

        /**
         * Install the gettext support for the specified application
         * Load the corresponding .mo file located into {prefix}/{language}/LC_MESSAGES/{domain}.mo
         */
        public final function install():void {
			removeXStream();
			
            var req:URLRequest = new URLRequest(this.url + this.getLocale() + '/LC_MESSAGES/' + this.name + '.mo');
            xstream = new URLStream();
            xstream.addEventListener(Event.COMPLETE,         this.handleEvent);
            xstream.addEventListener(Event.OPEN,             this.handleEvent);
            xstream.addEventListener(ProgressEvent.PROGRESS, this.handleEvent);
            xstream.addEventListener(HTTPStatusEvent.HTTP_STATUS,       this.handleEvent);
            xstream.addEventListener(IOErrorEvent.IO_ERROR,             this.handleEvent);
            xstream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleEvent);
			xstream.load(req);
        }
		
		public final function uninstall():void
		{
			removeXStream();
			url = null;
			language = null;
			name = null;
			name = null;
        	language = null;
        	charset = null;
        	url = null;
        	info = null;
        	xstream = null;
			translations = null;
		}
		
		private function removeXStream():void 
		{
			if (xstream)
			{
				xstream.removeEventListener(Event.COMPLETE,         this.handleEvent);
				xstream.removeEventListener(Event.OPEN,             this.handleEvent);
				xstream.removeEventListener(ProgressEvent.PROGRESS, this.handleEvent);
				xstream.removeEventListener(HTTPStatusEvent.HTTP_STATUS,       this.handleEvent);
				xstream.removeEventListener(IOErrorEvent.IO_ERROR,             this.handleEvent);
				xstream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleEvent);
				try {
					xstream.close();
				}catch (err:Error) { }
				xstream = null;
			}
		}


        /**
         * @param domain The application domain (correspond to the .mo filename)
         * @param prefix Where the LC_MESSAGES directory is located, by default it is into 'locale/' dir
         * @param lang   Language file to load
         */
        public final function translation(domain:String, prefix:String, lang:String):void
        {
            url = "locale/";
            if(prefix.length > 0)
            {
                this.url = prefix;
            }

            this.name = domain;
            this.language = lang
        }

        /**
         *
         * @usage   gettext.getLocale();
         * @return  the current iso language
         */
        public function getLocale():String {
            return this.language;
        }


        /**
         * Manage the events returned by the xstream loader
         * 
         * @usage
         * @param   event
         * @return
         */
        protected function handleEvent(event:Event):void
        {
			switch(event.type)
			{
				case Event.COMPLETE :
					var byte:ByteArray = new ByteArray();
					byte.endian = Endian.LITTLE_ENDIAN;
					event.target.readBytes(byte, 0, event.target.bytesAvailable);
					removeXStream();
					try
					{
						var retObject:Object = Parser.parse(byte);
						GetText.translations = retObject.translation;
						this.info            = retObject.info;
						this.charset         = retObject.charset;
					} catch (e:Error) {
						var errEvent:ErrorEvent = new ErrorEvent(ErrorEvent.ERROR, true, false, "EOFError: " + e.message)
						this.dispatchEvent(errEvent);
						return;
					}
					break;
					
				case IOErrorEvent.IO_ERROR :
				case SecurityErrorEvent.SECURITY_ERROR :
					removeXStream();
					break;
			}
            var evt:Event = new Event(event.type, true, true)
            this.dispatchEvent(evt);
        }

        /**
         * Try to translate a string into the current installed language
         * 
         * @usage
         * @param   id the string to be translated
         * @return  translated string, if found. Otherwise returns the passed argument
         */
        public static function translate(id:String):String
		{
            if (GetText.translations && GetText.translations.hasOwnProperty(id))
			{
				return GetText.translations[id];
			}
			
			return id;
        }

		/**
		 * Return the language definition if available
		 * 
		 * @param iso the language code in iso format
		 * @return language description
		 */
        static public function FindLanguageInfo(iso:String):String
        {
            if( iso639_languageDict.hasOwnProperty(iso) ){
                return iso639_languageDict[iso];
            }
            return "";
        }
    }
}