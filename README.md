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
Meteor.i18n.someNamespace = {
  optionalSubNamespace: {  // You can have as many (sub-)sub-namespaces as you like.
    yourMessage: {
      en: {
        US: 'Your {{message}} in American English' // Use {{}} to mark placeholders.
        GB: 'Your {{message}} in British English'
      }
      de: 'Your {{message}} in German'  // Territory is optional
    }
    anUntranslatedMessage: 'Your untranslated message' // If you don't set a language the same message will be returned for all languages.
  }
};
```

To set the current locale do:

``` javascript
Meteor.setLocale('en_US');
```

To translate a message from within your code simply call:

``` javascript
// A message with placeholder
var translatedMessage = __('someNamespace.optionalSubNamespace.yourMessage', {message: 'some placeholder content'});

// A message without placeholder
var anotherMessage = __('someNamespace.optionalSubNamespace.anUntranslatedMessage');
```

Questions
---------

Please write to jerico.dev@gmail.com.
