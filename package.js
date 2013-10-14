Package.describe({
  summary: "A simple i18n package: Call __('...') to translate your message everywhere."
});

Package.on_use(function (api, where) {
  where = where || ['client', 'server'];
  api.use(['underscore'], where);
  api.use('session', 'client');
  api.add_files('translator.js', where);
});
