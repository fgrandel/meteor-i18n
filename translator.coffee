class Meteor._TranslatorService
  constructor: () ->

    resolveParams = (message, params) ->
      for key, value of params
        regexp = new RegExp('\\{\\{' + key + '\\}\\}', 'g')
        message = message.replace regexp, value
      message

    retrieveMessage = (messageId) =>
      # We may have to recurse if the message id contains
      # a dot.
      messageParts = messageId.split('.')
      messageId = messageParts.pop()
      messages = Meteor.i18nMessages
      while messageParts.length
        # Resolve the message namespace.
        messages = messages[messageParts.shift()]

        # Does the message namespace exist?
        unless _.isObject(messages)
          throw Error 'services.translator.missingMessageNamespace'

      # Does the message have a translation?
      message = messages[messageId]
      throw Error 'services.translator.missingMessage' unless message?

      # Is this a cross-language message?
      return message if _.isString(message)

      # Do we have a language-specific message?
      locale = Session.get('_TranslatorService.locale') || 'en_US'

      [language, territory] = locale.split('_')
      message = message[language]
      return message if _.isString(message)

      # Do we have a locale-specific message.
      return message[territory] if _.isString(message?[territory])

      # Try to fall back to the default territory.
      return message.default if _.isString(message?.default)

      # Hm, we have an error in the message structure.
      throw Error 'services.translator.unknownMessageFormat'

    # This is the actual service function.
    @translate = (messageId, params = {}) ->
      try
        # Retrieve the message.
        message = retrieveMessage(messageId)

        # Resolve message parameters.
        resolveParams(message, params)
      catch translationError
        errorMessageId = translationError.message
        errorMessage =
          try
            resolveParams(
              retrieveMessage(errorMessageId),
              messageId: messageId
            )
          catch e
            # Give up and display a generic error message in English
            # to avoid infinite recursion.
            """
            Translation Error: Cannot resolve error
            message '#{errorMessageId}' while translating '#{messageId}'
            """.replace /\n/, ' '
        console.log errorMessage
        '###' + messageId + '###'

    if Meteor.isClient
      localLocale = window.localStorage.getItem '_TranslatorService.locale'
      if localLocale then Meteor.setLocale localLocale

# Public locale setter.
Meteor.setLocale = (locale) ->
  if Meteor.isClient
    window.localStorage.setItem '_TranslatorService.locale', locale

  Session.set('_TranslatorService.locale', locale)


# Public locale getter.
Meteor.getLocale = () ->
  Session.get('_TranslatorService.locale')



# The translator service is a singleton.
Meteor._TranslatorService = new Meteor._TranslatorService()

# Public message configuration with system messages.
Meteor.i18nMessages = {} unless Meteor.i18nMessages?
Meteor.i18nMessages.services =
  translator:
    missingMessageNamespace:
      """
      Translation error: The message namespace of "{{messageId}}" cannot
      be resolved.
      """.replace /\n/, ' '
    missingMessage:
      """
      Translation error: The translation message "{{messageId}}" is
      missing in its message namespace.
      """.replace /\n/, ' '
    unknownMessageFormat:
      'Translation error: Unknown message format for "{{messageId}}".'


# Global shortcut for the translation method.
root = exports ? this
root.__ = Meteor._TranslatorService.translate
