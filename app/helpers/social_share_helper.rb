module SocialShareHelper
  def twitter_share_url(event)
    text = "Check out this event: #{event.title}"
    url = event_url(event)
    "https://twitter.com/intent/tweet?text=#{CGI.escape(text)}&url=#{CGI.escape(url)}"
  end

  def facebook_share_url(event)
    url = event_url(event)
    "https://www.facebook.com/sharer/sharer.php?u=#{CGI.escape(url)}"
  end

  def linkedin_share_url(event)
    url = event_url(event)
    "https://www.linkedin.com/sharing/share-offsite/?url=#{CGI.escape(url)}"
  end

  def email_share_url(event)
    subject = "Check out this event: #{event.title}"
    body = "I thought you might be interested in this event:\n\n#{event.title}\n#{event_url(event)}"
    "mailto:?subject=#{CGI.escape(subject)}&body=#{CGI.escape(body)}"
  end

  def whatsapp_share_url(event)
    text = "Check out this event: #{event.title} - #{event_url(event)}"
    "https://wa.me/?text=#{CGI.escape(text)}"
  end
end
