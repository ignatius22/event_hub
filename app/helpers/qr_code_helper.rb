module QrCodeHelper
  def qr_code_data_url(text)
    # Generate a simple QR code using Google Chart API
    # For production, consider using a gem like 'rqrcode' or 'rqrcode_png'
    base_url = "https://api.qrserver.com/v1/create-qr-code/"
    params = {
      size: "200x200",
      data: text
    }
    "#{base_url}?#{params.to_query}"
  end

  def registration_qr_code_url(registration)
    qr_code_data_url(registration.qr_code_token)
  end
end
