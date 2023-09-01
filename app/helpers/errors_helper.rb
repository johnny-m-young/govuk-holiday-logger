module ErrorsHelper
  def error_messages_for(instance)
    return nil if instance.errors.blank?

    error_messages = []

    instance.errors.each do |error|
      error_messages << {
        text: error.full_message,
        href: "##{instance.class.name.underscore}[:#{error.attribute}]",
      }
    end

    error_messages
  end

  def error_message_for_input(instance_errors, attribute)
    return nil if instance_errors[attribute].blank?

    instance_errors.filter_map { |error|
      if error.attribute == attribute
        error.full_message
      end
    }
    .join(tag.br)
    .html_safe
    .presence
  end
end
