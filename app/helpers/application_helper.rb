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
				errors_list[attribute.to_sym].first
			end
		end
	end

	def formatted_final_result(score)
		raw score.round 2
	end

	def render_stars_count(score)
		score 			= score.round
		total_stars = 5

		html = ""

		# Adds filled stars
		for i in (1..score) do
			html += content_tag :span, class: "glyphicon glyphicon-star" do
			end
		end

		# Adds empty stars
		for j in (1..(total_stars - score)) do
			html += content_tag :span, class: "glyphicon glyphicon-star-empty" do
			end
		end

		raw html
	end

end
