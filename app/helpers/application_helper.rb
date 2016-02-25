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

end
