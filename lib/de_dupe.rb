module DeDupe
  def self.notifications
    LetMeKnow::Preference.find_each do |pref|
      pref.unsent_notifications.inject({}) do |found, notification|
        if found[notification.subject_id]
          notification.destroy
        else
          found[notification.subject_id] = true
        end
        found
      end
    end
  end
end
