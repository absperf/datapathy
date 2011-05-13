module RSpec::HaveErrorsMatcher

  RSpec::Matchers.define :have_errors_on do |attribute|
    match do |resource|
      !resource.errors[attribute].empty?
    end
  end

  RSpec::Matchers.define :have_errors do
    match do |resource|
      !resource.valid?
    end

    failure_message_for_should_not do |resource|
      %{expected #{resource.inspect} to not have any errors, but there were: #{resource.errors.inspect}}
    end
  end

  RSpec.configure { |c| c.include self }
end

