
# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format
# (all these examples are active by default):
ActiveSupport::Inflector.inflections do |inflect|
  inflect.singular /^(status)es$/i, '\1'
  inflect.singular /^(status)$/i, '\1'
end
