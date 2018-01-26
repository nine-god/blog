module ApplicationHelper
	def generate_abstract_tag(html,length=200)
		text = strip_tags markdown html
		# text = markdown html
		# text = strip_tags(html)
		text = text.delete("\n\r")[0..length] +" » "
		return raw text
	end
	def markdown(body)
		return nil if body.blank?
		result = BLOG::Markdown.call(body)
		return result
	end
end
