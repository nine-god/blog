module ApplicationHelper
	def generate_abstract_tag(html,length=200)
		text = strip_tags markdown html
		# text = markdown html
		# text = strip_tags(html)
		text = text.delete("\n\r")[0..length] unless text.blank?
		return raw text
	end
	def markdown(body)
		return nil if body.blank?
		result = Blog::Markdown.call(body)
		return result
	end
	def change_time_style(time)
		time.strftime("%Y-%m-%d")
	end
	def generate_pagination(args={})
		limit = args[:limit].to_i
		offset = args[:offset].to_i
		total = args[:total].to_i

		url = request.path
		first_page = 1
		last_page = (total%limit == 0) ? total/limit : total/limit+1
		current_page = offset/limit+1
		arr = []
		arr << "<li>每页#{limit}条,共#{total}条,第<input type='text' id='page_num' style='min-width: 30px;width:50px;' value='#{current_page}'>页<button id='button_go_url' url = '#{url}' limit='#{limit}'type='button' >Go</button>,共#{last_page}页</li>"
		arr << "<li><a href='#{url}?offset=#{(first_page-1)*limit}&&limit=#{limit}' class='link'>首页</a></li>"
		if current_page - first_page == 0
			arr << "<li class='disabled' ><a href='#{url}?offset=#{(current_page-1)*limit}&&limit=#{limit}'>上一页</a></li>"
		else
			arr << "<li><a href='#{url}?offset=#{(current_page-2)*limit}&&limit=#{limit}' class='link'>上一页</a></li>"
		end

		if last_page - current_page == 0
			arr << "<li class='disabled'><a href='#{url}?offset=#{(current_page-1)*limit}&&limit=#{limit}'>下一页</a></li>"
		else
			arr << "<li><a href='#{url}?offset=#{(current_page)*limit}&&limit=#{limit}' class='link'>下一页</a></li>"
		end
		arr << "<li><a href='#{url}?offset=#{(last_page-1)*limit}&&limit=#{limit}' class='link'>尾页</a></li>"
		return raw arr.join("")
	end
	def generate_html_titile(args={})
		controller_name = args[:controller_name]
		case controller_name
		when 'articles'
			case params[:action]
			when "show"
				title = Article.find_by_id(params[:id]).title
			when "new"
				title = "新建博文"
			when "edit"
				title ="编辑博文"
			else
				title = "博文"
			end

			title += " · "
		when 'abouts'
			title = "关于小屋"
			title += " · "
		when 'users'
			if params[:id]
				user = User.find_by_id(params[:id])
				title = "#{user.username}(#{user.name})"
			else
				title = "用户列表"
			end
			title += " · "
		else
			title = ""
		end
		return raw "<title>"+title+"九神小屋"+ "</title>"
	end
end
