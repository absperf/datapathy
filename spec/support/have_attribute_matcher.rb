module RSpec::HaveAttributeMatcher

  RSpec::Matchers.define :have_attributes do |attrs|
    description do
      if attrs.keys.size > 1
        "have attributes #{attrs.inspect}"
      else
        key, value = attrs.keys.first, attrs.values.first
        text = "have attribute #{key}"
        text << "with value #{value.inspect}" unless value == :anything
        text
      end
    end

    match do |obj|
      attrs.all? do |key, expected_value|
        value = if obj.respond_to?(key)
                  obj.send key
                elsif obj.respond_to?(:[])
                  obj[key]
                else
                  false
                end

        case expected_value
        when Class
          value.is_a? expected_value

        when :href
          value =~ %r{^http://}

        when Regexp
          value =~ expected_value

        when :anything
          !value.nil?

        else
          value == expected_value

        end
      end
    end
  end

  RSpec.configure { |c| c.include self }

  def have_attribute(name, value = :anything)
    have_attributes name => value
  end
end
