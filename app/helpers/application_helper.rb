module ApplicationHelper
	def markdown(body)
		return nil if body.blank?
		result = BLOG::Markdown.call(body)
		return result
	end
end
