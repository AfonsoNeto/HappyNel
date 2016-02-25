module ApplicationHelper

	# Renders default message alerts using bootstrap dismissible alerts
	def render_alert(message, message_type="success")
		content_tag(:div, class: "alert alert-dissmissible alert-#{message_type}", role: "alert") do
			concat(button_tag(type: "button", class: "close", data: {dismiss: "alert"}, aria: {label: "Close"}) do
				content_tag(:span, aria: {hidden: true}) do
					content_tag(:i, class: "glyphicon glyphicon-remove"){}
				end
			end)
			concat(content_tag(:strong, message))
		end
	end

	def render_attribute_error_if_any(errors_list, attribute)
		content_tag(:span, class: "error-reason") do
			if errors_list[attribute.to_sym].any?
				errors_list[attribute.to_sym].full_message
			end
		end
	end

end
