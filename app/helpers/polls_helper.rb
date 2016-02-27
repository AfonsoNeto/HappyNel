module PollsHelper
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
