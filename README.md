Meteor Internationalization (i18n) Library
==========================================

Installation
------------

The package can be installed with [Meteorite](https://github.com/oortcloud/meteorite/).

Type inside your application directory:

``` sh
$ mrt add i18n
```

Usage
-----

To add messages do:

``` javascript
Meteor.i18nMessages.someNamespace = {
  optionalSubNamespace: {  // You can have as many (sub-)sub-namespaces as you like.
    yourMessage: {
      en: {
        US: 'Your {{message}} in American English', // Use {{}} to mark placeholders.
        GB: 'Your {{message}} in British English'
      },
      de: 'Your {{message}} in German'  // Territory is optional
    },
    anUntranslatedMessage: 'Your untranslated message' // If you don't set a language the same message will be returned for all languages.
  }
};
```

To set the current locale do:

``` javascript
Meteor.setLocale('en_US');
```

and to get the current locale do:
``` javascript
Meteor.getLocale(); // en_US
```

The locale is reactive and also stored in the localStorage (`_TranslatorService.locale`) on the client in order to resist a page reload.


To translate a message from within your code simply call:

``` javascript
// A message with placeholder
var translatedMessage = __('someNamespace.optionalSubNamespace.yourMessage', {message: 'some placeholder content'});

// A message without placeholder
var anotherMessage = __('someNamespace.optionalSubNamespace.anUntranslatedMessage');
```

To translate a message inside a template there is a global Handlebars
helper `__`.
Then you can use it your HTML code:

```
{{__ 'someNamespace.optionalSubNamespace.yourMessage' 'some placeholder content'}} 
// Your some placeholder content in American English
```

Questions and Feature Requests
------------------------------

If you have feature requests or other feedback please write to jerico.dev@gmail.com.


Contributions
-------------

Contributions are welcome! Just make a pull request and I'll definitely check it out.

Thanks to [@joernroeder](https://github.com/joernroeder),
[@mcevskb](https://github.com/mcevskb) and [@beshur](https://github.com/beshur)
for their contributions.
