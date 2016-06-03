module Tribe
  class UserFetcher

    def self.create_all
      base_url = "https://clio.mytribehr.com"
      url = "#{base_url}/users.json"
      auth_string = "kyle.doliveira@clio.com:#{ENV["TRIBE_API_KEY"]}"
      basic_auth = Base64.encode64(auth_string).sub("\n", "")
      HTTParty.get(url, headers: {"Authorization" => "Basic #{basic_auth}", "X-API-VERSION" => "2.0.0"}).parsed_response.each do |user_record|
        tribeid = user_record["id"]
        next if user_record["email"] == "help@tribehr.com"
        #next unless user_record["id"].to_i > 196
        user_record = HTTParty.get("#{base_url}/users/#{tribeid}.json", headers: {"Authorization" => "Basic #{basic_auth}", "X-API-VERSION" => "2.0.0"}).parsed_response

        user = User.find_or_initialize_by(id: tribeid)
        assignment = user_record["assignment_record"]
        if assignment["manager"].present?
          manager_id = assignment["manager"]["id"]
        end
        if assignment["job"].present?
          title = assignment["job"]["title"]
        end
        
        if assignment["department"].present?
          department_id = assignment["department"]["id"]
          department_name = assignment["department"]["name"]
          Department.find_or_initialize_by(id: department_id).update_attributes!(name: department_name)
        end

        user.update_attributes!(email: user_record["email"], full_name: user_record["display_name"], title: title, manager_id: manager_id, department_id: department_id)
        
      end
    end

  end
end
